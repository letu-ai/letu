import httpClient from '@/utils/httpClient';
import type { PagedResult, PagedResultRequest } from '@/types/api';

/**
 * 请求审计日志列表
 * @param dto
 */
export function getRequestLogList(dto: RequestLogQueryDto) {
  return httpClient.get<RequestLogQueryDto, PagedResult<RequestLogDto[]>>(
    '/api/admin/auditlog',
    {
      params: dto,
    },
  );
}

/**
 * 获取请求审计日志详情
 * @param id 审计日志ID
 */
export function getRequestLogDetails(id: string) {
  return httpClient.get<null, RequestLogDto>(
    `/api/admin/auditlog/${id}`,
  );
}

/**
 * 实体变更日志列表
 * @param dto
 */
export function getEntityChangeLogList(dto: EntityChangeLogQueryDto) {
  return httpClient.get<EntityChangeLogQueryDto, PagedResult<EntityChangeLogDto[]>>(
    '/api/admin/auditlog/entity-changes',
    {
      params: dto,
    },
  );
}

/**
 * 获取实体变更日志详情
 * @param id 实体变更日志ID
 */
export function getEntityChangeLogDetails(id: string) {
  return httpClient.get<null, EntityChangeLogDto>(
    `/api/admin/auditlog/entity-changes/${id}`,
  );
}

export interface RequestLogQueryDto extends PagedResultRequest {
  userName?: string;
  url?: string;
  httpMethod?: string;
  httpStatusCode?: number;
  hasException?: boolean;
  minExecutionDuration?: number;
  maxExecutionDuration?: number;
  startTime?: string;
  endTime?: string;
  correlationId?: string;
  applicationName?: string;
}

export interface EntityChangeLogQueryDto extends PagedResultRequest {
  userName?: string;
  entityTypeFullName?: string;
  changeType?: number;
  entityId?: string;
  startTime?: string;
  endTime?: string;
}

export interface RequestLogDto {
  id: string;
  userId?: string;
  userName?: string;
  tenantId?: string;
  impersonatorUserId?: string;
  impersonatorTenantId?: string;
  executionTime: string;
  executionDuration: number;
  clientIpAddress?: string;
  clientName?: string;
  browserInfo?: string;
  httpMethod?: string;
  url?: string;
  exceptions?: string;
  comments?: string;
  httpStatusCode: number;
  applicationName?: string;
  correlationId?: string;
  extraProperties: Record<string, any>;
  // 添加新字段
  actions?: RequestLogActionDto[];
  entityChanges?: EntityChangeLogDto[];
}

export interface RequestLogActionDto {
  tenantId?: string;
  auditLogId: string;
  serviceName?: string;
  methodName?: string;
  parameters?: string;
  executionTime: string;
  executionDuration: number;
  id: string;
  extraProperties: Record<string, any>;
}

export interface EntityChangeLogDto {
  id: string;
  auditLogId: string;
  tenantId?: string;
  changeTime: string;
  changeType: number;
  entityId: string;
  entityTypeFullName: string;
  propertyChanges: EntityPropertyChangeDto[];
  extraProperties: Record<string, any>;
  userName?: string;
}

export interface EntityPropertyChangeDto {
  id: string;
  tenantId?: string;
  entityChangeId: string;
  newValue?: string;
  originalValue?: string;
  propertyName: string;
  propertyTypeFullName: string;
} 