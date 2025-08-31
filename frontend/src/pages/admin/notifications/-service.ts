import httpClient from "@/utils/httpClient";
import type { PagedResult, PagedResultRequest } from "@/types/api";

const API_BASE = "/api/admin/notification-management";

/**
 * 创建通知
 */
export function createNotification(dto: NotificationDto) {
    return httpClient.post<NotificationDto, string>(`${API_BASE}`, dto);
}

/**
 * 获取通知列表
 */
export function getNotificationList(dto: NotificationQueryDto) {
    return httpClient.get<NotificationQueryDto, PagedResult<NotificationResultDto>>(`${API_BASE}`, {
        params: dto,
    });
}

/**
 * 获取通知详情
 */
export function getNotification(id: string) {
    return httpClient.get<void, NotificationResultDto>(`${API_BASE}/${id}`);
}

/**
 * 更新通知
 */
export function updateNotification(id: string, dto: NotificationDto) {
    return httpClient.put<NotificationDto, void>(`${API_BASE}/${id}`, dto);
}

/**
 * 发布通知
 */
export function publishNotification(id: string) {
    return httpClient.post<void, void>(`${API_BASE}/${id}/publish`);
}

/**
 * 撤回通知
 */
export function withdrawNotification(id: string) {
    return httpClient.post<void, void>(`${API_BASE}/${id}/withdraw`);
}

/**
 * 批量删除通知
 */
export function deleteNotifications(ids: string[]) {
    return httpClient.delete<string[], void>(`${API_BASE}`, {
        data: ids,
    });
}

/**
 * 删除单个通知
 */
export function deleteNotification(id: string) {
    return httpClient.delete<void, void>(`${API_BASE}/${id}`);
}

/**
 * 获取通知接收人列表
 */
export function getNotificationRecipients(id: string, params: PagedResultRequest) {
    return httpClient.get<PagedResultRequest, PagedResult<NotificationRecipientDto>>(`${API_BASE}/${id}/recipients`, {
        params,
    });
}

/**
 * 清理过期通知
 */
export function cleanExpiredNotifications() {
    return httpClient.post<void, void>(`${API_BASE}/clean-expired`);
}

// 类型定义

export interface NotificationDto {
    title: string;
    content?: string;
    notificationType: NotificationType;
    sendScopeType: SendScopeType;
    sendScopeValue?: string;
    priority: NotificationPriority;
    expireTime?: string;
    isPublish: boolean;
}

export interface NotificationResultDto {
    id: string;
    title: string;
    content?: string;
    notificationType: NotificationType;
    sendScopeType: SendScopeType;
    sendScopeValue?: string;
    status: NotificationStatus;
    publishTime?: string;
    expireTime?: string;
    priority: NotificationPriority;
    senderId: string;
    senderName?: string;
    creationTime: string;
    recipientCount: number;
    readCount: number;
}

export interface NotificationQueryDto extends PagedResultRequest {
    title?: string;
    notificationType?: NotificationType;
    status?: NotificationStatus;
    sendScopeType?: SendScopeType;
    priority?: NotificationPriority;
    startTime?: string;
    endTime?: string;
}

export interface NotificationRecipientDto {
    id: string;
    userId: string;
    userName?: string;
    departmentName?: string;
    positionName?: string;
    isRead: boolean;
    readTime?: string;
    creationTime: string;
}

// 枚举类型

export const NotificationType = {
    SYSTEM_ANNOUNCEMENT: 1, // 系统公告
    TASK_REMINDER: 2,       // 任务提醒
    APPROVAL_NOTICE: 3,     // 审批通知
    OTHER: 4,               // 其他
} as const;

export type NotificationType = typeof NotificationType[keyof typeof NotificationType];

export const SendScopeType = {
    SPECIFIC_USERS: 1,      // 指定用户
    BY_ROLE: 2,             // 按角色
    BY_DEPARTMENT: 3,       // 按部门
    BY_POSITION: 4,         // 按职位
    ALL_EMPLOYEES: 5,       // 全体员工
} as const;

export type SendScopeType = typeof SendScopeType[keyof typeof SendScopeType];

export const NotificationStatus = {
    DRAFT: 1,               // 草稿
    PUBLISHED: 2,           // 已发布
    WITHDRAWN: 3,           // 已撤回
} as const;

export type NotificationStatus = typeof NotificationStatus[keyof typeof NotificationStatus];

export const NotificationPriority = {
    NORMAL: 1,              // 普通
    IMPORTANT: 2,           // 重要
    URGENT: 3,              // 紧急
} as const;

export type NotificationPriority = typeof NotificationPriority[keyof typeof NotificationPriority];

// 常量定义

export const NOTIFICATION_TYPE_OPTIONS = [
    { label: "系统公告", value: NotificationType.SYSTEM_ANNOUNCEMENT },
    { label: "任务提醒", value: NotificationType.TASK_REMINDER },
    { label: "审批通知", value: NotificationType.APPROVAL_NOTICE },
    { label: "其他", value: NotificationType.OTHER },
];

export const NOTIFICATION_STATUS_OPTIONS = [
    { label: "草稿", value: NotificationStatus.DRAFT },
    { label: "已发布", value: NotificationStatus.PUBLISHED },
    { label: "已撤回", value: NotificationStatus.WITHDRAWN },
];

export const NOTIFICATION_PRIORITY_OPTIONS = [
    { label: "普通", value: NotificationPriority.NORMAL },
    { label: "重要", value: NotificationPriority.IMPORTANT },
    { label: "紧急", value: NotificationPriority.URGENT },
];

export const SEND_SCOPE_TYPE_OPTIONS = [
    { label: "指定用户", value: SendScopeType.SPECIFIC_USERS },
    { label: "按角色", value: SendScopeType.BY_ROLE },
    { label: "按部门", value: SendScopeType.BY_DEPARTMENT },
    { label: "按职位", value: SendScopeType.BY_POSITION },
    { label: "全体员工", value: SendScopeType.ALL_EMPLOYEES },
];
