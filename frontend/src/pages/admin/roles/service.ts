import httpClient from '@/utils/httpClient';
import type { PagedResult, PagedResultRequest, AppOption } from '@/types/api';

/**
 * 新增角色
 * @param dto
 */
export function addRole(dto: RoleDto) {
  return httpClient.post<RoleDto, void>('/api/admin/roles', dto);
}

/**
 * 角色分页列表
 * @param dto
 */
export function getRoleList(dto: RoleQueryDto) {
  return httpClient.get<RoleQueryDto, PagedResult<RoleListDto>>('/api/admin/roles', { params: dto });
}

/**
 * 修改角色
 * @param dto
 */
export function updateRole(dto: RoleDto) {
  return httpClient.put<RoleDto, void>(`/api/admin/roles/${dto.id}`, dto);
}

/**
 * 删除角色
 * @param id
 */
export function deleteRole(id: string) {
  return httpClient.delete<string, void>(`/api/admin/roles/${id}`);
}

/**
 * 分配菜单
 * @param dto
 */
export function assignMenu(dto: AssignMenuDto) {
  return httpClient.put<AssignMenuDto, void>(`/api/admin/roles/${dto.roleId}/menus`, dto);
}

/**
 * 获取角色
 */
export function getRoleOptions() {
  return httpClient.get<unknown, AppOption[]>('/api/admin/roles/options');
}

/**
 * 获取指定角色菜单
 * @param id
 */
export function getRoleMenuIds(id: string) {
  return httpClient.get<string, string[]>(`/api/admin/roles/${id}/menus`);
}

/**
 * 分配数据
 * @param dto
 */
export function assignData(dto: AssignDataDto) {
  return httpClient.put<AssignDataDto, void>(`/api/admin/roles/${dto.roleId}/data`, dto);
}

export interface RoleDto {
  id?: string | null;
  roleName: string;
  remark?: string | null;
  isEnabled: boolean;
}

export interface RoleListDto {
  id: string;
  roleName: string;
  remark: string | null;
  isEnabled: boolean;
  creationTime: string;
}

export interface RoleQueryDto extends PagedResultRequest {
  roleName?: string | null;
}

export interface AssignMenuDto {
  menuIds: string[] | null;
  roleId: string;
}

export interface AssignDataDto {
  roleId: string;
  powerDataType: number;
  deptIds: string[] | null;
}
