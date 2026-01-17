import httpClient from '@/utils/httpClient';
import type { PagedResult } from '@/types/api';

/**
 * 标记已读
 * @param ids 通知ID数组
 */
export function readed(ids: string[]) {
  return httpClient.put<string[], void>('/api/my/notification/mark-as-read', ids);
}

/**
 * 我的通知分页列表
 * @param dto
 */
export function getMyNotificationList(dto: UserNotificationQueryDto) {
  return httpClient.get<UserNotificationQueryDto, PagedResult<MyNotificationListDto>>(
    '/api/my/notification',
    {
      params: dto,
    },
  );
}

/**
 * 我的通知顶部导航信息
 * @param dto
 */
export function getMyNotificationNavbarInfo() {
  return httpClient.get<unknown, UserNotificationNavbarDto>(
    '/api/my/notification/navbar-info',
  );
}

/**
 * 获取通知详情
 * @param id 通知ID
 */
export function getNotificationDetail(id: string) {
  return httpClient.get<unknown, MyNotificationListDto>(
    `/api/my/notification/${id}`,
  );
}

export interface MyNotificationListDto {
  id: string;
  title: string;
  content: string | null;
  subType: string | null;
  extensionData: string | null;
  isReaded: boolean;
  creationTime: string;
  readedTime: string;
}

export interface UserNotificationQueryDto {
  title?: string;
  isReaded?: boolean;
}

export interface UserNotificationNavbarDto {
  noReadedCount: number;
  items: UserNotificationNavbarItemDto[] | null;
}

export interface UserNotificationNavbarItemDto {
  id: string;
  title: string;
  content: string | null;
  subType: string | null;
  isReaded: boolean;
  creationTime: string;
}

export interface NotificationMessageData {
  notificationId: string;
}