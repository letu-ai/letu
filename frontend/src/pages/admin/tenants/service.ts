import httpClient from '@/utils/httpClient';
import type { PagedResult, PagedResultRequest } from '@/types/api';

/**
 * 新增租户
 * @param dto
 */
export function addTenant(dto: TenantDto) {
  return httpClient.post<TenantDto, void>('/api/admin/tenants', dto);
}

/**
 * 租户分页列表
 * @param dto
 */
export function getTenantList(dto: TenantQueryDto) {
  return httpClient.get<TenantQueryDto, PagedResult<TenantListDto>>('/api/admin/tenants', { params: dto });
}

/**
 * 修改租户
 * @param input
 */
export function updateTenant(id: string, input: TenantDto) {
  return httpClient.put<TenantDto, void>(`/api/admin/tenants/${id}`, input);
}

/**
 * 删除租户
 * @param id
 */
export function deleteTenant(id: string) {
  return httpClient.delete<string, void>('/api/admin/tenants/' + id);
}

export interface TenantDto {
  id?: string | null;
  name: string;
  code: string;
  description?: string | null;
  isEnabled: boolean;
}

export interface TenantQueryDto extends PagedResultRequest {
  name?: string | null;
  code?: string | null;
}

export interface TenantListDto {
  id: string;
  name: string;
  code: string;
  description: string | null;
  isEnabled: boolean;
  creationTime: string;
}