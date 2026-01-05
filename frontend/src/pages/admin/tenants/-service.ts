import httpClient from '@/utils/httpClient';
import type { PagedResult, PagedResultRequest } from '@/types/api';
import { getApiBaseUrl } from '@/utils/urlUtils';

/**
 * 新增租户
 * @param dto
 */
export async function addTenant(dto: TenantCreateOrUpdateInput) {
    return await httpClient.post<TenantCreateOrUpdateInput, void>('/api/admin/tenants', dto);
}

/**
 * 租户分页列表
 * @param dto
 */
export async function getTenantList(dto: TenantListInput) {
    return await httpClient.get<TenantListInput, PagedResult<TenantListOutput>>('/api/admin/tenants', { params: dto });
}

/**
 * 修改租户
 * @param id 租户ID
 * @param dto 租户数据
 */
export async function updateTenant(id: string, dto: TenantCreateOrUpdateInput) {
    return await httpClient.put<TenantCreateOrUpdateInput, void>(`/api/admin/tenants/${id}`, dto);
}

/**
 * 删除租户
 * @param id
 */
export async function deleteTenant(id: string) {
    return await httpClient.delete<string, void>(`/api/admin/tenants/${id}`);
}

/**
 * 获取版本选项列表
 */
export async function getEditionOptions() {
    return await httpClient.get<void, IEditionOption[]>('/api/admin/editions/select-list');
}

/**
 * 获取租户Logo
 * @param id 租户ID
 * @param logo 租户Logo
 */
export  function getLogoUrl(id: string, logo: string) {
    return `${getApiBaseUrl()}/api/admin/tenants/${id}/${logo}`;
}

/**
 * 上传租户Logo
 * @param file 文件
 */
export async function uploadLogo(id: string, file: File) {
    const formData = new FormData();
    formData.append('file', file);
    return await httpClient.put<FormData, string>(`/api/admin/tenants/${id}/logo`, formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
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
    adminEmail: string;
    adminPassword: string;
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
    tableSuffix: number;
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