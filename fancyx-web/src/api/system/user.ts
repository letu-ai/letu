import httpClient from '@/utils/httpClient';
import type { AppResponse, PagedResult, PageSearch } from '@/types/api';

/**
 * 新增用户
 * @param dto
 */
export function addUser(dto: UserDto) {
  return httpClient.post<UserDto, AppResponse<boolean>>('/api/user/add', dto);
}

/**
 * 用户分页列表
 * @param dto
 */
export function getUserList(dto: UserQueryDto) {
  return httpClient.get<UserQueryDto, AppResponse<PagedResult<UserListDto>>>('/api/user/list', { params: dto });
}

/**
 * 删除用户
 * @param id
 */
export function deleteUser(id: string) {
  return httpClient.delete<UserDto, AppResponse<boolean>>('/api/user/delete/' + id);
}

/**
 * 分配角色
 * @param dto
 */
export function assignRole(dto: AssignRoleDto) {
  return httpClient.post<AssignRoleDto, AppResponse<boolean>>('/api/user/assignRole', dto);
}

/**
 * 切换用户启用状态
 * @param id
 */
export function switchUserEnabledStatus(id: string) {
  return httpClient.put<string, AppResponse<boolean>>('/api/user/changeEnabled/' + id);
}

/**
 * 获取指定用户角色
 * @param uid
 */
export function getUserRoleIds(uid: string) {
  return httpClient.get<string, AppResponse<string[]>>('/api/user/roles/' + uid);
}

/**
 * 重置用户密码
 * @param dto
 */
export function resetUserPwd(dto: ResetUserPwdDto) {
  return httpClient.put<string, AppResponse<boolean>>('/api/user/resetPwd', dto);
}

export interface UserDto {
  id?: string | null;
  userName: string;
  password: string;
  avatar?: string | null;
  nickName?: string | null;
  sex: number;
  isEnabled: boolean;
}

export interface UserQueryDto extends PageSearch {
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
