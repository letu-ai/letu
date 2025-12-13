import httpClient from '@/utils/httpClient';
import type { SelectOption, PagedResultRequest, PagedResult } from '@/types/api';

/**
 * 登录日志分页列表
 * @param dto
 */
export function getLoginLogList(dto: LoginLogQueryDto) {
  return httpClient.get<LoginLogQueryDto, PagedResult<LoginLogListDto>>('/api/admin/logs/security', {
    params: dto,
  });
}

export interface LoginLogQueryDto extends PagedResultRequest {
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
  return httpClient.get<BusinessLogQueryDto, PagedResult<BusinessLogListDto>>('/api/admin/logs/business', {
    params: dto,
  });
}

/**
 * 获取所有业务类型选项
 * @param type
 */
export function getBusinessTypeOptions(type?: string | null) {
  return httpClient.get<string, SelectOption[]>('/api/admin/logs/business/type-options', {
    params: type,
  });
}

export interface BusinessLogQueryDto extends PagedResultRequest {
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
 * 获取日志文件列表
 */
export function getLogFileList(dto: LogFileQueryDto) {
  return httpClient.get<LogFileQueryDto, PagedResult<ILogFileListOutput>>('/api/admin/logs/system', {
    params: dto,
  });
}

/**
 * 读取日志文件内容（分页）
 */
export function getLogFileContent(filePath: string, skip: number = 0, take: number = 100) {
  return httpClient.get<never, LogFileContentDto>('/api/admin/logs/system/content', {
    params: { filePath, skip, take },
  });
}

/**
 * 下载日志文件
 */
export function downloadLogFile(filePath: string) {
  return httpClient.get<never, Blob>('/api/admin/logs/system/download', {
    params: { filePath },
    responseType: 'blob',
  });
}

export interface LogFileQueryDto extends PagedResultRequest {
  month?: string;
}

export interface ILogFileListOutput {
  fileName: string;
  filePath: string;
  fileSize: number;
  creationTime: string;
  lastWriteTime: string;
  isCompressed: boolean;
  month: string;
}

export interface LogFileContentDto {
  lines: string[];
  totalLines: number;
  skip: number;
  take: number;
  hasMore: boolean;
}

export interface CleanupResultDto {
  compressedCount: number;
  deletedCount: number;
}