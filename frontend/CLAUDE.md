# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

Letu AI 是基于风汐管理系统改进的企业级通用Web框架，采用前后端分离架构：
- **前端**: React 18 + TypeScript + Vite + TanStack Router + Ant Design + Shadcn UI + TailwindCSS
- **后端**: .NET 9 + ABP Framework + FreeSql + PostgreSQL

## 前端技术栈

### 核心框架
- **React 19** + **TypeScript 5.9** (strict mode)
- **Vite 7** - 构建工具，支持多应用打包 (admin + ai)
- **TanStack Router 1.131** - 基于文件系统的类型安全路由
- **TanStack Query 5.81** - 服务端状态管理和缓存

### UI 框架
- **Ant Design 6** - 企业级UI组件库（主要用于管理后台）
- **Shadcn UI + Radix UI** - 组件库（20+组件，用于AI模块）
- **TailwindCSS 4.1** - 原子化CSS框架
- **Lucide React** - 图标库

### 状态管理
- **Zustand 5.0** - 轻量级全局状态管理
- **TanStack Query** - 服务端状态管理

### 工具库
- **axios 1.9** - HTTP客户端（支持token自动刷新）
- **dayjs** - 日期处理
- **lodash** - 工具函数
- **zod 4.1.1** - 运行时类型验证
- **react-hook-form** - 表单管理

## 前端项目结构

```
frontend/
├── src/
│   ├── application/           # 应用层配置
│   │   ├── layoutStore.ts     # 布局状态（Zustand）
│   │   ├── themeStore.ts      # 主题配置
│   │   ├── permissions.ts     # 权限常量（与后端同步）
│   │   └── types.ts           # 核心类型定义
│   ├── components/            # 通用组件
│   │   ├── SmartTable/        # 智能表格（核心组件）
│   │   ├── Permission.tsx     # 权限控制组件
│   │   └── layout/            # 布局组件
│   ├── pages/                 # 页面（TanStack Router文件系统路由）
│   │   ├── __root.tsx        # 根路由
│   │   ├── account/          # 账户系统（登录/登出）
│   │   ├── admin/            # 管理后台
│   │   │   ├── users/        # 用户管理
│   │   │   ├── roles/        # 角色权限
│   │   │   ├── departments/  # 部门管理
│   │   │   ├── employees/    # 员工管理
│   │   │   ├── menus/        # 菜单管理
│   │   │   └── route.tsx     # 管理路由配置
│   │   ├── ai/               # AI模块（独立应用）
│   │   │   ├── workflows/    # 工作流管理
│   │   │   ├── file-manager/ # 文件管理
│   │   │   └── route.tsx     # AI路由配置
│   │   ├── my/               # 个人中心
│   │   └── routeTree.gen.ts  # 自动生成的路由树（不要手动编辑）
│   ├── utils/                # 工具函数
│   │   ├── httpClient.tsx    # Axios配置和封装
│   │   ├── authUtils.ts      # 认证工具
│   │   └── tokenRefreshManager.ts # Token刷新管理
│   ├── App.tsx              # 管理后台入口
│   ├── App-ai.tsx           # AI应用入口
│   ├── main.tsx             # 管理后台主入口
│   └── main-ai.tsx          # AI应用主入口
├── index.html               # 管理后台HTML
├── ai.html                  # AI应用HTML
├── package.json
├── vite.config.ts           # Vite配置（双应用）
└── tsconfig.json            # TypeScript配置
```

## 开发命令

```powershell
# 安装依赖（必须使用pnpm）
pnpm install

# 启动开发服务器（http://localhost:8080）
pnpm dev

# 构建生产版本
pnpm build

# 代码检查
pnpm lint

# 预览构建结果
pnpm preview
```

## 路由系统

### 文件系统路由规则

TanStack Router 自动将 `src/pages/` 目录结构映射为路由：

- `src/pages/admin/users/index.tsx` → `/admin/users`
- `src/pages/admin/users/$id.tsx` → `/admin/users/:id`
- `src/pages/admin/route.tsx` → 自定义路由配置（布局、认证等）

### 路由配置文件 (route.tsx)

`route.tsx` 文件用于配置路由级别的布局、认证和权限：

```typescript
// src/pages/admin/route.tsx
export const Route = createRoute({
  getParentRoute: () => rootRoute,
  id: "admin",
  component: AdminLayout,
  beforeLoad: async ({ context }) => {
    // 路由守卫：检查认证
    if (!context.auth.isAuthenticated) {
      throw redirect({ to: "/account/login" });
    }
  },
});
```

### 多应用支持

项目支持两个独立应用：

1. **管理后台** (`index.html` + `main.tsx`)
   - 路径: `/`
   - 功能: 用户管理、角色权限、部门员工等

2. **AI应用** (`ai.html` + `main-ai.tsx`)
   - 路径: `/ai`
   - 功能: AI工作流、文件管理等
   - 开发环境自动路由重写支持

## HTTP 客户端

### 基本使用

```typescript
import { httpClient } from "@/utils/httpClient";

// GET 请求
const users = await httpClient.get<UserDto[]>("/api/admin/users");

// POST 请求
const newUser = await httpClient.post<CreateUserDto, UserDto>(
  "/api/admin/users",
  { name: "张三", email: "zhangsan@example.com" }
);

// PUT 请求
await httpClient.put(`/api/admin/users/${id}`, updateData);

// DELETE 请求
await httpClient.delete(`/api/admin/users/${id}`);
```

