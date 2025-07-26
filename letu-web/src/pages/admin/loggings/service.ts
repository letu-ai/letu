import httpClient from '@/utils/httpClient';
import type { AppOption, AppResponse, PageSearch, PagedResult } from '@/types/api';

/**
 * 登录日志分页列表
 * @param dto
 */
export function getLoginLogList(dto: LoginLogQueryDto) {
  return httpClient.get<LoginLogQueryDto, AppResponse<PagedResult<LoginLogListDto>>>('/api/loginLog/GetLoginLogList', {
    params: dto,
  });
}

export interface LoginLogQueryDto extends PageSearch {
  userName?: string | null;
  status?: number;
  address?: string | null;
  os?: string | null;
}

export interface LoginLogListDto {
  id: number;
  userName: string;
  ip: string;
  address: string;
  os: string;
  browser?: string;
  isSuccess: boolean;
  operationMsg: string;
  creationTime: string;
}


/**
 * 业务日志分页列表
 * @param dto
 */
export function getBusinessLogList(dto: BusinessLogQueryDto) {
  return httpClient.get<BusinessLogQueryDto, AppResponse<PagedResult<BusinessLogListDto>>>('/api/businessLog/list', {
    params: dto,
  });
}

/**
 * 获取所有业务类型选项
 * @param type
 */
export function getBusinessTypeOptions(type?: string | null) {
  return httpClient.get<string, AppResponse<AppOption[]>>('/api/businessLog/TypeOptions', {
    params: type,
  });
}

export interface BusinessLogQueryDto extends PageSearch {
  type?: string;
  subType?: string;
  content?: string;
}

export interface BusinessLogListDto {
  id: string;
  userName: string;
  type: string;
  subType: string;
  content: string;
  bizNo: string;
  browser: string;
  ip: string;
  creationTime: string;
}


/**
 * API访问日志列表
 * @param dto
 */
export function getApiAccessLogList(dto: ApiAccessLogQueryDto) {
  return httpClient.get<ApiAccessLogQueryDto, AppResponse<PagedResult<ApiAccessLogListDto[]>>>(
    '/api/MonitorLog/ApiAccessLogList',
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
    '/api/MonitorLog/ExceptionLogList',
    {
      params: dto,
    },
  );
}

/**
 * 标记异常日志已处理
 * @param exceptionId
 */
export function handleException(exceptionId: string) {
  return httpClient.post<string, AppResponse<boolean>>('/api/MonitorLog/HandleException?exceptionId=' + exceptionId);
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
  creationTime: string;
}

export interface ExceptionLogQueryDto extends PageSearch {
  userName?: string;
}
