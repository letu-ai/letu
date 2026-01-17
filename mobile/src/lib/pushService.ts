/**
 * 阿里云推送服务集成
 */
import * as AliyunPush from 'aliyun-react-native-push';
import { Platform } from 'react-native';
import { saveUserDevice } from '@/api/userDevice';
import { navigate } from '@/navigation/NavigationService';
import { useNotificationStore } from '@/stores/notificationStore';

/**
 * 推送通知数据
 */
export interface IPushNotification {
    notificationId: string;
    notificationType?: number;
    subType?: string;
    title?: string;
    priority?: number;
    showInList?: boolean;
}

/**
 * 推送服务类
 */
class PushService {
    private deviceId: string | null = null;
    private deviceToken: string | null = null;
    private messageCallback: ((notification: IPushNotification) => void) | null = null;

    /**
     * 初始化推送服务
     */
    async init(): Promise<void> {
        try {
            // 初始化推送
            await AliyunPush.initPush();

            // 获取设备ID
            this.deviceId = await AliyunPush.getDeviceId();
            console.log('阿里云推送设备ID:', this.deviceId);

            // 监听设备Token注册
            AliyunPush.addRegisterDeviceTokenSuccessCallback((deviceToken: string) => {
                console.log('获取到设备Token:', deviceToken);
                this.deviceToken = deviceToken;
                this.registerDevice();
            });

            AliyunPush.addRegisterDeviceTokenFailedCallback((error: any) => {
                console.error('注册设备Token失败:', error);
            });

            // 监听推送消息
            AliyunPush.addMessageCallback((notification: any) => {
                console.log('收到推送通知:', notification);
                this.handleNotification(notification);
            });

            // 注册通知事件的回调
            AliyunPush.addNotificationCallback((notification: any) => {
                console.log('收到通知:', notification);
                this.handleNotification(notification);
            });

            // 注册通知被打开
            AliyunPush.addNotificationOpenedCallback((notification: any) => {
                console.log('用户点击了推送通知');
                this.handleNotificationOpened(notification);
            });

            // 注册通知被移除
            AliyunPush.addNotificationRemovedCallback((notification: any) => {
                console.log('通知被移除:', notification);
            });

            // 应用在前台接收通知的回调（仅 Android）
            AliyunPush.addNotificationReceivedInApp((notification: any) => {
                console.log('收到App内通知:', notification);
                this.handleNotification(notification);
            });

            // 注册无动作通知点击的回调（仅 Android）。
            AliyunPush.addNotificationClickedWithNoAction((notification: any) => {
                console.log('通知被点击（无动作）:', notification);
            });

        } catch (error) {
            console.error('初始化推送服务失败:', error);
        }
    }

    /**
     * 注册设备到后端
     */
    private async registerDevice(): Promise<boolean> {
        if (!this.deviceId) {
            console.warn('设备ID不存在，无法注册设备');
            return false;
        }

        try {
            await saveUserDevice(this.deviceId, this.deviceToken || undefined);
            console.log('设备注册成功');
            return true;
        } catch (error) {
            console.error('注册设备失败:', error);
            return false;
        }
    }

    /**
     * 处理推送通知
     */
    private handleNotification(notification: any): void {
        try {
            // 解析推送数据
            const extras = notification.extras || {};
            const pushData: IPushNotification = {
                notificationId: extras.notificationId || notification.messageId,
                notificationType: extras.notificationType,
                subType: extras.subType,
                title: notification.title,
                priority: extras.priority,
                showInList: extras.showInList,
            };

            // 刷新未读计数
            useNotificationStore.getState().fetchUnreadCount();

            // 标记需要刷新列表
            useNotificationStore.getState().markShouldRefresh();

            // 调用消息回调
            if (this.messageCallback) {
                this.messageCallback(pushData);
            }
        } catch (error) {
            console.error('处理推送通知失败:', error);
        }
    }

    /**
     * 处理通知点击（实现导航逻辑）
     */
    private handleNotificationOpened(notification: any): void {
        try {
            // 解析推送数据
            const extras = notification.extras || {};
            const notificationId = extras.notificationId || notification.messageId;

            if (notificationId) {
                // 导航到通知详情页
                console.log('导航到通知详情:', notificationId);
                navigate('NotificationDetail', { id: notificationId });
            } else {
                console.warn('推送消息中未找到notificationId');
            }
        } catch (error) {
            console.error('处理通知点击失败:', error);
        }
    }

    /**
     * 设置消息回调
     */
    setMessageCallback(callback: (notification: IPushNotification) => void): void {
        this.messageCallback = callback;
    }

    /**
     * 绑定账号（用于账号推送）
     */
    async bindAccount(account: string): Promise<void> {
        try {
            await AliyunPush.bindAccount(account);
            console.log('绑定账号成功:', account);
        } catch (error) {
            console.error('绑定账号失败:', error);
        }
    }

    /**
     * 解绑账号
     */
    async unbindAccount(): Promise<void> {
        try {
            await AliyunPush.unbindAccount();
            console.log('解绑账号成功');
        } catch (error) {
            console.error('解绑账号失败:', error);
        }
    }

    /**
     * 绑定标签（用于标签推送）
     */
    async bindTag(tags: string[]): Promise<void> {
        try {
            await AliyunPush.bindTag(tags);
            console.log('绑定标签成功:', tags);
        } catch (error) {
            console.error('绑定标签失败:', error);
        }
    }

    /**
     * 解绑标签
     */
    async unbindTag(tags: string[]): Promise<void> {
        try {
            await AliyunPush.unbindTag(tags);
            console.log('解绑标签成功:', tags);
        } catch (error) {
            console.error('解绑标签失败:', error);
        }
    }

    /**
     * 获取设备ID
     */
    getDeviceId(): string | null {
        return this.deviceId;
    }

    /**
     * 获取设备Token
     */
    getDeviceToken(): string | null {
        return this.deviceToken;
    }
}

// 导出单例
export const pushService = new PushService();
