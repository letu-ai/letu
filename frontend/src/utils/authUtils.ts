import type { IUserTokenOutput } from '@/pages/account/-service';
import { redirect } from '@tanstack/react-router';

// 存储键名
const TOKEN_KEY = 'auth-token';
const REMEMBER_ME_KEY = 'auth-remember-me';
const SAVED_USERNAME_KEY = 'auth-saved-username';
const TENANT_ID_KEY = 'auth-tenant-id';
const TENANT_KEY_KEY = 'auth-tenant-key';

// 跨标签页同步频道名称
const SYNC_CHANNEL_NAME = 'auth-token-sync';

// 消息类型
type SyncMessageType = 'request-token' | 'response-token' | 'token-set' | 'token-clear';

interface SyncMessage {
    type: SyncMessageType;
    token?: string; // token 的 JSON 字符串
    rememberMe?: boolean; // 是否记住我
}

// BroadcastChannel 实例（单例）
let syncChannel: BroadcastChannel | null = null;

/**
 * 发送跨标签页同步消息
 * @param message 要发送的消息
 */
function broadcastMessage(message: SyncMessage): void {
    if (typeof BroadcastChannel === 'undefined') {
        return;
    }

    // 确保频道已初始化
    if (!syncChannel) {
        initTokenSync();
    }

    // 发送消息
    if (syncChannel) {
        syncChannel.postMessage(message);
    }
}

/**
 * 设置 Token，用于登录时写入并保持rememberMe状态。
 */
export function setToken(token: IUserTokenOutput, rememberMe: boolean = false): void {
    localStorage.setItem(REMEMBER_ME_KEY, rememberMe.toString());

    if (rememberMe) {
        // 记住我：保存到 localStorage，持久保存
        localStorage.setItem(TOKEN_KEY, JSON.stringify(token));
        sessionStorage.removeItem(TOKEN_KEY);
    } else {
        // 不记住我：保存到 sessionStorage，关闭浏览器后自动清除
        sessionStorage.setItem(TOKEN_KEY, JSON.stringify(token));
        localStorage.removeItem(TOKEN_KEY);
    }

    // 通知其他标签页 token 已设置
    broadcastMessage({
        type: 'token-set',
        token: JSON.stringify(token),
        rememberMe,
    });
}

/**
 * 获取 Token
 */
export function getToken(): IUserTokenOutput | null {
    try {
        const rememberMe = getRememberMe();

        if (rememberMe) {
            // 记住我：从 localStorage 获取
            const tokenStr = localStorage.getItem(TOKEN_KEY);
            return tokenStr ? JSON.parse(tokenStr) : null;
        } else {
            // 不记住我：优先从 sessionStorage 获取
            const tokenStr = sessionStorage.getItem(TOKEN_KEY);

            // 如果 sessionStorage 没有，尝试通过 BroadcastChannel 请求同步
            if (!tokenStr) {
                // 如果频道已初始化但还没有 token，发送请求（可能是初始化后新打开的标签页）
                if (syncChannel) {
                    broadcastMessage({ type: 'request-token' });
                } else {
                    // 如果频道未初始化，初始化时会自动发送请求
                    initTokenSync();
                }
            }

            return tokenStr ? JSON.parse(tokenStr) : null;
        }
    } catch {
        return null;
    }
}

/**
 * 初始化跨标签页 token 同步机制
 * 使用 BroadcastChannel 监听消息，处理同步请求和响应
 */
function initTokenSync(): void {
    // 检查浏览器是否支持 BroadcastChannel
    if (typeof BroadcastChannel === 'undefined') {
        return;
    }

    // 如果已经初始化，直接返回
    if (syncChannel) {
        return;
    }

    // 创建 BroadcastChannel 实例
    syncChannel = new BroadcastChannel(SYNC_CHANNEL_NAME);

    // 监听消息
    syncChannel.onmessage = (event: MessageEvent<SyncMessage>) => {
        const syncMessage = event.data;

        if (syncMessage.type === 'request-token') {
            // 收到同步请求：如果当前标签页的 sessionStorage 有 token，广播响应
            const myToken = sessionStorage.getItem(TOKEN_KEY);
            if (myToken) {
                broadcastMessage({
                    type: 'response-token',
                    token: myToken,
                });
            }
        } else if (syncMessage.type === 'response-token' && syncMessage.token) {
            // 收到同步 token：如果当前标签页的 sessionStorage 没有 token，写入
            if (!sessionStorage.getItem(TOKEN_KEY)) {
                try {
                    sessionStorage.setItem(TOKEN_KEY, syncMessage.token);
                } catch {
                    // 忽略写入错误
                }
            }
        } else if (syncMessage.type === 'token-set' && syncMessage.token) {
            // 收到 token 设置通知：同步到当前标签页
            const rememberMe = syncMessage.rememberMe ?? false;
            if (rememberMe) {
                // 记住我：保存到 localStorage
                localStorage.setItem(TOKEN_KEY, syncMessage.token);
                sessionStorage.removeItem(TOKEN_KEY);
            } else {
                // 不记住我：保存到 sessionStorage
                sessionStorage.setItem(TOKEN_KEY, syncMessage.token);
                localStorage.removeItem(TOKEN_KEY);
            }
            // 同步 rememberMe 状态
            localStorage.setItem(REMEMBER_ME_KEY, rememberMe.toString());
        } else if (syncMessage.type === 'token-clear') {
            // 收到 token 清除通知：清除当前标签页的 token
            localStorage.removeItem(TOKEN_KEY);
            sessionStorage.removeItem(TOKEN_KEY);
        }
    };

    // 初始化时，如果当前标签页没有 token 且 rememberMe = false，主动发送一次请求
    const rememberMe = getRememberMe();
    if (!rememberMe && !sessionStorage.getItem(TOKEN_KEY)) {
        broadcastMessage({ type: 'request-token' });
    }
}

