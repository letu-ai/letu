import httpClient from '@/utils/httpClient';


// 通用集成配置接口
export interface IntegrationConfig {
    name: string;
    isEnabled: boolean;
}

export function fetchSettingValues<T>   (name: string): Promise<T> {
    return httpClient.get<void, T>(`/api/admin/integrations/${name}`);
}

export function updateSettingValues<T>(name: string, data: T): Promise<void> {
    return httpClient.post<T, void>(`/api/admin/integrations/${name}`, data);
}

/**
 * 获取所有集成服务状态
 */
export function getIntegrationsStatus() {
    return httpClient.get<void, IntegrationConfig[]>('/api/admin/integrations/enable-status');
}

export function getIntegrationEnableStatus(name: string) {
    return httpClient.get<void, boolean>(`/api/admin/integrations/enable-status/${name}`);
}

export function setIntegrationEnableStatus(name: string, enabled: boolean) {
    return httpClient.put<void, void>(`/api/admin/integrations/enable-status/${name}`, null, {params: { enabled }});
}