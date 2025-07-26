import httpClient from '@/utils/httpClient.ts';
import type { AppResponse, PagedResult, PageSearch } from '@/types/api';

/**
 * 新增定时任务
 * @param dto
 */
export function addScheduledTask(dto: ScheduledTaskDto) {
  return httpClient.post<ScheduledTaskDto, AppResponse<boolean>>('/api/admin/scheduled-tasks', dto);
}

/**
 * 定时任务分页列表
 * @param dto
 */
export function getScheduledTaskList(dto: ScheduledTaskQueryDto) {
  return httpClient.get<ScheduledTaskQueryDto, AppResponse<PagedResult<ScheduledTaskListDto>>>(
    '/api/admin/scheduled-tasks',
    { params: dto },
  );
}

/**
 * 修改定时任务
 * @param dto
 */
export function updateScheduledTask(dto: ScheduledTaskDto) {
  return httpClient.put<ScheduledTaskDto, AppResponse<boolean>>('/api/admin/scheduled-tasks', dto);
}

/**
 * 删除定时任务
 * @param id
 */
export function deleteScheduledTask(id: string) {
  return httpClient.delete<string, AppResponse<boolean>>(`/api/scheduledTask/delete/${id}`);
}

/**
 * 任务执行日志
 * @param dto
 */
export function getExecutionLogList(dto: TaskExecutionLogQueryDto) {
  return httpClient.get<TaskExecutionLogQueryDto, AppResponse<PagedResult<TaskExecutionLogListDto>>>(
    '/api/admin/scheduled-tasks/Log',
    { params: dto },
  );
}

export interface ScheduledTaskDto {
  id?: string;
  taskKey: string;
  description?: string | null;
  cronExpression: string;
  isActive: boolean;
}

export interface ScheduledTaskListDto {
  id: string;
  taskKey: string;
  description?: string | null;
  cronExpression: string;
  isActive: boolean;
  creationTime: string;
  lastModificationTime?: string;
}

export interface ScheduledTaskQueryDto extends PageSearch {
  taskKey?: string;
  description?: string;
}

export interface TaskExecutionLogQueryDto {
  taskKey: string;
  status?: number;
  executionTimeRange?: string[];
  cost?: number;
}

export interface TaskExecutionLogListDto {
  id: string;
  taskKey: string;
  status: number;
  result: string;
  cost: number;
  executionTime: string;
}
