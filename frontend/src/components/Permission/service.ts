import type { TreeSelectOption } from '@/types/api';
import httpClient from '@/utils/httpClient';


export function fetchFeatureTreeSelectOptions(): Promise<TreeSelectOption[]> {
    return httpClient.get<void, TreeSelectOption[]>("/api/admin/permission-management/permissions/tree-options");
}