# Letu 自动化构建脚本
# 用于编译前后端项目并生成 Docker 镜像

param(
    [string]$Version = "latest",
    [string]$ImageName = "letu",
    [switch]$SkipFrontend = $false,
    [switch]$SkipBackend = $false,
    [switch]$SkipDocker = $false,
    [switch]$Push = $false,
    [string]$Registry = ""
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

function Write-Error {
    param([string]$Message)
    Write-ColorOutput "Red" "✗ $Message"
    exit 1
}

# 获取脚本所在目录
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir
$FrontendDir = Join-Path $RootDir "frontend"
$BackendDir = Join-Path $RootDir "backend"
$ServerDir = Join-Path $BackendDir "Letu.Server"

# 临时构建目录
$TempDir = Join-Path $ScriptDir "temp"
$BuildDir = Join-Path $TempDir "build"
$BuildAppDir = Join-Path $BuildDir "app"
$BuildWwwRootDir = Join-Path $BuildAppDir "wwwroot"

Write-Step "开始构建 Letu 项目"
Write-Host "版本: $Version"
Write-Host "镜像名称: $ImageName"
Write-Host "根目录: $RootDir"
Write-Host "构建目录: $BuildDir"

# 检查必要的工具
Write-Step "检查构建工具"

# 检查 Node.js 和 pnpm
if ($SkipFrontend -eq $false) {
    try {
        $nodeVersion = node --version
        Write-Success "Node.js 版本: $nodeVersion"
    } catch {
        Write-Error "未找到 Node.js，请先安装 Node.js"
    }

    try {
        $pnpmVersion = pnpm --version
        Write-Success "pnpm 版本: $pnpmVersion"
    } catch {
        Write-Error "未找到 pnpm，请运行: npm install -g pnpm"
    }
}

# 检查 .NET SDK
if ($SkipBackend -eq $false) {
    try {
        $dotnetVersion = dotnet --version
        Write-Success ".NET SDK 版本: $dotnetVersion"
    } catch {
        Write-Error "未找到 .NET SDK，请先安装 .NET 9 SDK"
    }
}

# 检查 Docker
if ($SkipDocker -eq $false) {
    try {
        $dockerVersion = docker --version
        Write-Success "Docker 版本: $dockerVersion"
    } catch {
        Write-Error "未找到 Docker，请先安装 Docker Desktop"
    }
}

# 构建前端项目
if ($SkipFrontend -eq $false) {
    Write-Step "构建前端项目"

    Push-Location $FrontendDir
    try {
        Write-Host "安装前端依赖..."
        pnpm install
        if ($LASTEXITCODE -ne 0) {
            throw "前端依赖安装失败"
        }
        Write-Success "前端依赖安装成功"

        Write-Host "编译前端项目..."
        pnpm build
        if ($LASTEXITCODE -ne 0) {
            throw "前端编译失败"
        }
        Write-Success "前端编译成功"
    } catch {
        Pop-Location
        Write-Error $_
    }
    Pop-Location

    # 准备临时构建目录
    Write-Step "准备构建目录"

    if (Test-Path $BuildDir) {
        Write-Host "清理旧的构建目录..."
        Remove-Item -Path $BuildDir -Recurse -Force
    }

    Write-Host "创建构建目录..."
    New-Item -Path $BuildAppDir -ItemType Directory -Force | Out-Null
    New-Item -Path $BuildWwwRootDir -ItemType Directory -Force | Out-Null
    Write-Success "构建目录准备完成"

    # 复制前端文件到构建目录
    Write-Step "复制前端文件到构建目录"

    $FrontendDist = Join-Path $FrontendDir "dist"
    if (Test-Path $FrontendDist) {
        Write-Host "复制前端文件到 wwwroot..."
        Copy-Item -Path "$FrontendDist\*" -Destination $BuildWwwRootDir -Recurse -Force
        Write-Success "前端文件复制成功"
    } else {
        Write-Error "前端 dist 目录不存在"
    }
} else {
    Write-ColorOutput "Yellow" "跳过前端构建"

    # 即使跳过前端构建，也需要准备构建目录
    if (-not (Test-Path $BuildWwwRootDir)) {
        Write-Host "创建构建目录..."
        New-Item -Path $BuildAppDir -ItemType Directory -Force | Out-Null
        New-Item -Path $BuildWwwRootDir -ItemType Directory -Force | Out-Null
    }
}

# 构建后端项目
if ($SkipBackend -eq $false) {
    Write-Step "构建后端项目"

    Push-Location $ServerDir
    try {
        Write-Host "清理后端项目..."
        dotnet clean
        if ($LASTEXITCODE -ne 0) {
            throw "后端清理失败"
        }

        Write-Host "还原 NuGet 包..."
        dotnet restore
        if ($LASTEXITCODE -ne 0) {
            throw "NuGet 包还原失败"
        }
        Write-Success "NuGet 包还原成功"

        Write-Host "发布后端项目到临时目录..."
        dotnet publish -c Release -o $BuildAppDir --no-restore
        if ($LASTEXITCODE -ne 0) {
            throw "后端发布失败"
        }
        Write-Success "后端发布成功"
    } catch {
        Pop-Location
        Write-Error $_
    }
    Pop-Location
} else {
    Write-ColorOutput "Yellow" "跳过后端构建"
}

# 复制数据库初始化相关文件
Write-Step "准备数据库初始化文件"

# 创建数据库脚本目录
$BuildDbScriptsDir = Join-Path $BuildAppDir "dbscripts"
New-Item -Path $BuildDbScriptsDir -ItemType Directory -Force | Out-Null

# 复制数据库初始化SQL文件
$DbScriptsSource = Join-Path $RootDir "dbscripts\pgsql\table_struct_data.sql"
if (Test-Path $DbScriptsSource) {
    Copy-Item -Path $DbScriptsSource -Destination $BuildDbScriptsDir -Force
    Write-Success "数据库初始化SQL文件复制成功"
} else {
    Write-Error "数据库初始化SQL文件不存在: $DbScriptsSource"
}

# 复制数据库初始化脚本
$InitDbScript = Join-Path $ScriptDir "init-db.sh"
if (Test-Path $InitDbScript) {
    Copy-Item -Path $InitDbScript -Destination $BuildAppDir -Force
    Write-Success "数据库初始化脚本复制成功"
} else {
    Write-Error "数据库初始化脚本不存在: $InitDbScript"
}

# 构建 Docker 镜像
if ($SkipDocker -eq $false) {
    Write-Step "构建 Docker 镜像"

    Push-Location $RootDir
    try {
        $dockerTag = "${ImageName}:${Version}"
        if ($Registry) {
            $dockerTag = "${Registry}/${dockerTag}"
        }

        Write-Host "构建镜像: $dockerTag"
        docker build -f "$ScriptDir\Dockerfile" -t $dockerTag $ScriptDir
        if ($LASTEXITCODE -ne 0) {
            throw "Docker 镜像构建失败"
        }
        Write-Success "Docker 镜像构建成功: $dockerTag"

        # 如果不是 latest，也标记为 latest
        if ($Version -ne "latest") {
            $latestTag = "${ImageName}:latest"
            if ($Registry) {
                $latestTag = "${Registry}/${latestTag}"
            }

            docker tag $dockerTag $latestTag
            Write-Success "已标记为: $latestTag"
        }

        # 推送到 Registry
        if ($Push) {
            Write-Step "推送 Docker 镜像"

            if (-not $Registry) {
                Write-Error "推送镜像需要指定 -Registry 参数"
            }

            Write-Host "推送镜像: $dockerTag"
            docker push $dockerTag
            if ($LASTEXITCODE -ne 0) {
                throw "Docker 镜像推送失败"
            }
            Write-Success "镜像推送成功: $dockerTag"

            if ($Version -ne "latest") {
                Write-Host "推送镜像: $latestTag"
                docker push $latestTag
                Write-Success "镜像推送成功: $latestTag"
            }
        }
    } catch {
        Pop-Location
        Write-Error $_
    }
    Pop-Location
} else {
    Write-ColorOutput "Yellow" "跳过 Docker 构建"
}

Write-Step "构建完成！"

# 输出运行说明
Write-ColorOutput "Green" @"

运行 Docker 容器:

1. 首次运行，先初始化目录:
   .\CI\init-folders.ps1

2. 使用 docker-compose 运行（推荐）:
   docker-compose -f CI/docker-compose.yml up -d

3. 或使用 docker run 命令:
   docker run -d \
     --name letu \
     -p 5050:5050 \
     -v ${RootDir}\CI\data\app\logs:/app/logs \
     -v ${RootDir}\CI\data\app\upload:/app/upload \
     -e ConnectionStrings__Default="Host=postgres;Port=5432;Database=letu;User ID=postgres;Password=yourpassword;" \
     -e Redis__Configuration="redis:6379,password=redis123" \
     ${ImageName}:${Version}
"@