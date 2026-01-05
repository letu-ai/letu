import httpClient from '@/utils/httpClient';
import type { ClientType } from '@/pages/account/-service';

/**
 * 获取我的活动会话列表
 */
export function getMySessions() {
  return httpClient.get<void, IUserSessionListOutput[]>('/api/my/sessions');
}

/**
 * 注销指定会话
 * @param sessionId 会话ID
 */
export function revokeSession(sessionId: string) {
  return httpClient.post<void>(`/api/my/sessions/${sessionId}/revoke`);
}

export interface IUserSessionListOutput {
  id: string;
  clientType: ClientType;
  geo: string | null;
  deviceName: string | null;
  creationTime: string;
  lastActiveTime: string;
}

