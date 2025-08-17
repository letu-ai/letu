import httpClient from '@/utils/httpClient';
import type { PagedResult, PagedResultRequest } from '@/types/api';

/**
 * 新增租户
 * @param dto
 */
export function addTenant(dto: TenantCreateOrUpdateInput) {
  return httpClient.post<TenantCreateOrUpdateInput, void>('/api/admin/tenants', dto);
}

/**
 * 租户分页列表
 * @param dto
 */
export function getTenantList(dto: TenantListInput) {
  return httpClient.get<TenantListInput, PagedResult<TenantListOutput>>('/api/admin/tenants', { params: dto });
}

/**
 * 修改租户
 * @param id 租户ID
 * @param dto 租户数据
 */
export function updateTenant(id: string, dto: TenantCreateOrUpdateInput) {
  return httpClient.put<TenantCreateOrUpdateInput, void>(`/api/admin/tenants/${id}`, dto);
}

/**
 * 删除租户
 * @param id
 */
export function deleteTenant(id: string) {
  return httpClient.delete<string, void>(`/api/admin/tenants/${id}`);
}

/**
 * 获取版本选项列表
 */
export function getEditionOptions() {
  return httpClient.get<void, IEditionOption[]>('/api/admin/editions/select-list').then(res => {
    return res || [];
  });
}

export interface TenantCreateOrUpdateInput {
  name: string;
  remark?: string | null;
  editionId?: string | null;
  bindDomain?: string | null;
  expireDate?: string | null;
  contactName?: string | null;
  contactPhone?: string | null;
  adminEmail?: string | null;
  websiteName?: string | null;
  logo?: string | null;
  icpNumber?: string | null;
  isActive: boolean;
}

export interface TenantListOutput {
  id: string;
  name: string;
  remark: string | null;
  editionName: string | null;
  bindDomain: string | null;
  expireDate: string | null;
  contactName: string | null;
  contactPhone: string | null;
  adminEmail: string | null;
  websiteName: string | null;
  logo: string | null;
  icpNumber: string | null;
  isActive: boolean;
  creationTime: string;
}

export interface TenantListInput extends PagedResultRequest {
  name?: string | null;
  isActive?: boolean | null;
}

export interface IEditionOption {
  id: string;
  name: string;
  description?: string | null;
}