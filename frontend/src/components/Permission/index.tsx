import React from 'react';
import useConfigStore from '@/application/configStore';

// 权限检查条件接口
interface IPermissionCondition {
  permissions?: string | string[]; // 权限码，支持单个或多个
  permissionMode?: 'every' | 'some'; // 权限匹配模式：满足一个或满足所有
  features?: string | string[]; // 功能特性名称，支持单个或多个
  featureMode?: 'every' | 'some'; // 功能匹配模式：满足一个或满足所有
  globalFeatures?: string | string[]; // 全局功能特性名称，支持单个或多个
  globalFeatureMode?: 'every' | 'some'; // 全局功能匹配模式：满足一个或满足所有
  settings?: SettingCondition | SettingCondition[]; // 设置条件，支持单个或多个
  settingMode?: 'every' | 'some'; // 设置匹配模式：满足一个或满足所有
}

// 设置条件接口
interface SettingCondition {
  name: string; // 设置名称
  value?: string; // 期望的字符串值
  boolValue?: boolean; // 期望的布尔值
  intValue?: number; // 期望的整数值
  operator?: 'equals' | 'notEquals' | 'greaterThan' | 'lessThan' | 'greaterOrEqual' | 'lessOrEqual'; // 比较操作符
}

// 无权限时的渲染策略
type NoPermissionStrategy = 
  | 'fallback'      // 显示fallback内容（默认）
  | 'render'        // 渲染children但可能是禁用状态
  | 'hide'          // 完全不渲染（对于复杂组件）

// 权限组件属性接口
interface PermissionProps extends IPermissionCondition {
  children: React.ReactNode;
  fallback?: React.ReactNode; // 无权限时的替代内容
  loading?: React.ReactNode; // 配置加载中的替代内容
  requireAll?: boolean; // 是否需要满足所有条件（权限、功能、设置）
  noPermissionStrategy?: NoPermissionStrategy; // 无权限时的渲染策略
  disabledProps?: Record<string, any>; // 当使用render策略时，传递给子组件的禁用属性
}

/**
 * 权限检查的核心逻辑函数
 * @param abp ABP Store 实例
 * @param conditions 权限检查条件
 * @returns 是否有权限
 */
function checkPermissions(
  abp: {
    hasError: () => boolean;
    isReady: () => boolean;
    areAllGranted: (...args: string[]) => boolean;
    isAnyGranted: (...args: string[]) => boolean;
    isFeatureEnabled: (name: string) => boolean;
    isGlobalFeatureEnabled: (name: string) => boolean;
    getSettingBoolean: (name: string) => boolean;
    getSettingInt: (name: string) => number;
    getSetting: (name: string) => string | undefined;
  }, 
  conditions: IPermissionCondition & { requireAll?: boolean }
) {
  const {
    permissions,
    permissionMode = 'every',
    features,
    featureMode = 'every',
    globalFeatures,
    globalFeatureMode = 'every',
    settings,
    settingMode = 'every',
    requireAll = true
  } = conditions;

  // 如果 ABP 配置加载失败或未准备好，出于安全考虑返回 false
  if (abp.hasError() || !abp.isReady()) {
    return false;
  }

  const results: boolean[] = [];

  // 检查权限
  if (permissions) {
    const permissionList = Array.isArray(permissions) ? permissions : [permissions];
    let hasPermission: boolean;
    
    if (permissionMode === 'every') {
      hasPermission = abp.areAllGranted(...permissionList);
    } else {
      hasPermission = abp.isAnyGranted(...permissionList);
    }
    
    results.push(hasPermission);
  }

  // 检查功能特性
  if (features) {
    const featureList = Array.isArray(features) ? features : [features];
    let hasFeature: boolean;
    
    if (featureMode === 'every') {
      hasFeature = featureList.every(feature => abp.isFeatureEnabled(feature));
    } else {
      hasFeature = featureList.some(feature => abp.isFeatureEnabled(feature));
    }
    
    results.push(hasFeature);
  }

  // 检查全局功能特性
  if (globalFeatures) {
    const globalFeatureList = Array.isArray(globalFeatures) ? globalFeatures : [globalFeatures];
    let hasGlobalFeature: boolean;
    
    if (globalFeatureMode === 'every') {
      hasGlobalFeature = globalFeatureList.every(feature => abp.isGlobalFeatureEnabled(feature));
    } else {
      hasGlobalFeature = globalFeatureList.some(feature => abp.isGlobalFeatureEnabled(feature));
    }
    
    results.push(hasGlobalFeature);
  }

  // 检查设置
  if (settings) {
    const settingList = Array.isArray(settings) ? settings : [settings];
    
    const checkSetting = (condition: SettingCondition): boolean => {
      const { name, value, boolValue, intValue, operator = 'equals' } = condition;
      
      if (boolValue !== undefined) {
        const actualValue = abp.getSettingBoolean(name);
        return actualValue === boolValue;
      }
      
      if (intValue !== undefined) {
        const actualValue = abp.getSettingInt(name);
        switch (operator) {
          case 'equals':
            return actualValue === intValue;
          case 'notEquals':
            return actualValue !== intValue;
          case 'greaterThan':
            return actualValue > intValue;
          case 'lessThan':
            return actualValue < intValue;
          case 'greaterOrEqual':
            return actualValue >= intValue;
          case 'lessOrEqual':
            return actualValue <= intValue;
          default:
            return actualValue === intValue;
        }
      }
      
      if (value !== undefined) {
        const actualValue = abp.getSetting(name);
        switch (operator) {
          case 'equals':
            return actualValue === value;
          case 'notEquals':
            return actualValue !== value;
          default:
            return actualValue === value;
        }
      }
      
      // 如果没有指定值，检查设置是否存在
      const actualValue = abp.getSetting(name);
      return actualValue !== undefined && actualValue !== null && actualValue !== '';
    };
    
    let hasValidSetting: boolean;
    if (settingMode === 'every') {
      hasValidSetting = settingList.every(checkSetting);
    } else {
      hasValidSetting = settingList.some(checkSetting);
    }
    
    results.push(hasValidSetting);
  }

  // 如果没有任何检查条件，默认返回 true
  if (results.length === 0) {
    return true;
  }

  // 判断是否满足显示条件
  return requireAll ? results.every(result => result) : results.some(result => result);
}

