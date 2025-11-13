import httpClient from '@/utils/httpClient';
import type { PagedResultRequest, SelectOption, PagedResult } from '@/types/api';

/**
 * 新增字典
 * @param input
 */
export function addDictionary(input: IDictionaryOutput) {
    return httpClient.post<IDictionaryOutput, void>('/api/admin/data-dictionaries', input);
}

/**
 * 分页查询字典列表
 */
export function getDictionaryList(input: IDictionaryListInput) {
    return httpClient.get<IDictionaryListInput, PagedResult<IDictionaryListOutput>>(
        '/api/admin/data-dictionaries',
        { params: input },
    );
}

/**
 * 修改字典
 * @param input
 */
export function updateDictionary(id: string, input: IDictionaryOutput) {
    return httpClient.put<IDictionaryOutput, void>(`/api/admin/data-dictionaries/${id}`, input);
}

/**
 * 删除字典
 * @param id
 */
export function deleteDictionary(id: string) {
    return httpClient.delete<string, void>('/api/admin/data-dictionaries/' + id);
}

/**
 * 批量删除字典
 * @param ids
 */
export function deleteDictionaries(ids: string[]) {
    return httpClient.delete<string[], void>('/api/admin/data-dictionaries', {
        data: ids,
    });
}

/**
 * 字典选项
 * @param name 字典类型
 * @returns
 */
export function getDictionaryOptions(name: string) {
    return httpClient.get<string, SelectOption[]>(`/api/data-dictionaries/${name}/options`);
}

/**
 * 批量获取字典选项
 * @param names 字典类型
 * @returns
 */
export function getDictionaryOptionsBatch(names: string[]) {
    return httpClient.get<string[], Record<string, SelectOption[]>>(`/api/data-dictionaries/options`, {
        params: names,
    });
}


export interface IDictionaryOutput {
    id?: string | null;
    name: string;
    displayName: string;
    isEnabled: boolean;
    remark?: string | null;
}

export interface IDictionaryListInput extends PagedResultRequest {
    name?: string | null;
    displayName?: string | null;
}

export interface IDictionaryListOutput {
    id: string;
    displayName: string;
    name: string;
    isEnabled: boolean;
    remark?: string;
    creationTime: string;
}

/**
 * 新增字典数据
 */
export function addDictionaryItem(dictName: string, input: IDictionaryItemCreateOrUpdateInput) {
    return httpClient.post<IDictionaryItemOutput, void>(`/api/admin/data-dictionaries/${dictName}/items`, input);
}

/**
 * 字典数据分页列表
 * @param input
 * @returns
 */
export function getDictionaryItemList(dictName: string, input: IDictionaryItemListInput) {
    return httpClient.get<IDictionaryItemListInput, PagedResult<IDictionaryItemListOutput>>(`/api/admin/data-dictionaries/${dictName}/items`, {
        params: input,
    });
}

/**
 * 修改字典数据
 */
export function updateDictionaryItem(dictName: string, id: string, input: IDictionaryItemCreateOrUpdateInput) {
    return httpClient.put<IDictionaryItemOutput, void>(`/api/admin/data-dictionaries/${dictName}/items/${id}`, input);
}

/**
 * 删除字典数据
 * @param ids
 * @returns
 */
export function deleteDictionaryItem(dictName: string, ids: string[]) {
    return httpClient.delete<string[], void>(`/api/admin/data-dictionaries/${dictName}/items`, {
        data: ids,
    });
}

export interface IDictionaryItemOutput {
    id?: string | null;
    dictionaryName: string;
    value: string;
    label?: string | null;
    remark?: string | null;
    sort: number;
    isEnabled: boolean;
}


export interface IDictionaryItemCreateOrUpdateInput {
    id?: string | null;
    dictionaryName: string;
    value: string;
    label?: string | null;
    remark?: string | null;
    sort: number;
    isEnabled: boolean;
}

export interface IDictionaryItemListOutput {
    id?: string;
    dictionaryName: string;
    value: string;
    label?: string | null;
    remark?: string | null;
    sort: number;
    isEnabled: boolean;
}

export interface IDictionaryItemListInput extends PagedResultRequest {
    keywords?: string | null;
}