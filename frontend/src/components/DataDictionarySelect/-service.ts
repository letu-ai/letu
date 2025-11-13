import httpClient from "@/utils/httpClient";
import type { SelectOption } from "@/types/api";

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
 * @param names 字典类型数组
 * @returns
 */
export function getDictionaryOptionsBatch(names: string[]) {
    return httpClient.get<string[], Record<string, SelectOption[]>>("/api/data-dictionaries/options", {
        params: names,
    });
}