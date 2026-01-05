/**
 * 个人资料相关 API 服务
 * 参考 frontend/src/pages/my/-service.ts
 */
import httpClient from '@/api/httpClient';
/**
 * 个人资料相关类型定义
 */

export interface IProfileOutput {
    nickName: string;
    avatar?: string;
    phone?: string;
    email?: string;
  }
  
  export interface IProfileUpdateInput {
    nickName: string;
    avatar?: string;
  }
  
  export interface IChangePasswordInput {
    oldPassword: string;
    newPassword: string;
  }
  
  
/**
 * 获取个人信息
 */
export function getProfile(): Promise<IProfileOutput> {
  return httpClient.get<void, IProfileOutput>('/api/my/profile');
}

/**
 * 修改个人基本信息
 */
export function updateProfile(info: IProfileUpdateInput): Promise<void> {
  return httpClient.put<IProfileUpdateInput, void>('/api/my/profile', info);
}

/**
 * 上传头像
 */
export function uploadAvatar(file: { uri: string; type: string; name: string }): Promise<string> {
  const formData = new FormData();
  formData.append('avatar', {
    uri: file.uri,
    type: file.type,
    name: file.name,
  } as any);

  return httpClient.post<FormData, string>('/api/my/profile/avatar', formData, {
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  });
}

/**
 * 修改密码
 */
export function changePassword(input: IChangePasswordInput): Promise<void> {
  return httpClient.put<IChangePasswordInput, void>('/api/my/profile/change-password', input);
}

