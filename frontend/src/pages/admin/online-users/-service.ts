import httpClient from '@/utils/httpClient';
import type { PagedResult, PagedResultRequest } from '@/types/api';
import type { ClientType, LoginChannel } from '@/pages/account/-service';

/**
 * 在线用户列表
 * @param dto
 */
export function getOnlineUsers(dto: IOnlineUserListInput) {
  return httpClient.get<IOnlineUserListInput, PagedResult<IOnlineUserListOutput>>(
    '/api/admin/online-users',
    {
      params: dto,
    },
  );
}

/**
 * 注销当前会话
 * @param key
 */
export function onlineUserLogout(input: ISessionRevokeInput) {
  return httpClient.post<ISessionRevokeInput, void>('/api/admin/online-users/revoke', input);
}

export interface IOnlineUserListInput extends PagedResultRequest {
  userName?: string;
}

export interface IOnlineUserListOutput {
  sessionId: string;
  userId: string;
  userName: string | null;
  clientType: ClientType;
  loginChannel: LoginChannel;
  ipAddress: string | null;
  geo: string | null;
  deviceName: string | null;
  userAgent: string | null;
  appVersion: string | null;
  lastActiveTime: string;
  creationTime: string;
}

export interface ISessionRevokeInput {
  userId: string;
  sessionId: string;
}