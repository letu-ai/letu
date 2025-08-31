# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 常用开发命令

### 开发和构建
- `pnpm install` - 安装依赖
- `pnpm dev` - 启动开发服务器 (http://localhost:8080，绑定0.0.0.0支持外部访问)
- `pnpm build` - 构建生产版本 (需要先运行 tsc -b 编译TypeScript)
- `pnpm lint` - 运行ESLint代码检查
- `pnpm preview` - 预览构建版本

### 开发调试
- 开发服务器支持HMR热更新，关闭了错误覆盖层
- 集成了TanStack Router DevTools用于路由调试

## 技术栈

### 核心框架
- **React 18** + **TypeScript 5.9** - 现代React开发
- **TanStack Router 1.131** - 基于文件系统的类型安全路由
- **Vite 6.3** - 下一代构建工具

### 状态管理
- **Zustand 5.0** - 轻量级状态管理
- **TanStack Query 5.81** - 服务端状态管理和缓存

### UI和样式
- **Ant Design 5.25** - 企业级UI组件库
- **TailwindCSS 4.1** - 原子化CSS框架 + Vite插件
- **Sass** - CSS预处理器
- **@iconify/react** - 图标组件库

### 工具库
- **axios 1.9** - HTTP客户端
- **dayjs** - 日期处理库
- **lodash** - 实用工具库
- **zod** - 运行时类型验证
- **clsx + tailwind-merge** - 条件样式合并

### 开发工具
- **ESLint 9** - 代码质量检查
- **Prettier** - 代码格式化
- **TypeScript ESLint** - TypeScript代码规范

## 项目架构

### 目录结构

```
src/
├── api/                    # API相关
│   ├── mqtt.ts            # MQTT实时通信
│   └── oss/               # 对象存储服务
├── application/           # 应用层核心配置
│   ├── appConfigStore.ts  # 全局应用配置状态
│   ├── clientConnection.ts # 客户端连接管理
│   ├── layoutStore.ts     # 布局状态管理
│   ├── themeStore.ts      # 主题配置
│   ├── permissions.ts     # 权限管理
│   ├── types.ts           # 核心类型定义
│   └── string-values/     # 字符串常量
├── components/            # 可复用组件
│   ├── SmartTable/        # 智能表格组件（核心业务组件）
│   ├── Permission.tsx     # 权限控制组件
│   ├── RecipientSelector/ # 收件人选择器
│   ├── layout/            # 布局相关组件
│   └── ...               # 其他通用组件
├── pages/                 # 页面组件（TanStack Router文件系统路由）
│   ├── __root.tsx        # 根路由配置
│   ├── account/          # 账户系统（登录、认证等）
│   ├── admin/            # 管理后台功能模块
│   │   ├── users/        # 用户管理
│   │   ├── roles/        # 角色权限
│   │   ├── departments/  # 部门管理
│   │   ├── notifications/ # 通知管理
│   │   └── ...          # 其他管理功能
│   ├── my/               # 个人中心
│   └── home/             # 首页
├── utils/                # 工具函数
│   ├── httpClient.tsx    # Axios HTTP客户端配置
│   ├── authUtils.ts      # 认证工具
│   └── ...              # 其他工具
├── types/                # 全局类型定义
└── lib/                  # 第三方库扩展
```

### 路由系统

使用TanStack Router的文件系统路由：
- `src/pages/` 目录结构自动映射为路由
- `index.tsx` - 目录默认路由
- `$param.tsx` - 动态路由参数
- `__root.tsx` - 根路由配置，集成DevTools
- `routeTree.gen.ts` - 自动生成的路由树
- 支持自动代码分割

### 核心架构模式

#### 业务模块组织
- 每个功能页面包含对应的 `-service.ts` 文件处理业务逻辑和API调用
- 表单组件使用 `-Form.tsx` 后缀（如 `UserForm.tsx`）
- 模态框组件使用 `-Modal.tsx` 后缀（如 `RecipientModal.tsx`）
- 常量文件使用 `-constants.ts` 后缀

#### 状态管理架构
- **全局应用状态**：使用Zustand (`appConfigStore`, `layoutStore`, `themeStore`)
- **服务端状态**：使用TanStack Query管理API数据
- **组件状态**：优先使用React useState
- **表单状态**：使用Ant Design Form组件

#### 权限控制系统
- **多租户架构**：支持租户隔离和切换
- **角色权限**：基于角色的权限控制系统
- **组件级权限**：使用 `<Permission />` 组件包装需要权限控制的内容
- **路由级权限**：在路由配置中集成权限检查

#### HTTP客户端架构
- 基于axios的统一HTTP客户端，配置在 `utils/httpClient.tsx`
- 支持Token自动刷新和请求拦截
- 统一错误处理和响应格式化
- RFC标准错误格式支持

## 开发规范

### 代码规范
- **包管理**：必须使用pnpm
- **TypeScript**：严格模式 + 复合项目配置，ESLint允许使用any类型
- **组件导出**：使用默认导出
- **路径别名**：使用 `@/` 指向 `src/` 目录

### 文件命名规范
- 组件文件使用PascalCase（如 `SmartTable.tsx`）
- 服务文件使用 `-service.ts` 后缀
- 表单组件使用 `-Form.tsx` 后缀
- 模态框组件使用 `-Modal.tsx` 后缀
- 样式文件使用 `.scss` 扩展名

### 样式开发
- **主要方案**：TailwindCSS 4.1 + Vite插件
- **特殊样式**：使用SCSS文件
- **样式合并**：使用 `clsx` 和 `tailwind-merge`
- **响应式**：使用 `react-responsive` 库

### API集成规范
- HTTP请求统一使用配置好的axios客户端
- API类型定义放在对应的 `-service.ts` 文件中
- 错误处理使用 `ResponseErrorMessage` 组件
- 支持MQTT实时通信集成

### 构建和部署
- Vite配置支持路径别名和插件集成
- TanStack Router插件自动生成路由树和代码分割
- 生产构建前需要TypeScript编译检查 (`tsc -b`)
- ESLint配置包含TanStack Router和React相关规则
- 构建输出目录为 `dist/`

## 核心业务组件

### SmartTable组件
- 企业级智能表格组件，支持分页、排序、筛选
- 集成了布局状态管理和响应式设计
- 支持行选择、自定义操作和导出功能

### 权限系统
- 基于角色的多租户权限控制
- 支持功能级和组件级权限验证
- 集成用户身份验证和会话管理

### 实时通信
- MQTT客户端集成，支持实时消息推送
- 客户端连接状态管理和自动重连
- 支持业务事件和系统通知