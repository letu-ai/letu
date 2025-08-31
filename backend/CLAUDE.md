# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目架构

这是一个基于 ABP Framework 9.2.3 和 .NET 9 的模块化企业级后端系统，使用 FreeSql 作为 ORM。

### 核心模块结构
- **Letu.Server**: Web API 入口项目，包含启动配置
- **Letu.Basis**: 核心业务模块，包含账户、管理功能、权限管理等
- **Letu.Core**: 通用工具和基础设施层
- **Letu.Repository**: 数据访问层，封装 FreeSql 仓储
- **Letu.Abp.FreeSql**: ABP Framework 与 FreeSql 的集成模块
- **Letu.Logging**: 日志管理模块（API访问日志、异常日志等）
- **Letu.ObjectStorage**: 对象存储服务（支持本地和阿里云 OSS）
- **Letu.Job**: 基于 Quartz 的任务调度模块
- **Letu.Shared**: 共享常量和工具类

### 技术栈
- **框架**: ABP Framework 9.2.3 + .NET 9
- **数据库**: PostgreSQL (通过 FreeSql)
- **缓存**: Redis + StackExchange.Redis
- **身份认证**: JWT Token
- **消息队列**: DotNetCore.CAP (Redis Streams)
- **实时通信**: MQTT + SignalR Hub
- **任务调度**: Quartz.NET
- **对象映射**: AutoMapper
- **日志**: Serilog

## 常用命令

### 构建和运行
```powershell
# 构建整个解决方案
dotnet build

# 运行 Web API (在 Letu.Server 目录下)
dotnet run

# 发布项目
dotnet publish -c Release
```

### 数据库相关
- 项目使用 FreeSql 进行数据访问，支持 Code First
- 默认连接 PostgreSQL 数据库 (localhost:5432)
- 种子数据在应用启动时自动执行

### 开发和调试
```powershell
# 清理解决方案
dotnet clean

# 还原 NuGet 包
dotnet restore

# 运行开发环境
dotnet run --environment Development
```

## 核心配置

### 连接字符串和服务配置
- **数据库**: PostgreSQL (appsettings.json 中的 ConnectionStrings:Default)
- **Redis**: 127.0.0.1:6379
- **Web 端点**: HTTP(5000) / HTTPS(5001)
- **MQTT 端口**: 1883

### 关键功能模块
- **多租户**: 支持但默认未启用 (MultiTenancyConsts.IsEnabled)
- **权限管理**: 基于 ABP 权限系统，支持用户和角色权限
- **特性管理**: 支持版本和租户特性管理
- **审计日志**: 完整的操作审计和实体变更跟踪
- **通知系统**: 支持实时通知推送
- **文件存储**: 支持本地和阿里云 OSS
- **安全日志**: 记录用户安全相关操作

### 代码约定
- 使用 C# 隐式 using 和可空引用类型
- 成员变量不使用下划线前缀
- 遵循 ABP Framework 的分层架构和命名约定
- DTO 类放在各模块的 Dtos 文件夹中
- AutoMapper 配置通过 *AutoMapperProfile 类管理

### API 结构
- 控制器按功能模块组织在 Controllers 文件夹下
- 管理相关 API 放在 Controllers/Admin 目录
- 个人相关 API 放在 Controllers/Personal 目录
- 账户相关 API 放在 Controllers/Account 目录