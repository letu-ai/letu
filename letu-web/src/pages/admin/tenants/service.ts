import httpClient from '@/utils/httpClient.ts';
import type { AppResponse, PagedResult, PageSearch } from '@/types/api';

/**
 * 新增租户
 * @param dto
 */
export function addTenant(dto: TenantDto) {
  return httpClient.post<TenantDto, AppResponse<boolean>>('/api/admin/tenants', dto);
}

/**
 * 租户分页列表
 * @param dto
 */
export function getTenantList(dto: TenantQueryDto) {
  return httpClient.get<TenantQueryDto, AppResponse<PagedResult<TenantListDto>>>('/api/admin/tenants', { params: dto });
}

/**
 * 修改租户
 * @param dto
 */
export function updateTenant(dto: TenantDto) {
  return httpClient.put<TenantDto, AppResponse<boolean>>('/api/admin/tenants', dto);
}

/**
 * 删除租户
 * @param id
 */
export function deleteTenant(id: string) {
  return httpClient.delete<string, AppResponse<boolean>>(`/api/admin/tenants/${id}`);
}

export interface TenantDto {
  id?: string;
  name: string;
  tenantId: string;
  remark?: string;
  domain?: string;
}

export interface TenantListDto {
  id: string;
  name: string;
  tenantId: string;
  remark?: string;
  domain?: string;
  lastModificationTime: string;
}

export interface TenantQueryDto extends PageSearch {
  keyword?: string;
}
