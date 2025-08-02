import httpClient from '@/utils/httpClient';
import type { PagedResultRequest, AppOption, PagedResult } from '@/types/api';

/**
 * 新增字典类型
 * @param dto
 */
export function addDictType(dto: DictTypeDto) {
  return httpClient.post<DictTypeDto, void>('/api/admin/data-dictionaries/types', dto);
}

/**
 * 分页查询字典类型列表
 */
export function getDictTypeList(dto: DictTypeSearchDto) {
  return httpClient.get<DictTypeSearchDto, PagedResult<DictTypeResultDto>>(
    '/api/admin/data-dictionaries/types',
    { params: dto },
  );
}

/**
 * 修改字典类型
 * @param dto
 */
export function updateDictType(dto: DictTypeDto) {
  return httpClient.put<DictTypeDto, void>('/api/admin/data-dictionaries/types', dto);
}

/**
 * 删除字典类型
 * @param dictType
 */
export function deleteDictType(dictType: string) {
  return httpClient.delete<string, void>('/api/admin/data-dictionaries/types/' + dictType);
}

/**
 * 批量删除字典类型
 * @param ids
 */
export function deleteDictTypes(ids: string[]) {
  return httpClient.delete<string[], void>('/api/admin/data-dictionaries/types', {
    data: ids,
  });
}

/**
 * 字典选项
 * @param type 字典类型
 * @returns
 */
export function getDictDataOptions(type: string) {
  return httpClient.get<string, AppOption[]>('/api/admin/data-dictionaries/types/type-options?type=' + type);
}

export interface DictTypeDto {
  name: string;
  id?: string | null;
  isEnabled: boolean;
  dictType: string;
  remark?: string | null;
}

export interface DictTypeSearchDto extends PagedResultRequest {
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

/**
 * 新增字典数据
 */
export function addDictData(dto: DictDataDto) {
  return httpClient.post<DictDataDto, void>('/api/admin/data-dictionaries', dto);
}

/**
 * 字典数据分页列表
 * @param dto
 * @returns
 */
export function getDictDataList(dto: DictDataQueryDto) {
  return httpClient.get<DictDataQueryDto, PagedResult<DictDataListDto>>('/api/admin/data-dictionaries', {
    params: dto,
  });
}

/**
 * 修改字典数据
 */
export function updateDictData(dto: DictDataDto) {
  return httpClient.put<DictDataDto, void>('/api/admin/data-dictionaries', dto);
}

/**
 * 删除字典数据
 * @param ids
 * @returns
 */
export function deleteDictData(ids: string[]) {
  return httpClient.delete<string[], void>('/api/admin/data-dictionaries', {
    data: ids,
  });
}

export interface DictDataDto {
  id?: string | null;
  values: string;
  label: string;
  dictType: string;
  remark?: string | null;
  sort: number;
  isEnabled: boolean;
}

export interface DictDataListDto {
  id?: string;
  values: string;
  label: string;
  dictType: string;
  remark?: string | null;
  sort: number;
  isEnabled: boolean;
}

export interface DictDataQueryDto extends PagedResultRequest {
  key?: string | null;
  label?: string | null;
  dictType?: string | null;
}