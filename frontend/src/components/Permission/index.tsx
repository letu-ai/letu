import React from 'react';
import UserStore from '@/store/userStore.ts';

interface PermissionProps {
  permissions: string | string[]; // 权限码，支持单个或多个
  mode?: 'every' | 'some'; // 权限匹配模式：满足一个或满足所有
  children: React.ReactNode;
  fallback?: React.ReactNode; // 无权限时的替代内容
}

const Permission: React.FC<PermissionProps> = ({ permissions, mode = 'every', children, fallback = null }) => {
  const powers: string[] = UserStore.userInfo?.permissions ?? [];

  // 检查操作权限
  let hasOperationPermission;
  const permissionList: string[] = Array.isArray(permissions) ? permissions : [permissions];
  if (mode === 'every') {
    hasOperationPermission = permissionList.every((p) => powers.includes(p));
  } else {
    hasOperationPermission = permissionList.some((p) => powers.includes(p));
  }
  return hasOperationPermission ? <>{children}</> : <>{fallback}</>;
};

export default Permission;
