import httpClient from '@/utils/httpClient';
import type { AppResponse, PagedResult, PageSearch } from '@/types/api';

/**
 * API访问日志列表
 * @param dto
 */
export function getApiAccessLogList(dto: ApiAccessLogQueryDto) {
  return httpClient.get<ApiAccessLogQueryDto, AppResponse<PagedResult<ApiAccessLogListDto[]>>>(
    '/api/OnlineUser/GetOnlineUserList',
    {
      params: dto,
    },
  );
}

/**
 * 异常日志列表
 * @param dto
 */
export function getExceptionLogList(dto: ExceptionLogQueryDto) {
  return httpClient.get<ExceptionLogQueryDto, AppResponse<PagedResult<ExceptionLogListDto[]>>>(
    '/api/OnlineUser/ExceptionLogList',
    {
      params: dto,
    },
  );
}

export interface ApiAccessLogQueryDto extends PageSearch {
  userName?: string;
  path?: string;
}

export interface ApiAccessLogListDto {
  id: string;
  path: string;
  method: string;
  ip: string | null;
  requestTime: string;
  responseTime: string | null;
  duration: number | null;
  userId: string | null;
  userName: string | null;
  requestBody: string | null;
  responseBody: string | null;
  browser: string | null;
  queryString: string | null;
  traceId: string | null;
  operateType: number[] | null;
  operateName: string | null;
}

export interface ExceptionLogListDto {
  id: string;
  exceptionType: string;
  message: string;
  stackTrace: string;
  innerException: string | null;
  requestPath: string | null;
  requestMethod: string | null;
  userId: string | null;
  userName: string | null;
  ip: string | null;
  browser: string | null;
  traceId: string | null;
  isHandled: boolean;
  handledTime: string | null;
  handledBy: string | null;
}

export interface ExceptionLogQueryDto extends PageSearch {
  userName?: string;
}
