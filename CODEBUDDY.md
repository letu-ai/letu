# CODEBUDDY.md

This file provides guidance to CodeBuddy Code when working with code in this repository.

## Project Overview

乐途开源框架 (Letu) is a full-stack web application framework built on ABP Framework and designed for AI-assisted development. It features a modular .NET 9 backend with PostgreSQL/FreeSql and a modern React frontend with TailwindCSS.

**Key Features:**
- Multi-tenant architecture with role-based permissions
- Real-time communication via MQTT and SignalR
- Object storage (local/Aliyun OSS)
- Task scheduling with Quartz.NET
- Comprehensive audit logging

## Development Commands

### Backend (.NET 9 + ABP Framework)

**Location:** `backend/` directory

```powershell
# Build entire solution
dotnet build

# Run Web API (from backend/Letu.Server/)
dotnet run

# Run in development mode
dotnet run --environment Development

# Publish for production
dotnet publish -c Release

# Clean solution
dotnet clean

# Restore NuGet packages
dotnet restore
```

**Database Setup:**
- Execute SQL scripts from `dbscripts/pgsql/` directory
- Configure PostgreSQL connection in `appsettings.json`
- Default connection: `localhost:5432`

### Frontend (React + Vite + TailwindCSS)

**Location:** `frontend/` directory

```bash
# Install dependencies (required: pnpm)
pnpm install

# Start development server (http://localhost:8080)
pnpm dev

# Build for production (includes TypeScript compilation)
pnpm build

# Run linting
pnpm lint

# Preview production build
pnpm preview
```

## Architecture Overview

### Backend Architecture (.NET 9)

**Core Modules:**
- `Letu.Server` - Web API entry point and configuration
- `Letu.Basis` - Core business logic (accounts, admin, permissions)
- `Letu.Core` - Common utilities and infrastructure
- `Letu.Repository` - Data access layer with FreeSql
- `Letu.Abp.FreeSql` - ABP Framework + FreeSql integration
- `Letu.Logging` - Audit and exception logging
- `Letu.ObjectStorage` - File storage (local/Aliyun OSS)
- `Letu.Job` - Quartz.NET task scheduling
- `Letu.Shared` - Shared constants and utilities

**Technology Stack:**
- ABP Framework 9.2.3 with .NET 9
- PostgreSQL via FreeSql ORM
- Redis caching and message queuing
- JWT authentication
- MQTT + SignalR for real-time features
- Serilog for structured logging

**Key Configuration:**
- Multi-tenancy: Supported but disabled by default
- Default ports: HTTP(5000), HTTPS(5001), MQTT(1883)
- Redis: `127.0.0.1:6379`

### Frontend Architecture (React 18)

**Core Technologies:**
- React 18 + TypeScript 5.9
- TanStack Router (file-system routing)
- Zustand (global state) + TanStack Query (server state)
- Ant Design 5.25 + TailwindCSS 4.1
- Vite 6.3 build system

**Directory Structure:**
```
frontend/src/
├── api/                    # API clients and MQTT
├── application/           # Core app state and config
├── components/            # Reusable components
│   ├── SmartTable/       # Enterprise table component
│   ├── Permission.tsx    # Permission control wrapper
│   └── layout/           # Layout components
├── pages/                # File-system routes
│   ├── __root.tsx       # Root route with DevTools
│   ├── account/         # Authentication
│   ├── admin/           # Management modules
│   └── my/              # Personal dashboard
├── utils/               # HTTP client and utilities
└── types/               # Global type definitions
```

**Routing System:**
- File-system routing via TanStack Router
- Automatic code splitting and route generation
- Type-safe navigation and parameters
- DevTools integration for debugging

**State Management:**
- Global app state: Zustand stores (`layoutStore`, `themeStore`)
- Server state: TanStack Query for API data caching
- Component state: React useState
- Form state: Ant Design Form components

**Permission System:**
- Multi-tenant role-based access control
- Component-level permissions via `<Permission />` wrapper
- Route-level permission guards
- JWT token management with auto-refresh

## Development Patterns

### Backend Conventions
- Follow ABP Framework layered architecture
- DTOs in module `Dtos/` folders
- AutoMapper profiles: `*AutoMapperProfile` classes
- Controllers organized by feature in `Controllers/` subdirectories
- Use implicit usings and nullable reference types
- No underscore prefixes for member variables

### Frontend Conventions
- **Package Manager:** Must use pnpm
- **File Naming:** PascalCase for components, kebab-case for utilities
- **Component Exports:** Use default exports
- **Path Alias:** `@/` points to `src/` directory
- **Service Files:** Use `-service.ts` suffix
- **Form Components:** Use `-Form.tsx` suffix
- **Modal Components:** Use `-Modal.tsx` suffix

### API Integration
- Unified HTTP client in `utils/httpClient.tsx`
- Automatic token refresh and error handling
- RFC-standard error format support
- MQTT integration for real-time features

### Styling Approach
- Primary: TailwindCSS 4.1 with Vite plugin
- Secondary: SCSS for complex styles
- Style merging: `clsx` + `tailwind-merge`
- Responsive design: `react-responsive` library

## Key Business Components

### SmartTable Component
Enterprise-grade table with pagination, sorting, filtering, row selection, and export capabilities. Integrates with layout state management and responsive design.

### Permission System
Multi-tenant RBAC system with component-level and route-level access control. Supports user authentication, session management, and automatic permission validation.

### Real-time Communication
MQTT client integration with automatic reconnection, business event handling, and system notifications via SignalR Hub.

## Configuration Files

### Backend Configuration
- `appsettings.json` - Database, Redis, JWT, OSS, MQTT settings
- `common.props` - Shared project properties (.NET 9, nullable types)
- Connection strings and service endpoints in appsettings

### Frontend Configuration  
- `vite.config.ts` - Build configuration with TanStack Router plugin
- `package.json` - Dependencies and scripts
- `.env.*` files - Environment-specific settings
- `tsconfig.json` - TypeScript compiler options

## Database Management

### PostgreSQL Setup
1. Configure connection string in `backend/Letu.Server/appsettings.json`
2. Execute initialization scripts from `dbscripts/pgsql/` directory
3. FreeSql handles schema migrations and seed data automatically
4. Default database: `localhost:5432`

### Development Database
- Uses FreeSql ORM with Code First approach
- Automatic seed data execution on startup
- Entity configurations in respective modules
- Audit logging for all entity changes