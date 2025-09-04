import httpClient from '@/utils/httpClient';
import type { PagedResult, PagedResultRequest } from '@/types/api';

// ========================= 个人资料相关 =========================

/**
 * 获取个人信息
 */
export function getProfile() {
    return httpClient.get<void, IProfileOutput>('/api/my/profile');
}

/**
 * 修改个人基本信息
 * @param info
 */
export function updateProfile(info: IProfileUpdateInput) {
    return httpClient.put<IProfileUpdateInput, void>('/api/my/profile', info);
}

/**
 * 上传头像
 * @param file
 */
export function uploadAvatar(file: File) {
    const formData = new FormData();
    formData.append('avatar', file);
    return httpClient.post<FormData, string>('/api/my/profile/avatar', formData, {
        headers: {
            'Content-Type': 'multipart/form-data',
        },
    });
}

export interface IProfileOutput {
    nickName: string;
    avatar?: string;
    phone?: string;
    email?: string;
}

export interface IProfileUpdateInput {
    nickName: string;
    avatar?: string;
}

// ========================= 密码相关 =========================

/**
 * 修改个人密码
 * @param input
 */
export function changePassword(input: IChangePasswordInput) {
    return httpClient.put<IChangePasswordInput, void>('/api/my/profile/change-password', input);
}

export interface IChangePasswordInput {
    oldPassword: string;
    newPassword: string;
}

// ========================= 登录日志相关 =========================

/**
 * 获取个人登录日志列表
 * @param input
 */
export function getSecurityLogs(input: ISecurityLogListInput) {
    return httpClient.get<ISecurityLogListInput, PagedResult<ISecurityLogListOutput>>(
        '/api/my/profile/security-logs',
        {
            params: input,
        }
    );
}

/**
 * 获取登录统计信息
 */
export function getSecurityLogStats() {
    return httpClient.get<void, ISecurityLogStatsOutput>('/api/my/profile/security-logs/stats');
}

export interface ISecurityLogListInput extends PagedResultRequest {
    startDate?: string;
    endDate?: string;
    isSuccess?: boolean;
    ip?: string;
}

export interface ISecurityLogListOutput {
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

export interface ISecurityLogStatsOutput {
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
 * @param input
 */
export function getMyNotificationList(input: IUserNotificationListInput) {
    return httpClient.get<IUserNotificationListInput, PagedResult<IMyNotificationListOutput>>(
        '/api/my/notification',
        {
            params: input,
        }
    );
}

/**
 * 我的通知顶部导航信息
 */
export function getMyNotificationNavbarInfo() {
    return httpClient.get<void, IUserNotificationNavbarOutput>(
        '/api/my/notification/navbar-info'
    );
}

/**
 * 获取通知详情
 * @param id 通知ID
 */
export function getNotificationDetail(id: string) {
    return httpClient.get<void, IMyNotificationListOutput>(
        `/api/my/notification/${id}`
    );
}

export interface IMyNotificationListOutput {
    id: string;
    title: string;
    content: string | null;
    isReaded: boolean;
    creationTime: string;
    readedTime: string;
}

export interface IUserNotificationListInput extends PagedResultRequest {
    title?: string;
    isReaded?: boolean;
}

export interface IUserNotificationNavbarOutput {
    noReadedCount: number;
    items: IUserNotificationNavbarItemOutput[];
}

export interface IUserNotificationNavbarItemOutput {
    id: string;
    title: string;
    content: string | null;
    isReaded: boolean;
    creationTime: string;
}

export interface INotificationMessageData {
    notificationId: string;
}