# Letu 清理脚本
# 用于清理构建产物和缓存

param(
    [switch]$All = $false,
    [switch]$Frontend = $false,
    [switch]$Backend = $false,
    [switch]$Docker = $false,
    [switch]$Force = $false
)

# 设置错误处理
$ErrorActionPreference = "Stop"

# 颜色输出函数
function Write-ColorOutput {
    param([string]$ForegroundColor, [string]$Message)
    Write-Host $Message -ForegroundColor $ForegroundColor
}

function Write-Step {
    param([string]$Message)
    Write-ColorOutput "Cyan" "`n========================================"
    Write-ColorOutput "Yellow" " $Message"
    Write-ColorOutput "Cyan" "========================================`n"
}

function Write-Success {
    param([string]$Message)
    Write-ColorOutput "Green" "✓ $Message"
}

function Write-Warning {
    param([string]$Message)
    Write-ColorOutput "Yellow" "⚠ $Message"
}

# 获取脚本所在目录
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir
$FrontendDir = Join-Path $RootDir "frontend"
$BackendDir = Join-Path $RootDir "backend"
$ServerDir = Join-Path $BackendDir "Letu.Server"
$TempDir = Join-Path $ScriptDir "temp"

Write-Step "Letu 项目清理工具"

# 如果没有指定任何选项，默认清理所有
if (-not $Frontend -and -not $Backend -and -not $Docker) {
    $All = $true
}

# 确认操作
if (-not $Force) {
    Write-Warning "即将清理以下内容:"
    if ($All -or $Frontend) { Write-Host "  - 前端构建产物和缓存" }
    if ($All -or $Backend) { Write-Host "  - 后端构建产物和缓存" }
    if ($All -or $Docker) { Write-Host "  - Docker 镜像和缓存" }

    $confirm = Read-Host "`n确认清理? (y/N)"
    if ($confirm -ne 'y') {
        Write-ColorOutput "Yellow" "操作已取消"
        exit 0
    }
}

# 清理前端
if ($All -or $Frontend) {
    Write-Step "清理前端项目"

    Push-Location $FrontendDir
    try {
        # 清理 dist
        $dist = Join-Path $FrontendDir "dist"
        if (Test-Path $dist) {
            Write-Host "删除 dist..."
            Remove-Item -Path $dist -Recurse -Force
            Write-Success "dist 已删除"
        }

    } catch {
        Write-Warning "前端清理出现问题: $_"
    }
    Pop-Location
}

# 清理后端
if ($All -or $Backend) {
    Write-Step "清理后端项目"

    Push-Location $ServerDir
    try {
        # 清理临时构建目录
        if (Test-Path $TempDir) {
            Write-Host "删除临时构建目录..."
            Remove-Item -Path $TempDir -Recurse -Force
            Write-Success "临时构建目录已删除"
        }

        # 清理 bin 和 obj
        Write-Host "清理 bin 和 obj 目录..."
        Get-ChildItem -Path $BackendDir -Include bin,obj -Recurse | ForEach-Object {
            Remove-Item -Path $_.FullName -Recurse -Force
            Write-Host "  已删除: $($_.FullName)"
        }
        Write-Success "bin 和 obj 目录已清理"

    } catch {
        Write-Warning "后端清理出现问题: $_"
    }
    Pop-Location
}

# 清理 Docker
if ($All -or $Docker) {
    Write-Step "清理 Docker 资源"

    try {
        # 检查 Docker 是否运行
        docker info 2>$null | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Docker 未运行，跳过 Docker 清理"
        } else {
            # 停止并删除 letu 相关容器
            Write-Host "停止 letu 相关容器..."
            docker ps -a --filter "name=letu" --format "{{.Names}}" | ForEach-Object {
                Write-Host "  停止容器: $_"
                docker stop $_ 2>$null
                docker rm $_ 2>$null
            }
            Write-Success "容器已清理"

            # 删除 letu 镜像
            Write-Host "删除 letu 镜像..."
            docker images --filter "reference=letu*" --format "{{.Repository}}:{{.Tag}}" | ForEach-Object {
                Write-Host "  删除镜像: $_"
                docker rmi $_ 2>$null
            }
            Write-Success "镜像已清理"

            # 清理悬空镜像
            Write-Host "清理悬空镜像..."
            docker image prune -f
            Write-Success "悬空镜像已清理"

            # 清理构建缓存
            Write-Host "清理 Docker 构建缓存..."
            docker builder prune -f
            Write-Success "构建缓存已清理"
        }
    } catch {
        Write-Warning "Docker 清理出现问题: $_"
    }
}

Write-Step "清理完成！"

# 显示磁盘空间
try {
    $drive = (Get-Item $RootDir).PSDrive.Name
    $disk = Get-PSDrive $drive | Select-Object @{Name="Free(GB)";Expression={[math]::Round($_.Free/1GB,2)}}
    Write-ColorOutput "Green" "剩余磁盘空间: $($disk.'Free(GB)') GB"
} catch {
    # 忽略磁盘空间获取错误
}