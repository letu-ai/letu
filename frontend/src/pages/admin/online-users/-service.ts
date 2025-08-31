import httpClient from '@/utils/httpClient';
import type { PagedResult, PagedResultRequest } from '@/types/api';

/**
 * 在线用户列表
 * @param dto
 */
export function getOnlineUsers(dto: OnlineUserSearchDto) {
  return httpClient.get<OnlineUserSearchDto, PagedResult<OnlineUserResultDto>>(
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

export interface OnlineUserSearchDto extends PagedResultRequest {
  userName?: string;
}

export interface OnlineUserResultDto {
  userId: string;
  userName: string;
  ip: string | null;
  address?: string;
  os: string | null;
  creationTime: string;
  sessionId: string;
}

export interface ISessionRevokeInput {
  userId: string;
  sessionId: string;
}