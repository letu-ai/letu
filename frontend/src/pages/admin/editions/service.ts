import httpClient from '@/utils/httpClient';
import type { PagedResult, PagedResultRequest } from '@/types/api';

/**
 * 新增版本
 * @param dto
 */
export function addEdition(dto: EditionCreateOrUpdateInput) {
  return httpClient.post<EditionCreateOrUpdateInput, void>('/api/admin/editions', dto);
}

/**
 * 版本分页列表
 * @param dto
 */
export function getEditionList(dto: EditionListInput) {
  return httpClient.get<EditionListInput, PagedResult<EditionListOutput>>('/api/admin/editions', { params: dto });
}

/**
 * 修改版本
 * @param id 版本ID
 * @param dto 版本数据
 */
export function updateEdition(id: string, dto: EditionCreateOrUpdateInput) {
  return httpClient.put<EditionCreateOrUpdateInput, void>(`/api/admin/editions/${id}`, dto);
}

/**
 * 删除版本
 * @param id
 */
export function deleteEdition(id: string) {
  return httpClient.delete<string, void>(`/api/admin/editions/${id}`);
}

export interface EditionCreateOrUpdateInput {
  name: string;
  description?: string | null;
}

export interface EditionListOutput {
  id: string;
  name: string;
  description: string | null;
  tenantCount: number;
  creationTime: string;
}

export interface EditionListInput extends PagedResultRequest {
  name?: string | null;
} 