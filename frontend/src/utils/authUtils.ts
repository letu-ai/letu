import type { IUserTokenOutput } from '@/pages/account/-service';
import { redirect } from '@tanstack/react-router';

// 存储键名
const TOKEN_KEY = 'auth-token';
const REMEMBER_ME_KEY = 'auth-remember-me';
const SAVED_USERNAME_KEY = 'auth-saved-username';
const TENANT_ID_KEY = 'auth-tenant-id';
const TENANT_KEY_KEY = 'auth-tenant-key';


/**
 * 获取存储对象（根据记住我状态）
 */
function getStorage(): Storage {
    const rememberMe = localStorage.getItem(REMEMBER_ME_KEY) === 'true';
    return rememberMe ? localStorage : sessionStorage;
}

/**
 * 设置 Token
 */
export function setToken(token: IUserTokenOutput, rememberMe: boolean = false): void {
    localStorage.setItem(REMEMBER_ME_KEY, rememberMe.toString());

    const storage = rememberMe ? localStorage : sessionStorage;
    storage.setItem(TOKEN_KEY, JSON.stringify(token));

    // 清除另一个存储中的 token
    if (!rememberMe) {
        localStorage.removeItem(TOKEN_KEY);
    }
}

/**
 * 获取 Token
 */
export function getToken(): IUserTokenOutput | null {
    try {
        const storage = getStorage();
        const tokenStr = storage.getItem(TOKEN_KEY);
        return tokenStr ? JSON.parse(tokenStr) : null;
    } catch {
        return null;
    }
}

/**
 * 写入新的 Token（用于刷新token）
 */
export function refreshToken(accessToken: string, refreshToken?: string, expiredTime?: Date): void {
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
        return now < expiredTime;
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

/**
 * 检查token是否需要刷新
 * @returns {boolean} 是否需要刷新token
 */
export function shouldRefreshToken(): boolean {
    const token = getToken();

    if (!token || !token.accessToken || !token.refreshToken) {
        return false;
    }

    const now = Date.now();
    const expiredTime = token.expiredTime ? new Date(token.expiredTime).getTime() : 0;

    if (!expiredTime) {
        return false;
    }

    // 判断是否需要刷新：已过期或10分钟内即将过期
    const tenMinutesFromNow = now + 10 * 60 * 1000;
    return now >= expiredTime || expiredTime < tenMinutesFromNow;
}