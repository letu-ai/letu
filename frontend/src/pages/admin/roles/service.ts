import httpClient from '@/utils/httpClient.ts';
import type { AppResponse, PagedResult, PageSearch, AppOption } from '@/types/api';

/**
 * 新增角色
 * @param dto
 */
export function addRole(dto: RoleDto) {
  return httpClient.post<RoleDto, AppResponse<boolean>>('/api/admin/roles', dto);
}

/**
 * 角色分页列表
 * @param dto
 */
export function getRoleList(dto: RoleQueryDto) {
  return httpClient.get<RoleQueryDto, AppResponse<PagedResult<RoleListDto>>>('/api/admin/roles', { params: dto });
}

/**
 * 修改角色
 * @param dto
 */
export function updateRole(dto: RoleDto) {
  return httpClient.put<RoleDto, AppResponse<boolean>>('/api/admin/roles', dto);
}

/**
 * 删除角色
 * @param id
 */
export function deleteRole(id: string) {
  return httpClient.delete<string, AppResponse<boolean>>(`/api/admin/roles/${id}`);
}

/**
 * 分配菜单
 * @param dto
 */
export function assignMenu(dto: AssignMenuDto) {
  return httpClient.post<AssignMenuDto, AppResponse<boolean>>('/api/admin/roles/assignMenu', dto);
}

/**
 * 获取角色
 */
export function getRoleOptions() {
  return httpClient.get<unknown, AppResponse<AppOption[]>>('/api/admin/roles/options');
}

/**
 * 获取指定角色菜单
 * @param id
 */
export function getRoleMenuIds(id: string) {
  return httpClient.get<string, AppResponse<string[]>>(`/api/admin/roles/${id}/menus`);
}

/**
 * 分配数据
 * @param dto
 */
export function assignData(dto: AssignDataDto) {
  return httpClient.post<AssignDataDto, AppResponse<boolean>>('/api/admin/roles/assignData', dto);
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

export interface RoleQueryDto extends PageSearch {
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