/**
 * 权限检查 Hook
 * 用于在组件渲染前进行权限判断，避免不必要的组件渲染
 * @param conditions 权限检查条件
 * @returns 是否有权限
 * 
 * @example
 * ```tsx
 * // 基本用法
 * const hasCreatePermission = usePermission({ permissions: 'User.Create' });
 * 
 * // 在JSX中使用
 * {usePermission({ permissions: 'Admin.Dashboard' }) && <ComplexDashboard />}
 * 
 * // 组合条件
 * const canManageUsers = usePermission({
 *   permissions: ['User.Create', 'User.Edit'],
 *   features: 'UserManagement.Enable',
 *   requireAll: true
 * });
 * ```
 */
export function usePermission(conditions: IPermissionCondition & { requireAll?: boolean } = {}) {
  const abp = useConfigStore();
  return checkPermissions(abp, conditions);
}

/**
 * 增强的权限控制组件
 * 支持检查权限、功能特性、全局功能特性和设置
 */
const Permission: React.FC<PermissionProps> = ({
  // 权限相关
  permissions,
  permissionMode = 'every',
  // 功能特性相关
  features,
  featureMode = 'every',
  // 全局功能特性相关
  globalFeatures,
  globalFeatureMode = 'every',
  // 设置相关
  settings,
  settingMode = 'every',
  // 其他属性
  children,
  fallback = null,
  loading = null,
  requireAll = true,
  noPermissionStrategy = 'fallback',
  disabledProps = {}
}) => {
  const abp = useConfigStore();

  // 如果 ABP 配置还在加载中，显示加载状态
  if (abp.isLoading()) {
    return <>{loading}</>;
  }

  // 如果 ABP 配置加载失败，出于安全考虑不显示内容
  if (abp.hasError()) {
    console.warn('ABP配置加载失败，权限检查无法进行:', abp.getError());
    return <>{fallback}</>;
  }

  // 如果 ABP 配置未准备好，出于安全考虑不显示内容
  if (!abp.isReady()) {
    return <>{fallback}</>;
  }

  // 使用统一的权限检查逻辑
  const hasPermission = checkPermissions(abp, {
    permissions,
    permissionMode,
    features,
    featureMode,
    globalFeatures,
    globalFeatureMode,
    settings,
    settingMode,
    requireAll
  });
  
  // 如果有权限，直接渲染子组件
  if (hasPermission) {
    return <>{children}</>;
  }

  // 无权限时根据策略处理
  switch (noPermissionStrategy) {
    case 'hide':
      // 完全不渲染
      return null;
      
    case 'render':
      // 渲染子组件但添加禁用属性
      try {
        // 尝试克隆子组件并添加禁用属性
        if (React.isValidElement(children)) {
          return <>{React.cloneElement(children as React.ReactElement<any>, {
            disabled: true,
            ...disabledProps
          })}</>;
        } else {
          // 如果不是单个有效元素，直接渲染
          console.warn('Permission组件：使用render策略时，children应该是单个React元素');
          return <>{children}</>;
        }
      } catch (error) {
        console.warn('Permission组件：克隆子组件失败，直接渲染原组件', error);
        return <>{children}</>;
      }
      
    case 'fallback':
    default:
      // 显示fallback内容
      return <>{fallback}</>;
  }
};

export default Permission;