/**
 * 通知 API
 */
import httpClient from './httpClient';

/**
 * 我的通知列表 DTO
 */
export interface IMyNotificationListDto {
  id: string;
  title: string;
  content: string | null;
  subType: string | null;
  extensionData: string | null;
  isReaded: boolean;
  creationTime: string;
  readedTime: string;
}

/**
 * 用户通知查询 DTO
 */
export interface IUserNotificationQueryDto {
  title?: string;
  isReaded?: boolean;
  skipCount?: number;
  maxResultCount?: number;
}

/**
 * 分页结果
 */
export interface IPagedResult<T> {
  items: T[];
  totalCount: number;
}

/**
 * 获取我的通知列表
 */
export async function getMyNotificationList(
  params: IUserNotificationQueryDto
): Promise<IPagedResult<IMyNotificationListDto>> {
  return httpClient.get<IUserNotificationQueryDto, IPagedResult<IMyNotificationListDto>>(
    '/api/my/notification',
    {
      params,
      anonymous: false,
    }
  );
}

/**
 * 获取通知详情
 */
export async function getNotificationDetail(id: string): Promise<IMyNotificationListDto> {
  return httpClient.get<void, IMyNotificationListDto>(
    `/api/my/notification/${id}`,
    {
      anonymous: false,
    }
  );
}

/**
 * 标记已读
 */
export async function markAsRead(ids: string[]): Promise<void> {
  return httpClient.put<string[], void>(
    '/api/my/notification/mark-as-read',
    ids,
    {
      anonymous: false,
    }
  );
}

/**
 * 通知导航栏项 DTO
 */
export interface IUserNotificationNavbarItemDto {
  id: string;
  title: string;
  content: string | null;
  subType: string | null;
  isReaded: boolean;
  creationTime: string;
}

/**
 * 用户通知导航栏 DTO
 */
export interface IUserNotificationNavbarDto {
  noReadedCount: number;
  items: IUserNotificationNavbarItemDto[] | null;
}

/**
 * 获取我的通知导航栏信息
 */
export async function getMyNotificationNavbarInfo(): Promise<IUserNotificationNavbarDto> {
  return httpClient.get<void, IUserNotificationNavbarDto>(
    '/api/my/notification/navbar-info',
    {
      anonymous: false,
    }
  );
}
