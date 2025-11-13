import httpClient from '@/utils/httpClient';
import type { PagedResult, PagedResultRequest, SelectOption } from '@/types/api';

/**
 * 新增角色
 * @param dto
 */
export function addRole(dto: RoleCreateOrUpDateInput) {
  return httpClient.post<RoleCreateOrUpDateInput, void>('/api/admin/roles', dto);
}

/**
 * 角色分页列表
 * @param dto
 */
export function getRoleList(dto: RoleQueryDto) {
  return httpClient.get<RoleQueryDto, PagedResult<RoleListOutput>>('/api/admin/roles', { params: dto });
}

/**
 * 修改角色
 * @param dto
 */
export function updateRole(id: string, dto: RoleCreateOrUpDateInput) {
  return httpClient.put<RoleCreateOrUpDateInput, void>(`/api/admin/roles/${id}`, dto);
}

/**
 * 删除角色
 * @param id
 */
export function deleteRole(id: string) {
  return httpClient.delete<string, void>(`/api/admin/roles/${id}`);
}

/**
 * 获取角色
 */
export function getRoleOptions() {
  return httpClient.get<unknown, SelectOption[]>('/api/admin/roles/options');
}

/**
 * 获取角色权限列表
 * @param roleId 角色ID
 */
export function getRolePermissions(roleId: string) {
  return httpClient.get<unknown, GetPermissionListResultDto>('/api/admin/permission-management/permissions', {
    params: { providerName: 'R', providerKey: roleId }
  });
}

/**
 * 更新角色权限
 * @param roleId 角色ID
 * @param permissions 权限列表
 */
export function updateRolePermissions(roleId: string, permissions: UpdatePermissionDto[]) {
  return httpClient.put<UpdatePermissionsDto, void>('/api/admin/permission-management/permissions', 
    { permissions }, 
    { params: { providerName: 'R', providerKey: roleId } }
  );
}

export interface RoleCreateOrUpDateInput {
  name: string;
  remark?: string | null;
  isEnabled: boolean;
  isDefault: boolean;
  isPublic: boolean;
}

export interface RoleListOutput {
  id: string;
  name: string;
  remark: string | null;
  isEnabled: boolean;
  isDefault: boolean;
  isPublic: boolean;
  isStatic: boolean;
  creationTime: string;
}

export interface RoleQueryDto extends PagedResultRequest {
  name?: string | null;
}

export interface GetPermissionListResultDto {
  entityDisplayName: string;
  groups: PermissionGroupDto[];
}

export interface PermissionGroupDto {
  name: string;
  displayName: string;
  permissions: PermissionDto[];
}

export interface PermissionDto {
  name: string;
  displayName: string;
  parentName: string | null;
  isGranted: boolean;
}

export interface UpdatePermissionDto {
  name: string;
  isGranted: boolean;
}

export interface UpdatePermissionsDto {
  permissions: UpdatePermissionDto[];
}
