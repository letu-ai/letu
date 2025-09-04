# 密码强度计算和验证系统

## 概述

基于系统设置参数，实现了动态的密码强度计算和验证功能，替换了原有的硬编码密码验证规则。

## 功能特性

### 1. 动态配置支持
- 根据系统设置动态调整密码要求
- 支持的配置参数：
  - `Letu.Identity.Password.RequiredLength`: 最小密码长度
  - `Letu.Identity.Password.RequiredUniqueChars`: 唯一字符数量要求
  - `Letu.Identity.Password.RequireNonAlphanumeric`: 是否要求特殊字符
  - `Letu.Identity.Password.RequireLowercase`: 是否要求小写字母
  - `Letu.Identity.Password.RequireUppercase`: 是否要求大写字母
  - `Letu.Identity.Password.RequireDigit`: 是否要求数字

### 2. 智能密码强度计算
- **权重分配系统**：
  - 长度检查：30分（基础分+额外长度奖励）
  - 唯一字符：20分
  - 字符类型检查：各12.5分（小写、大写、数字、特殊字符）
  
- **强度等级**：
  - 弱 (0-29分)：红色 `#f5222d`
  - 一般 (30-59分)：橙色 `#fa8c16`
  - 良好 (60-84分)：黄色 `#fadb14`
  - 强 (85-100分)：绿色 `#52c41a`

### 3. 实时验证和反馈
- 实时密码强度指示器
- 违规项提示（如："缺少大写字母、长度不足"）
- 动态要求说明显示
- 表单验证规则自动生成

## 技术实现

### 核心工具类 (`passwordUtils.ts`)

#### 主要函数

```typescript
// 计算密码强度
calculatePasswordStrength(password: string, config: PasswordConfig): PasswordStrengthResult

// 验证密码是否符合要求
validatePassword(password: string, config: PasswordConfig): PasswordValidationResult

// 生成Ant Design表单验证规则
generatePasswordRules(config: PasswordConfig): Rule[]

// 获取密码要求描述
getPasswordRequirements(config: PasswordConfig): string[]
```

#### 类型定义

```typescript
interface PasswordConfig {
  requiredLength: number;
  requiredUniqueChars: number;
  requireNonAlphanumeric: boolean;
  requireLowercase: boolean;
  requireUppercase: boolean;
  requireDigit: boolean;
}

interface PasswordStrengthResult {
  score: number;
  strength: 'weak' | 'fair' | 'good' | 'strong';
  color: string;
  text: string;
  violations: string[];
}
```

## 更新的页面和组件

### 1. 用户密码修改页面 (`/my/password`)
- 实时密码强度显示
- 动态密码要求说明
- 违规项提示

### 2. 管理员用户新增 (`admin/users/-UserModal.tsx`)
- 基于配置的密码验证规则
- 替换硬编码的正则表达式验证

### 3. 管理员密码重置 (`admin/users/-ResetUserPwdForm.tsx`)
- 统一的密码验证标准
- 动态配置支持

## 配置示例

### 严格配置
```typescript
{
  requiredLength: 12,
  requiredUniqueChars: 8,
  requireNonAlphanumeric: true,
  requireLowercase: true,
  requireUppercase: true,
  requireDigit: true,
}
```

### 宽松配置
```typescript
{
  requiredLength: 6,
  requiredUniqueChars: 1,
  requireNonAlphanumeric: false,
  requireLowercase: true,
  requireUppercase: false,
  requireDigit: true,
}
```

## 用户体验改进

1. **实时反馈**：用户输入时立即看到密码强度和改进建议
2. **清晰指引**：动态显示当前配置的密码要求
3. **一致性**：所有密码输入场景使用统一的验证标准
4. **可配置性**：管理员可以通过设置调整密码策略

## 兼容性说明

- 保持向后兼容，当配置不可用时使用默认值
- 渐进式增强，原有功能不受影响
- TypeScript 类型安全保证

## 测试

创建了测试文件 `passwordUtils.test.ts` 用于验证功能正确性和演示使用方法。

## 未来扩展

1. 支持密码历史检查（避免重复使用旧密码）
2. 支持常见密码黑名单检查
3. 支持密码复杂度评分的自定义权重配置
4. 支持多语言密码要求描述
