import type { IUserTokenOutput } from '@/pages/account/-service';
import { refreshToken as refreshTokenAPI } from '@/pages/account/-service';
import { redirect } from '@tanstack/react-router';

// 存储键名
const TOKEN_KEY = 'auth-token';
const REMEMBER_ME_KEY = 'auth-remember-me';
const SAVED_USERNAME_KEY = 'auth-saved-username';

// 全局token刷新Promise，防止并发刷新
let refreshTokenPromise: Promise<void> | null = null;

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
 * 刷新 Token
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

/**
 * 获取保存的用户名
 */
export function getSavedUserName(): string {
    return localStorage.getItem(SAVED_USERNAME_KEY) || '';
}

/**
 * 判断 Token 是否有效
 */
export function isTokenValid(): boolean {
    const token = getToken();

    if (!token || !token.accessToken) {
        return false;
    }

    // 如果有过期时间，检查是否过期
    if (token.expiredTime) {
        // 统一转换为 UTC 时间戳进行比较，避免时区问题
        const expiredTime = new Date(token.expiredTime).getTime();
        const now = Date.now(); // 当前 UTC 时间戳

        // 提前5分钟判断为过期，避免边界情况
        const bufferTime = 5 * 60 * 1000; // 5分钟
        return now < (expiredTime - bufferTime);
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
export function requireAuth({ href}: { href: string }): void {
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
 * 确保token有效，必要时自动刷新
 * @returns Promise<boolean> 返回token是否有效
 */
export async function ensureTokenValid(): Promise<boolean> {
    const token = getToken();
    
    if (!token || !token.accessToken) {
        return false;
    }
    
    const now = Date.now();
    const expiredTime = token.expiredTime ? new Date(token.expiredTime).getTime() : 0;
    
    // token已过期
    if (expiredTime && now >= expiredTime) {
        return false;
    }
    
    // token在10分钟内过期，需要刷新
    const tenMinutesFromNow = now + 10 * 60 * 1000;
    if (expiredTime && expiredTime < tenMinutesFromNow && token.refreshToken) {
        // 防止并发刷新
        if (!refreshTokenPromise) {
            console.log(`token即将过期，开始刷新。剩余时间：${Math.floor((expiredTime - now) / 1000)}秒`);
            
            refreshTokenPromise = refreshTokenAPI(token.refreshToken)
                .then((res) => {
                    if (res) {
                        console.log('token刷新成功');
                        refreshToken(res.accessToken, res.refreshToken, res.expiredTime);
                    } else {
                        console.warn('token刷新返回空结果');
                        throw new Error('Token refresh returned null');
                    }
                })
                .catch((error) => {
                    console.error('token刷新失败:', error);
                    // 刷新失败，清除token
                    clearToken();
                    throw error;
                })
                .finally(() => {
                    refreshTokenPromise = null;
                });
        }
        
        try {
            await refreshTokenPromise;
            return isTokenValid();
        } catch {
            // 刷新失败
            return false;
        }
    }
    
    return true;
}
