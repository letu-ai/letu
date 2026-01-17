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
    subType?: string;
    sendScopeType: SendScopeType;
    sendScopeValue?: string;
    priority: NotificationPriority;
    expireTime?: string;
    targetPlatform: TargetPlatform;
    isPublish: boolean;
}

export interface NotificationResultDto {
    id: string;
    title: string;
    content?: string;
    notificationType: NotificationType;
    subType?: string;
    sendScopeType: SendScopeType;
    sendScopeValue?: string;
    status: NotificationStatus;
    publishTime?: string;
    expireTime?: string;
    priority: NotificationPriority;
    targetPlatform: TargetPlatform;
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
    pushStatus: PushStatus;
    retryCount: number;
    pushErrorMessage?: string;
}

// 枚举类型

export const NotificationType = {
    SYSTEM_ANNOUNCEMENT: 1, // 系统公告
    BUSINESS_NOTIFICATION: 2, // 业务通知
    SYSTEM_NOTIFICATION: 3, // 系统通知
} as const;

export type NotificationType = typeof NotificationType[keyof typeof NotificationType];

export const SendScopeType = {
    SPECIFIC_USERS: 1,      // 指定用户
    BY_ROLE: 2,             // 按角色
    BY_DEPARTMENT: 3,       // 按部门
    BY_POSITION: 4,         // 按职位
    ALL_EMPLOYEES: 5,       // 全体员工
    SPECIFIC_DEVICES: 6,    // 指定设备
    BY_CLIENT_TYPE: 7,      // 按客户端类型
} as const;

export type SendScopeType = typeof SendScopeType[keyof typeof SendScopeType];

export const TargetPlatform = {
    NONE: 0,
    WEB: 1,
    ANDROID: 2,
    IOS: 4,
    HARMONYOS: 8,
    MOBILE: 14,             // Android | iOS | HarmonyOS
    ALL: 15,                // Web | Mobile
} as const;

export type TargetPlatform = typeof TargetPlatform[keyof typeof TargetPlatform];

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

export const PushStatus = {
    PENDING: 0,             // 待推送
    SUCCESS: 1,             // 推送成功
    FAILED: 2,              // 推送失败（等待重试）
    SKIPPED: 3,             // 跳过（无目标设备等）
    EXPIRED: 4,             // 过期（超过有效期或最大重试次数）
} as const;

export type PushStatus = typeof PushStatus[keyof typeof PushStatus];

// 常量定义

export const NOTIFICATION_TYPE_OPTIONS = [
    { label: "系统公告", value: NotificationType.SYSTEM_ANNOUNCEMENT },
    { label: "业务通知", value: NotificationType.BUSINESS_NOTIFICATION },
    { label: "系统通知", value: NotificationType.SYSTEM_NOTIFICATION },
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
    { label: "指定设备", value: SendScopeType.SPECIFIC_DEVICES },
    { label: "按客户端类型", value: SendScopeType.BY_CLIENT_TYPE },
];

export const TARGET_PLATFORM_OPTIONS = [
    { label: "Web端", value: TargetPlatform.WEB },
    { label: "Android", value: TargetPlatform.ANDROID },
    { label: "iOS", value: TargetPlatform.IOS },
    { label: "鸿蒙", value: TargetPlatform.HARMONYOS },
];

export const TARGET_PLATFORM_PRESET_OPTIONS = [
    { label: "全部平台", value: TargetPlatform.ALL },
    { label: "仅Web端", value: TargetPlatform.WEB },
    { label: "仅移动端", value: TargetPlatform.MOBILE },
];