### 特殊配置

```typescript
// 匿名请求（不需要token）
await httpClient.get("/api/public/config", { anonymous: true });

// 不显示全局错误消息
await httpClient.post("/api/admin/users", data, {
  showGlobalErrorMessage: false
});
```

### Token自动刷新

- 当收到401响应时，自动调用刷新token接口
- 刷新成功后重试原请求
- 刷新失败则跳转登录页

### 错误处理

系统自动处理以下错误格式：
- **ABP标准错误**: `{ error: { message, code, details } }`
- **RFC 9110验证错误**: `{ type: "https://tools.ietf.org/html/rfc9110#section-15.5.1", errors: {} }`
- **租户解析错误**: 自动跳转到租户错误页

## 权限控制

### 权限定义

权限定义在 [src/application/permissions.ts](src/application/permissions.ts)，与后端 `BasisPermissions.cs` 保持同步：

```typescript
export class BasisPermissions {
  public static readonly User = {
    Default: "Basis.User",
    Create: "Basis.User.Create",
    Update: "Basis.User.Update",
    Delete: "Basis.User.Delete",
  } as const;
}
```

### 组件级权限控制

```typescript
import { Permission } from "@/components/Permission";
import { BasisPermissions } from "@/application/permissions";

<Permission name={BasisPermissions.User.Create}>
  <Button onClick={handleCreate}>创建用户</Button>
</Permission>
```

### 路由级权限控制

在 `route.tsx` 中配置：

```typescript
beforeLoad: async ({ context }) => {
  const hasPermission = await context.auth.checkPermission(
    BasisPermissions.User.Default
  );
  if (!hasPermission) {
    throw redirect({ to: "/403" });
  }
}
```

## 状态管理

### 全局状态 (Zustand)

```typescript
// src/application/layoutStore.ts
import { create } from "zustand";

export const useLayoutStore = create<LayoutState>((set) => ({
  sidebarCollapsed: false,
  toggleSidebar: () => set((state) => ({
    sidebarCollapsed: !state.sidebarCollapsed
  })),
}));

// 使用
import { useLayoutStore } from "@/application/layoutStore";

const { sidebarCollapsed, toggleSidebar } = useLayoutStore();
```

### 服务端状态 (TanStack Query)

```typescript
import { useQuery, useMutation } from "@tanstack/react-query";

// 查询数据
const { data, isLoading } = useQuery({
  queryKey: ["users"],
  queryFn: () => httpClient.get<UserDto[]>("/api/admin/users"),
});

// 修改数据
const mutation = useMutation({
  mutationFn: (data: CreateUserDto) =>
    httpClient.post("/api/admin/users", data),
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ["users"] });
  },
});
```

## 常见开发任务

### 添加新页面

1. 在 `src/pages/` 下创建文件（如 `src/pages/admin/my-feature/index.tsx`）
2. 路由自动生成（重启dev服务器）
3. 如需布局/认证，创建 `route.tsx`
4. 添加权限检查（如需要）

### 添加权限

1. 在 [src/application/permissions.ts](src/application/permissions.ts) 添加权限常量
2. 与后端 `BasisPermissions.cs` 保持一致
3. 使用 `<Permission>` 组件包装需要权限的内容

### API集成

1. 使用 `httpClient` 进行请求
2. 类型使用 TypeScript 接口定义
3. 使用 TanStack Query 管理缓存和状态
4. 错误处理由 `httpClient` 自动处理

### SmartTable使用

SmartTable是核心的表格组件，支持：
- 分页、排序、筛选
- 批量操作
- 列配置
- 导出功能

参考 `src/pages/admin/users/index.tsx` 了解详细用法。

## 样式规范

### TailwindCSS优先

优先使用 TailwindCSS 类名：

```typescript
<div className="flex items-center gap-4 p-4 bg-white rounded-lg">
  <Button className="px-4 py-2 text-white bg-blue-500 hover:bg-blue-600">
    提交
  </Button>
</div>
```

### 条件样式

使用 `clsx` 或 `cn` (tailwind-merge) 合并类名：

```typescript
import { cn } from "@/lib/utils";

<div className={cn(
  "base-class",
  isActive && "active-class",
  isDisabled && "disabled-class"
)}>
  内容
</div>
```

### Ant Design主题

使用 Ant Design 组件时，遵循统一主题配置（在 `App.tsx` 中配置）。

## 重要提醒

1. **必须使用pnpm**: 不要使用npm或yarn
2. **不要手动编辑 routeTree.gen.ts**: 该文件由TanStack Router自动生成
3. **权限常量同步**: 修改权限时，确保前后端一致
4. **字符串使用双引号**: 遵循项目代码风格
5. **成员变量不使用下划线**: C#代码规范，前端保持一致性
6. **Token自动刷新**: 不需要手动处理401错误，httpClient已处理
7. **多应用架构**: 修改 `vite.config.ts` 时注意不要破坏双应用配置

## 后端API地址

开发环境: `http://localhost:5050`
- API文档: `/swagger`
- 健康检查: `/health`

## 相关文档

- [README.md](README.md) - 项目整体介绍
- [docs/frontend-routing.md](docs/frontend-routing.md) - 路由系统详细说明（如存在）
