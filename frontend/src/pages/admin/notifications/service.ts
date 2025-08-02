import httpClient from '@/utils/httpClient';
import type { PagedResult, PagedResultRequest } from '@/types/api';

/**
 * 新增通知
 * @param dto
 */
export function addNotification(dto: NotificationDto) {
  return httpClient.post<NotificationDto, void>('/api/admin/notifications', dto);
}

/**
 * 通知分页列表
 * @param dto
 */
export function getNotificationList(dto: NotificationQueryDto) {
  return httpClient.get<NotificationQueryDto, PagedResult<NotificationListDto>>('/api/admin/notifications', {
    params: dto,
  });
}

/**
 * 修改通知
 * @param input
 */
export function updateNotification(id: string, input: NotificationDto) {
  return httpClient.put<NotificationDto, void>(`/api/admin/notifications/${id}`, input);
}

/**
 * 删除通知
 * @param ids
 */
export function deleteNotifications(ids: string[]) {
  return httpClient.delete<string, void>(`/api/notification/BatchDelete`, {
    data: ids,
  });
}

export interface NotificationDto {
  id?: string;
  title: string;
  content: string | null;
  employeeId: string;
}

export interface NotificationListDto {
  id: string;
  title: string;
  content: string | null;
  employeeId: string;
  isReaded: boolean;
  creationTime: string;
  readedTime: string;
  employeeName: string;
}

export interface NotificationQueryDto extends PagedResultRequest {
  keyword?: string;
  isReaded?: boolean;
}
