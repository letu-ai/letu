import React from 'react'

interface PermissionProps {
  permissions?: string | string[]; // 权限码，支持单个或多个
  mode?: 'every' | 'some'; // 权限匹配模式：满足一个或满足所有
  children: React.ReactNode;
  fallback?: React.ReactNode; // 无权限时的替代内容
}

const Permission: React.FC<PermissionProps> =
  ({ permissions, mode = 'every', children, fallback = null }) => {
    // const { UserStore } = useStore()

    // 检查操作权限
    let hasOperationPermission = true
    if (permissions) {
      const permissionList: string[] = Array.isArray(permissions)
        ? permissions
        : [permissions]
      hasOperationPermission = true
    }
    return hasOperationPermission ? (
      <>{children}</>
    ) : (
      <>{fallback}</>
    )
  }

export default Permission
