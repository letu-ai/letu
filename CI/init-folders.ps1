# 初始化 Docker 部署所需的目录结构

# 获取脚本所在目录
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "创建 Docker 数据目录结构..." -ForegroundColor Cyan

# 创建应用数据目录
$appDirs = @(
    "$ScriptDir\data\app\logs",
    "$ScriptDir\data\app\blobs",
    "$ScriptDir\data\postgres\data",
    "$ScriptDir\data\postgres\backup",
    "$ScriptDir\data\postgres\init",
    "$ScriptDir\data\redis\data",
    "$ScriptDir\config"
)

foreach ($dir in $appDirs) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "✓ 创建目录: $dir" -ForegroundColor Green
    } else {
        Write-Host "  目录已存在: $dir" -ForegroundColor Yellow
    }
}

Write-Host "`n目录结构初始化完成！" -ForegroundColor Green
Write-Host @"

目录说明：
- data/app/logs       : 应用日志
- data/app/blobs     : 上传文件存储
- data/postgres/data  : PostgreSQL 数据文件
- data/postgres/backup: 数据库备份
- data/postgres/init  : 数据库初始化脚本
- data/redis/data     : Redis 持久化数据
- config             : 配置文件目录

注意：这些目录会被 Docker 容器使用，请勿随意删除。
"@ -ForegroundColor Cyan