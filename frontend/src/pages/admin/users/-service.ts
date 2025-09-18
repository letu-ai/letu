import httpClient from '@/utils/httpClient';
import type { PagedResult, PagedResultRequest } from '@/types/api';

/**
 * 新增用户
 * @param dto
 */
export function addUser(dto: ICreateUserInput) {
    return httpClient.post<ICreateUserInput, void>('/api/admin/users', dto);
}

export function updateUser(id: string, input: IUpdateUserInput) {
    return httpClient.put<IUpdateUserInput, void>(`/api/admin/users/${id}`, input);
}

/**
 * 用户分页列表
 * @param input
 */
export function getUserList(input: IUserListInput) {
    return httpClient.get<IUserListInput, PagedResult<UserListOutput>>('/api/admin/users', { params: input });
}

/**
 * 删除用户
 * @param id
 */
export function deleteUser(id: string) {
    return httpClient.delete<ICreateUserInput, void>(`/api/admin/users/${id}`);
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
    return httpClient.put<string, void>(`/api/admin/users/${id}/enabled`);
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
export function resetPassword(dto: ResetPasswordInput) {
    return httpClient.put<string, void>('/api/admin/users/reset-password', dto);
}


export interface ICreateUserInput {
    userName: string;
    password: string;
    avatar?: string | null;
    nickName?: string | null;
    phone?: string;
    email?: string | null;
    departmentId?: string | null;
    positionId?: string | null;
    employeeId?: string | null;
    organizationUnitId?: string | null;
}

export interface IUpdateUserInput {
    avatar?: string | null;
    nickName?: string | null;
    phone?: string;
    email?: string | null;
    departmentId?: string | null;
    positionId?: string | null;
    employeeId?: string | null;
    organizationUnitId?: string | null;
}


export interface IUserListInput extends PagedResultRequest {
    keyword?: string;
    organizationUnitId?: string;
}

export interface UserListOutput {
    id: string;
    userName: string | null;
    avatar: string | null;
    nickName: string | null;
    isEnabled: boolean;
    phone?: string | null;
    email?: string | null;
    departmentId?: string | null;
    departmentName?: string | null;
    positionId?: string | null;
    positionName?: string | null;
    employeeId?: string | null;
    employeeName?: string | null;
    organizationUnitId?: string | null;
    organizationUnitName?: string | null;
}

export interface AssignRoleDto {
    userId: string;
    roleIds: string[] | null;
}

export interface ResetPasswordInput {
    userId: string;
    password: string;
}