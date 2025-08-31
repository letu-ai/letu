import httpClient from '@/utils/httpClient';
import type { PagedResult, PagedResultRequest } from '@/types/api';

// ========================= 个人资料相关 =========================

/**
 * 获取个人信息
 */
export function getPersonalInfo() {
  return httpClient.get<unknown, PersonalInfoDto>('/api/account/info');
}

/**
 * 修改个人基本信息
 * @param info
 */
export function updatePersonalInfo(info: PersonalInfoUpdateDto) {
  return httpClient.put<PersonalInfoUpdateDto, void>('/api/account/updateInfo', info);
}

/**
 * 上传头像
 * @param file
 */
export function uploadAvatar(file: File) {
  const formData = new FormData();
  formData.append('file', file);
  return httpClient.post<FormData, { url: string }>('/api/oss/upload', formData, {
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  });
}

export interface PersonalInfoDto {
  avatar?: string;
  nickName?: string;
  sex?: number;
  phone?: string;
  email?: string;
  userName?: string;
}

export interface PersonalInfoUpdateDto {
  avatar?: string;
  nickName?: string;
  sex?: number;
}

// ========================= 密码相关 =========================

/**
 * 修改个人密码
 * @param dto
 */
export function changePassword(dto: ChangePasswordDto) {
  return httpClient.put<ChangePasswordDto, void>('/api/account/updatePwd', dto);
}

export interface ChangePasswordDto {
  oldPassword: string;
  newPassword: string;
}

// ========================= 登录日志相关 =========================

/**
 * 获取个人登录日志列表
 * @param dto
 */
export function getSecurityLogs(dto: SecurityLogQueryDto) {
  return httpClient.get<SecurityLogQueryDto, PagedResult<SecurityLogListDto>>(
    '/api/account/security-logs',
    {
      params: dto,
    }
  );
}

/**
 * 获取登录统计信息
 */
export function getSecurityLogStats() {
  return httpClient.get<unknown, SecurityLogStatsDto>('/api/account/security-logs/stats');
}

export interface SecurityLogQueryDto extends PagedResultRequest {
  startDate?: string;
  endDate?: string;
  isSuccess?: boolean;
  ip?: string;
}

export interface SecurityLogListDto {
  id: string;
  ip: string;
  location?: string;
  browser?: string;
  os?: string;
  device?: string;
  isSuccess: boolean;
  operationMsg?: string;
  creationTime: string;
}

export interface SecurityLogStatsDto {
  todayLoginCount: number;
  recentLoginIp?: string;
  abnormalLoginCount: number;
  totalLoginCount: number;
}

// ========================= 通知相关（从notifications/-service.ts迁移） =========================

/**
 * 标记已读
 * @param ids 通知ID数组
 */
export function markNotificationsRead(ids: string[]) {
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
    }
  );
}

/**
 * 我的通知顶部导航信息
 */
export function getMyNotificationNavbarInfo() {
  return httpClient.get<unknown, UserNotificationNavbarDto>(
    '/api/my/notification/navbar-info'
  );
}

/**
 * 获取通知详情
 * @param id 通知ID
 */
export function getNotificationDetail(id: string) {
  return httpClient.get<unknown, MyNotificationListDto>(
    `/api/my/notification/${id}`
  );
}

export interface MyNotificationListDto {
  id: string;
  title: string;
  content: string | null;
  isReaded: boolean;
  creationTime: string;
  readedTime: string;
}

export interface UserNotificationQueryDto extends PagedResultRequest {
  title?: string;
  isReaded?: boolean;
}

export interface UserNotificationNavbarDto {
  noReadedCount: number;
  items: UserNotificationNavbarItemDto[];
}

export interface UserNotificationNavbarItemDto {
  id: string;
  title: string;
  content: string | null;
  isReaded: boolean;
  creationTime: string;
}

export interface NotificationMessageData {
  notificationId: string;
}