import * as AliyunPush from 'aliyun-react-native-push';
import { AliyunPushLogLevel, CreateAndroidChannelParams } from 'aliyun-react-native-push';
import { Platform } from 'react-native';
import { storage } from '@/utils/storage';
import { saveUserDevice } from '@/api/userDevice';

// 设置日志级别（需要在 initPush 前调用）
AliyunPush.setLogLevel(AliyunPushLogLevel.Debug);

// 配置App Key和App Secret（请在 https://emas.console.aliyun.com 获取）
const app = Platform.select({
    ios: {
        appKey: '335545908',
        appSecret: 'f9aada891c32423187b18ae319700c09',
    },
    android: {
        appKey: '335645198',
        appSecret: 'defdccfd2cf54d98a44b4c96fa2b378f',
    },
});

// 推送状态
export type PushInitStatus = 'idle' | 'initializing' | 'success' | 'failed';

// 推送配置
const PUSH_CONFIG = {
    initialDelay: 5000,      // 初始延迟：5秒
    maxDelay: 60000,         // 最大延迟：60秒
    backoffFactor: 2,        // 退避因子：2
    pushInitKey: '@push/init',  // 推送初始化状态缓存
    currentUsernameKey: '@push/currentUsername',  // 当前登录用户名
};

// 初始化状态（内存中）
let initStatus: PushInitStatus = 'idle';
let retryCount = 0;
let retryTimer: number | null = null;

// 初始化 Promise 及其 resolver（用于协调机制）
let initPromiseResolve: ((deviceId: string | null) => void) | null = null;
let initPromise: Promise<string | null> | null = null;

// 等待绑定的用户名（登录成功但推送未初始化时使用）
let pendingUsername: string | null = null;

/**
 * 计算重试延迟（指数退避）
 */
function getRetryDelay(retryCount: number): number {
    const delay = PUSH_CONFIG.initialDelay * Math.pow(PUSH_CONFIG.backoffFactor, retryCount);
    return Math.min(delay, PUSH_CONFIG.maxDelay);
}

/**
 * 延迟函数
 */
function delay(ms: number): Promise<void> {
    return new Promise(resolve => {
        retryTimer = setTimeout(resolve, ms);
    });
}

/**
 * 绑定账号并注册设备到后台
 * @param username 用户名
 * @param deviceId 设备ID
 */
async function bindAccountAndRegisterDevice(username: string, deviceId: string): Promise<void> {
    try {
        // 绑定账号到阿里云推送
        await AliyunPush.bindAccount(username);
        console.log('推送账号绑定成功:', username);

        // 保存当前用户名
        await storage.setJSON(PUSH_CONFIG.currentUsernameKey, username);

        // 上报设备信息到后台
        await saveUserDevice(deviceId);
        console.log('设备信息上报成功');
    } catch (error) {
        console.error('绑定账号或上报设备失败:', error);
        throw error;
    }
}

/**
 * 初始化推送服务（App启动时调用）
 * - 冷启动/热启动都会执行
 * - 如果已初始化过直接返回
 * - 初始化完成后检查是否有保存的用户名，有则执行绑定
 * @returns 推送设备ID，失败返回null
 */
export async function initPush(): Promise<string | null> {
    // 如果已经初始化成功，直接返回设备ID
    if (initStatus === 'success') {
        try {
            const deviceId = await AliyunPush.getDeviceId();
            if (deviceId) {
                console.log('推送已初始化，设备ID:', deviceId);

                // 检查是否有等待绑定的用户名（登录先于初始化完成的情况）
                if (pendingUsername) {
                    const username = pendingUsername;
                    pendingUsername = null;
                    await bindAccountAndRegisterDevice(username, deviceId);
                }

                return deviceId;
            }
        } catch (error) {
            console.error('获取设备ID失败:', error);
            // 如果获取失败，继续重新初始化
        }
    }

    // 正在初始化中，返回等待的 Promise
    if (initStatus === 'initializing') {
        console.log('推送正在初始化中，等待完成...');
        if (initPromise) {
            return initPromise;
        }
        return null;
    }

    initStatus = 'initializing';
    console.log('开始初始化推送服务...');

    // 创建初始化 Promise（供其他地方等待）
    initPromise = new Promise<string | null>((resolve) => {
        initPromiseResolve = resolve;
    });

    try {
        const result = await AliyunPush.initPush(app?.appKey, app?.appSecret);

        if (result.code === AliyunPush.kAliyunPushSuccessCode) {
            initStatus = 'success';
            retryCount = 0; // 重置重试计数

            // 获取设备ID
            const deviceId = await AliyunPush.getDeviceId();

            // 保存初始化状态
            await storage.setJSON(PUSH_CONFIG.pushInitKey, {
                status: 'success',
                deviceId,
                timestamp: new Date().toISOString(),
            });

            console.log('推送初始化成功, 设备ID:', deviceId);

            // 初始化完成后，检查是否需要绑定用户
            let usernameToBindd = pendingUsername;
            pendingUsername = null;

            // 如果没有等待绑定的用户名，检查存储中是否有已保存的用户名
            if (!usernameToBindd) {
                usernameToBindd = await storage.getJSON<string>(PUSH_CONFIG.currentUsernameKey);
            }

            // 执行绑定
            if (usernameToBindd && deviceId) {
                await bindAccountAndRegisterDevice(usernameToBindd, deviceId);
            }

            // 解析等待的 Promise
            if (initPromiseResolve) {
                initPromiseResolve(deviceId);
                initPromiseResolve = null;
            }

            return deviceId;

        } else {
            throw new Error(`推送初始化失败: ${result.errorMsg} (错误码: ${result.code})`);
        }
    } catch (error: any) {
        initStatus = 'failed';
        console.error('推送初始化失败:', error.message);

        // 计算重试延迟
        const delayMs = getRetryDelay(retryCount);
        retryCount++;
        console.log(`将在${delayMs/1000}秒后进行第${retryCount}次重试...`);

        // 延迟重试
        await delay(delayMs);

        // 递归重试（无限重试直到成功）
        return initPush();
    }
}