/**
 * 更新 Token，用于刷新token时写入。
 */
export function updateToken(accessToken: string, refreshToken?: string, expiredTime?: Date): void {
    const currentToken = getToken();
    if (currentToken) {
        const updatedToken: IUserTokenOutput = {
            ...currentToken,
            accessToken,
            refreshToken: refreshToken || currentToken.refreshToken,
            expiredTime: expiredTime || currentToken.expiredTime,
        };
        setToken(updatedToken, getRememberMe());
    }
}

/**
 * 清除 Token
 */
export function clearToken(): void {
    localStorage.removeItem(TOKEN_KEY);
    sessionStorage.removeItem(TOKEN_KEY);

    // 通知其他标签页 token 已清除
    broadcastMessage({
        type: 'token-clear',
    });
}

/**
 * 设置记住我状态
 */
export function setRememberMe(remember: boolean, userName?: string): void {
    localStorage.setItem(REMEMBER_ME_KEY, remember.toString());

    if (remember && userName) {
        localStorage.setItem(SAVED_USERNAME_KEY, userName);
    } else {
        localStorage.removeItem(SAVED_USERNAME_KEY);
    }
}

/**
 * 获取记住我状态
 */
export function getRememberMe(): boolean {
    return localStorage.getItem(REMEMBER_ME_KEY) === 'true';
}

export interface ITenantInfo {
    tenantKey: string;
    tenantId: string | null;
}

/**
 * 获取租户ID
 */
export function getTenantInfo(): ITenantInfo | null {
    return {
        tenantKey: localStorage.getItem(TENANT_KEY_KEY) || '',
        tenantId: localStorage.getItem(TENANT_ID_KEY) || null,
    }
}

export function setTenantId(tenantId: string | null, tenantKey: string ): void {
    if (tenantId) {
        localStorage.setItem(TENANT_ID_KEY, tenantId);
        localStorage.setItem(TENANT_KEY_KEY, tenantKey);
    }
    else {
        localStorage.removeItem(TENANT_ID_KEY);
        localStorage.removeItem(TENANT_KEY_KEY);
    }
}

/**
 * 获取保存的用户名
 */
export function getSavedUserName(): string {
    return localStorage.getItem(SAVED_USERNAME_KEY) || '';
}

/**
 * 判断 Token 是否有效（精确判断，不含缓冲时间）
 * token过期且没有refresh token才视为无效
 */
export function isTokenValid(): boolean {
    const token = getToken();

    if (!token || !token.accessToken) {
        return false;
    }

    // 如果有过期时间，检查是否过期
    if (token.expiredTime) {
        const expiredTime = new Date(token.expiredTime).getTime();
        const now = Date.now();
        const isExpired = now >= expiredTime;
        
        // 如果未过期，返回 true
        if (!isExpired) {
            return true;
        }
        
        // 如果过期了，但有 refreshToken，仍然认为有效（可以刷新）
        if (token.refreshToken) {
            return true;
        }
        
        // 如果过期了且没有 refreshToken，视为无效
        return false;
    }

    // 如果没有过期时间，只要有 accessToken 就认为有效
    return true;
}

/**
 * 检查用户是否已认证，如果未认证则重定向到登录页面
 * 这个函数适用于需要认证的路由，可以在 beforeLoad 中使用
 * @param location - 当前位置对象，包含 pathname 和 searchStr
 * @throws {redirect} 如果用户未认证，抛出重定向对象
 */
export function requireAuth({ href }: { href: string }): void {
    if (!isTokenValid()) {
        throw redirect({
            to: '/account/login',
            search: {
                returnUrl: href,
            },
        });
    }
}

// 在模块加载时初始化跨标签页同步机制
if (typeof window !== 'undefined') {
    initTokenSync();
}