import type { SelectOption } from '@/types/api';
import httpClient from '@/utils/httpClient';


export function fetchFeatureSelectOptions(featureValueType?: 'BOOLEAN' | 'NUMERIC' | 'STRING'): Promise<SelectOption[]> {
    const url = featureValueType ? `/api/admin/feature-management/features/select-options/${featureValueType}` : "/api/admin/feature-management/features/select-options";
    return httpClient.get<void, SelectOption[]>(url);
}