# Letu CI/CD 自动化构建系统

本目录包含 Letu 项目的自动化构建和部署脚本，使用 PowerShell 实现前后端编译、打包和 Docker 镜像生成。

## 快速开始

### 1. 初始化目录结构

```powershell
# 首次部署时，创建必要的目录
.\CI\init-folders.ps1
```

### 2. 一键构建

```powershell
# 构建项目并生成 Docker 镜像
.\CI\build.ps1

# 指定版本号构建
.\CI\build.ps1 -Version "1.0.0"
```

### 3. 运行容器

```powershell
# 使用 Docker 直接运行
docker run -d `
  --name letu `
  -p 5050:5050 `
  -e ConnectionStrings__Default="Host=localhost;Port=5432;Database=letu;User ID=postgres;Password=yourpassword;" `
  -e Redis__Configuration="127.0.0.1:6379" `
  letu:latest

# 或使用 docker-compose（推荐）
docker-compose -f CI/docker-compose.yml up -d
```

## 环境要求

### 构建环境

- **Windows 11** 或 Windows 10
- **PowerShell 5.1** 或更高版本
- **Node.js 18+** 和 **pnpm**
- **.NET 9 SDK**
- **Docker Desktop for Windows**

### 运行环境

- **Docker** 或任何支持容器的环境
- **PostgreSQL 14+** 数据库
- **Redis 6+** 缓存服务器

## 脚本说明

### build.ps1 - 主构建脚本

完整的构建流程，包括前端编译、后端发布和 Docker 镜像生成。

**参数：**

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `-Version` | Docker 镜像版本标签 | `latest` |
| `-ImageName` | Docker 镜像名称 | `letu` |
| `-SkipFrontend` | 跳过前端构建 | `$false` |
| `-SkipBackend` | 跳过后端构建 | `$false` |
| `-SkipDocker` | 跳过 Docker 镜像构建 | `$false` |
| `-Push` | 推送镜像到 Registry | `$false` |
| `-Registry` | Docker Registry 地址 | 空 |

**示例：**

```powershell
# 完整构建
.\CI\build.ps1

# 只构建后端和 Docker（跳过前端）
.\CI\build.ps1 -SkipFrontend

# 构建并推送到私有 Registry
.\CI\build.ps1 -Version "1.0.0" -Registry "registry.example.com" -Push
```

### clean.ps1 - 清理脚本

清理构建产物、缓存和 Docker 资源。

**参数：**

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `-All` | 清理所有内容 | `$false` |
| `-Frontend` | 只清理前端 | `$false` |
| `-Backend` | 只清理后端 | `$false` |
| `-Docker` | 只清理 Docker | `$false` |
| `-Force` | 跳过确认提示 | `$false` |

**示例：**

```powershell
# 清理所有构建产物
.\CI\clean.ps1 -All

# 只清理前端
.\CI\clean.ps1 -Frontend

# 强制清理（不提示确认）
.\CI\clean.ps1 -All -Force
```

## 环境变量配置

应用通过环境变量进行配置，ASP.NET Core 使用双下划线（`__`）作为配置层级分隔符。

### 必需的环境变量

#### 1. 数据库连接字符串

```bash
ConnectionStrings__Default="Host=localhost;Port=5432;Database=letu;User ID=postgres;Password=yourpassword;"
```

**参数说明：**
- `Host`: PostgreSQL 服务器地址
- `Port`: 端口号（默认 5432）
- `Database`: 数据库名称
- `User ID`: 数据库用户名
- `Password`: 数据库密码

#### 2. Redis 配置

```bash
Redis__Configuration="127.0.0.1:6379"
```

**格式：** `主机地址:端口号`

### 配置方法

#### 方法 1：直接传递环境变量

```powershell
docker run -d `
  -p 5050:5050 `
  -e ConnectionStrings__Default="Host=db;Port=5432;Database=letu;User ID=postgres;Password=pass;" `
  -e Redis__Configuration="redis:6379" `
  letu:latest
