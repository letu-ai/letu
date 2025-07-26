import httpClient from '@/utils/httpClient';
import type { AppResponse, PageSearch, AppOption, PagedResult } from '@/types/api';

/**
 * 新增字典类型
 * @param dto
 */
export function addDictType(dto: DictTypeDto) {
  return httpClient.post<DictTypeDto, AppResponse<boolean>>('/api/dictType/addDictType', dto);
}

/**
 * 分页查询字典类型列表
 */
export function getDictTypeList(dto: DictTypeSearchDto) {
  return httpClient.get<DictTypeSearchDto, AppResponse<PagedResult<DictTypeResultDto>>>(
    '/api/dictType/getDictTypeList',
    { params: dto },
  );
}

/**
 * 修改字典类型
 * @param dto
 */
export function updateDictType(dto: DictTypeDto) {
  return httpClient.put<DictTypeDto, AppResponse<boolean>>('/api/dictType/updateDictType', dto);
}

/**
 * 删除字典类型
 * @param dictType
 */
export function deleteDictType(dictType: string) {
  return httpClient.delete<string, AppResponse<boolean>>('/api/dictType/deleteDictType/' + dictType);
}

/**
 * 批量删除字典类型
 * @param ids
 */
export function deleteDictTypes(ids: string[]) {
  return httpClient.delete<string[], AppResponse<boolean>>('/api/dictType/deleteDictTypes', {
    data: ids,
  });
}

/**
 * 字典选项
 * @param type 字典类型
 * @returns
 */
export function getDictDataOptions(type: string) {
  return httpClient.get<string, AppResponse<AppOption[]>>('/api/dictType/getDictDataOptions?type=' + type);
}

export interface DictTypeDto {
  name: string;
  id?: string | null;
  isEnabled: boolean;
  dictType: string;
  remark?: string | null;
}

export interface DictTypeSearchDto extends PageSearch {
  name?: string | null;
  dictType?: string | null;
}

export interface DictTypeResultDto {
  name: string;
  id: string;
  isEnabled: boolean;
  dictType?: string;
  remark?: string;
}
