# 前端路由使用文档

本文档详细说明了本项目中基于文件系统的前端路由生成机制。该机制旨在通过约定简化路由管理，实现路由配置的自动化。

## 核心理念

路由是根据 `frontend/src/pages` 目录下的文件结构自动生成的。你不需要手动维护一个全局的路由配置文件，而是通过创建文件和目录来定义应用的路由。

路由生成逻辑由 `frontend/src/router/dynamic.tsx` 文件实现。

## 路由生成规则

### 1. 基础路由

- 每个 `.tsx` 文件都对应一个路由。
- 路由路径根据文件相对于 `src/pages` 的路径生成。

**示例:**
- `src/pages/home/index.tsx` -> `/home`
- `src/pages/admin/users/index.tsx` -> `/admin/users`

### 2. 默认页面 (`index.tsx`)

- 目录下的 `index.tsx` 文件会成为该目录的默认路由。

**示例:**
- `src/pages/admin/employees/index.tsx` 会生成 `/admin/employees` 路由。

### 3. 动态路由 (`$`)

- 文件名中包含 `$` 符号的部分会转换为动态路由参数。

**示例:**
- `src/pages/admin/data-dictionaries/$type.tsx` 会生成 `/admin/data-dictionaries/:type` 路由。
- `src/pages/admin/loggings/auditLog/request/$id.tsx` 会生成 `/admin/loggings/auditLog/request/:id` 路由。

### 4. 布局页面 (`layout.tsx`)

- 目录下的 `layout.tsx` 文件会作为该目录下所有页面的布局组件。
- 布局组件应包含一个 `Outlet` 组件（来自 `react-router-dom`），用于渲染子路由。
- 如果一个目录有 `layout.tsx`，所有在该目录及子目录下的页面都将使用这个布局。

**示例:**
如果 `src/pages/admin/layout.tsx` 存在，那么访问 `/admin/users` 或 `/admin/roles` 等路由时，会首先渲染 `layout.tsx` 组件，然后在其 `Outlet` 中渲染对应的页面组件。

### 5. 排除文件和目录

以下文件和目录不会被用于生成路由：

- 以 `_` 开头的文件或目录（例如 `_components/`）。
- `components` 目录下的所有文件。
- `layout.tsx` 文件本身不会生成独立路由，它只作为布局。

## 自定义路由 (`route.tsx`)

当自动生成无法满足复杂的路由需求时（例如，具有多个视图的嵌套路由），你可以在目录下创建一个 `route.tsx` 文件来完全控制该目录的路由行为。

### 工作机制

- 当一个目录中存在 `route.tsx` 文件时，**该目录及其所有子目录**的自动路由生成机制将**被禁用**。
- 系统会直接导入 `route.tsx` 文件，并使用其中导出的路由配置。
- `route.tsx` 文件必须默认导出一个符合 `react-router-dom` `RouteObject[]` 类型的数组。

### 示例

`src/pages/admin/loggings/auditLog/route.tsx` 文件就是一个很好的例子，它定义了审计日志模块下的多个嵌套页面：

```tsx
import { type RouteObject } from 'react-router-dom';
import { Navigate } from 'react-router-dom';
import AuditLogging from './index';
import AuditLoggingRequest from './request';
import AuditLoggingRequestDetails from './request/details';
import AuditLoggingEntity from './entity';
import AuditLoggingEntityDetails from './entity/details';

const routes: RouteObject[] = [
  {
    // 父级路由
    path: '/admin/loggings/auditLog',
    element: <AuditLogging />, // 这个组件包含 <Outlet />
    children: [
      {
        path: 'request', // 子路由，最终路径 /admin/loggings/auditLog/request
        element: <AuditLoggingRequest />,
      },
      {
        path: 'request/:id', // 动态子路由
        element: <AuditLoggingRequestDetails />,
      },
      {
        path: 'entity',
        element: <AuditLoggingEntity />,
      },
      {
        path: 'entity/:id',
        element: <AuditLoggingEntityDetails />,
      },
      {
        // 默认重定向到 request 页面
        path: '',
        element: <Navigate to="/admin/loggings/auditLog/request" replace />
      },
    ],
  },
];

export default routes; 
```

## 静态路由

除了上述基于文件系统的动态路由之外，项目还支持在 `frontend/src/router/index.tsx` 文件中定义静态路由。这些路由通常用于定义一些核心、固定的页面，例如登录页、404页、以及主布局框架。

### 定义方式

静态路由直接在该文件中以 `RouteObject` 数组的形式定义和导出。

### 示例: `frontend/src/router/index.tsx`

```tsx
import { type RouteObject } from 'react-router-dom';
import Login from '@/pages/accounts/login';
import Layout from '@/layout';
import NotFound from '@/pages/error/notFound';
// ...其他导入

const routes: RouteObject[] = [
  {
    path: '/login', // 登录页
    element: <Login />,
  },
  {
    path: '/', // 根路径，使用主布局
    element: (
      <Authorize>
        <Layout />
      </Authorize>
    ),
    children: [
      {
        path: '', // 默认子路由，通常是首页
        element: <Home />,
      },
      {
        path: '*', // 404 页面
        element: <NotFound />,
      },
      // ...其他静态子路由
    ],
  },
];

export { routes };
```

## 路由合并

最终，应用的所有路由是由 **静态路由** 和 **动态生成路由** 合并而成的。系统会先加载 `index.tsx` 中的静态路由，然后将所有根据文件系统生成的动态路由作为子路由添加到主布局 (`<Layout />`)下。

## 调试

在开发模式下，所有最终生成的路由结构都会被打印在浏览器的开发者控制台中。你可以通过查看 `🚀 动态路由生成结果:` 的日志来调试和确认路由是否符合预期。

---
通过遵循以上约定，可以高效、清晰地管理项目的前端路由。
