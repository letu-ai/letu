import httpClient from '@/utils/httpClient';
import type { PagedResult, PagedResultRequest } from '@/types/api';

/**
 * 新增用户
 * @param dto
 */
export function addUser(dto: UserDto) {
  return httpClient.post<UserDto, void>('/api/admin/users', dto);
}

/**
 * 用户分页列表
 * @param dto
 */
export function getUserList(dto: UserQueryDto) {
  return httpClient.get<UserQueryDto, PagedResult<UserListDto>>('/api/admin/users', { params: dto });
}

/**
 * 删除用户
 * @param id
 */
export function deleteUser(id: string) {
  return httpClient.delete<UserDto, void>(`/api/admin/users/${id}`);
}

/**
 * 分配角色
 * @param dto
 */
export function assignRole(userId: string, dto: AssignRoleDto) {
  return httpClient.post<AssignRoleDto, void>(`/api/admin/users/${userId}/assign-role`, dto);
}

/**
 * 切换用户启用状态
 * @param id
 */
export function switchUserEnabledStatus(id: string) {
  return httpClient.put<string, void>(`/api/admin/users/changeEnabled/${id}`);
}

/**
 * 获取指定用户角色
 * @param uid
 */
export function getUserRoleIds(uid: string) {
  return httpClient.get<string, string[]>(`/api/admin/users/${uid}/roles`);
}

/**
 * 重置用户密码
 * @param dto
 */
export function resetUserPwd(dto: ResetUserPwdDto) {
  return httpClient.put<string, void>('/api/admin/users/reset-password', dto);
}

/**
 * 用户简单信息查询
 * @param keyword 账号/昵称
 */
export function getUserSimpleInfos(keyword?: string) {
  return httpClient.get<string, UserSimpleInfoDto[]>('/api/admin/users/simple', {
    params: {
      keyword,
    },
  });
}

export interface UserDto {
  id?: string | null;
  userName: string;
  password: string;
  avatar?: string | null;
  nickName?: string | null;
  sex: number;
  isEnabled: boolean;
  phone?: string;
}

export interface UserQueryDto extends PagedResultRequest {
  userName?: string | null;
}

export interface UserListDto {
  id: string;
  userName: string | null;
  avatar: string | null;
  nickName: string | null;
  sex: number;
  isEnabled: boolean;
}

export interface AssignRoleDto {
  userId: string;
  roleIds: string[] | null;
}

export interface ResetUserPwdDto {
  userId: string;
  password: string;
}

export interface UserSimpleInfoDto {
  id: string;
  userName: string;
  nickName: string;
}
