import { getToken, updateToken } from '@/utils/authUtils';
import { getApiBaseUrl } from '@/utils/urlUtils';

// 使用闭包存储刷新状态，实现防并发
let refreshTokenPromise: Promise<boolean> | null = null;

/**
 * 执行实际的token刷新请求
 */
async function performTokenRefresh(refreshTokenValue: string): Promise<boolean> {
    try {
        const response = await fetch(
            `${getApiBaseUrl()}/api/identity/refresh-token`,
            {
                method: 'POST',
                credentials: 'include', // 确保刷新token成功后，cookie能被浏览器正确接收
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ refreshToken: refreshTokenValue }),
                // 设置超时时间
                signal: AbortSignal.timeout(30000),
            }
        );

        if (response.ok) {
            const data = await response.json();
            
            if (data && data.accessToken) {
                updateToken(
                    data.accessToken,
                    data.refreshToken,
                    data.expiredTime
                );
                return true;
            } else {
                console.warn('刷新token响应缺少数据');
                return false;
            }
        } else {
            console.error(`刷新token失败，状态码: ${response.status}`);
            return false;
        }
    } catch (error) {
        console.error('刷新token失败，', error);
        return false;
    }
}

/**
 * 刷新token（带防并发）
 * 如果多个请求同时触发刷新，只会执行一次实际的刷新请求
 */
export async function refreshToken(): Promise<boolean> {
    // 如果已经有刷新请求在进行中，返回同一个promise
    if (refreshTokenPromise) {
        return refreshTokenPromise;
    }

    const currentToken = getToken();
    if (!currentToken?.refreshToken) {
        console.warn('没有找到refreshToken');
        return false;
    }

    // 创建新的刷新promise
    refreshTokenPromise = performTokenRefresh(currentToken.refreshToken)
        .finally(() => {
            // 刷新完成后清空promise，允许下次刷新
            refreshTokenPromise = null;
        });

    return refreshTokenPromise;
}


// 导出对象以保持向后兼容
export const tokenRefreshManager = {
    refreshToken
};