/**
 * 用户登录成功后调用
 * - 保存用户名
 * - 如果推送已初始化，立即绑定并上报设备
 * - 如果推送未初始化，缓存用户名等待初始化完成后绑定
 * @param username 登录的用户名
 */
export async function onUserLoggedIn(username: string): Promise<void> {
    console.log('用户登录成功，准备绑定推送:', username);

    // 保存用户名到存储
    await storage.setJSON(PUSH_CONFIG.currentUsernameKey, username);

    // 检查推送是否已初始化
    if (initStatus === 'success') {
        try {
            const deviceId = await AliyunPush.getDeviceId();
            if (deviceId) {
                await bindAccountAndRegisterDevice(username, deviceId);
            }
        } catch (error) {
            console.error('登录后绑定推送失败:', error);
        }
    } else {
        // 推送未初始化，缓存用户名等待初始化完成
        console.log('推送未初始化，缓存用户名等待绑定');
        pendingUsername = username;
    }
}

/**
 * 用户登出时调用
 * - 解绑账号
 * - 清除保存的用户名
 */
export async function onUserLoggedOut(): Promise<void> {
    console.log('用户登出，解绑推送账号');

    try {
        await AliyunPush.unbindAccount();
        console.log('推送账号解绑成功');
    } catch (error) {
        console.error('解绑推送账号失败:', error);
    }

    // 清除保存的用户名
    await storage.removeItem(PUSH_CONFIG.currentUsernameKey);
    pendingUsername = null;
}

/**
 * 获取推送设备ID
 */
export async function getPushDeviceId(): Promise<string | null> {
    try {
        return await AliyunPush.getDeviceId();
    } catch (error) {
        console.error('获取推送设备ID失败:', error);
        return null;
    }
}

/**
 * 获取推送初始化状态
 */
export function getPushInitStatus(): PushInitStatus {
    return initStatus;
}

/**
 * 重置推送初始化状态（用于登出或调试）
 */
export async function resetPushInitStatus(): Promise<void> {
    // 先解绑账号
    await onUserLoggedOut();

    initStatus = 'idle';
    retryCount = 0;
    initPromise = null;
    initPromiseResolve = null;

    if (retryTimer) {
        clearTimeout(retryTimer);
        retryTimer = null;
    }
    await storage.removeItem(PUSH_CONFIG.pushInitKey);
    console.log('推送初始化状态已重置');
}

// 设置消息监听器
const setupMessageListener = () => {
    try {
        // 监听消息接收
        AliyunPush.addMessageCallback((message: any) => {
            console.log('收到推送消息:', {
                title: message.title,
                content: message.content,
                extra: message.extra,
                messageId: message.messageId,
                timestamp: new Date().toISOString()
            });
        });

        // 监听App内通知接收
        AliyunPush.addNotificationReceivedInApp((notification: any) => {
            console.log('App内收到通知:', {
                title: notification.title,
                content: notification.content,
                extra: notification.extra,
                messageId: notification.messageId,
                timestamp: new Date().toISOString()
            });
        });

        console.log('推送消息监听器已设置');
    } catch (error) {
        console.error('设置推送消息监听器失败:', error);
    }
};


import { createAndroidChannel } from 'aliyun-react-native-push';

async function createEventChannel() {
    const params: CreateAndroidChannelParams = {
        id: 'event_channel',
        name: '事件通知渠道',
        desc: '事件通知渠道',
        importance: 3,
        showBadge: true,
    };
    const result = await createAndroidChannel(params);
    console.log('创建渠道结果:', result);
}

export { createEventChannel, setupMessageListener };