```

#### 方法 2：使用 .env 文件

1. 复制 `.env.example` 为 `.env`
2. 修改配置值
3. 运行容器时指定 env 文件：

```bash
docker run -d -p 5050:5050 --env-file CI/.env letu:latest
```

#### 方法 3：使用 docker-compose

1. 修改 `docker-compose.yml` 中的环境变量
2. 运行：

```bash
docker-compose -f CI/docker-compose.yml up -d
```

## Docker Compose 部署

`docker-compose.yml` 提供了完整的应用栈，包括：

- **letu**: 主应用服务
- **postgres**: PostgreSQL 数据库（可选）
- **redis**: Redis 缓存（可选）

### 使用外部数据库

如果你已有外部的 PostgreSQL 和 Redis，可以：

1. 注释掉 `docker-compose.yml` 中的 `postgres` 和 `redis` 服务
2. 修改 `letu` 服务的环境变量，指向外部服务地址
3. 移除 `depends_on` 配置

### 数据持久化

所有数据都映射到主机的 `./data` 目录下：

```
CI/data/
├── app/
│   ├── logs/          # 应用日志文件
│   └── upload/        # 用户上传的文件
├── postgres/
│   ├── data/          # PostgreSQL 数据文件
│   ├── backup/        # 数据库备份目录
│   └── init/          # 初始化SQL脚本（可选）
└── redis/
    └── data/          # Redis 持久化数据
```

**重要提示：**
- 首次运行前执行 `.\CI\init-folders.ps1` 创建目录结构
- 定期备份 `data` 目录以防数据丢失
- 不要在容器运行时直接修改数据文件

## 构建流程

1. **前端构建**
   - 进入 `frontend` 目录
   - 执行 `pnpm install` 安装依赖
   - 执行 `pnpm build` 编译项目
   - 复制 `dist/*` 到 `backend/Letu.Server/wwwroot`

2. **后端构建**
   - 进入 `backend/Letu.Server` 目录
   - 执行 `dotnet restore` 还原包
   - 执行 `dotnet publish -c Release` 发布项目

3. **Docker 镜像**
   - 使用 `mcr.microsoft.com/dotnet/aspnet:9.0` 基础镜像
   - 复制发布文件到容器
   - 设置环境变量和入口点
   - 暴露 5050 端口

## 故障排查

### 构建失败

1. **前端构建失败**
   - 确保已安装 Node.js 18+ 和 pnpm
   - 尝试清理缓存：`.\CI\clean.ps1 -Frontend`
   - 手动安装依赖：`cd frontend && pnpm install`

2. **后端构建失败**
   - 确保已安装 .NET 9 SDK
   - 清理构建缓存：`.\CI\clean.ps1 -Backend`
   - 检查 NuGet 源配置

3. **Docker 构建失败**
   - 确保 Docker Desktop 正在运行
   - 检查磁盘空间
   - 清理 Docker 缓存：`docker system prune -a`

### 运行时问题

1. **数据库连接失败**
   - 检查 PostgreSQL 服务是否运行
   - 验证连接字符串参数
   - 确保数据库用户有足够权限
   - 如果使用 Docker 网络，使用服务名称而非 localhost

2. **Redis 连接失败**
   - 检查 Redis 服务是否运行
   - 验证 Redis 地址和端口
   - 如果使用 Docker 网络，使用服务名称而非 localhost

3. **端口冲突**
   - 检查 5050 端口是否被占用
   - 修改端口映射：`-p 8080:5050`

## 生产部署建议

1. **使用具体版本号**：避免使用 `latest` 标签，使用具体版本号
2. **配置 HTTPS**：生产环境应配置 SSL 证书
3. **使用密钥管理**：使用 Docker Secrets 或密钥管理服务
4. **资源限制**：在 docker-compose 中设置 CPU 和内存限制
5. **日志管理**：配置日志驱动和日志轮转
6. **健康检查**：添加健康检查端点和配置
7. **备份策略**：定期备份数据库和重要数据

## 常见命令

```powershell
# 查看容器日志
docker logs letu-app

# 进入容器
docker exec -it letu-app /bin/bash

# 查看容器状态
docker ps -a

# 停止并删除容器
docker stop letu-app && docker rm letu-app

# 查看镜像
docker images | grep letu

# 删除镜像
docker rmi letu:latest
```

## 支持

如有问题，请查看项目文档或提交 Issue。