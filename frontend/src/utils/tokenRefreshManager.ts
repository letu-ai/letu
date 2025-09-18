import { getToken, refreshToken as updateToken } from '@/utils/authUtils';
import { getApiBaseUrl } from '@/utils/urlUtils';

class TokenRefreshManager {
    private refreshTokenPromise: Promise<boolean> | null = null;

    /**
     * 刷新token（带防并发）
     * 如果多个请求同时触发刷新，只会执行一次实际的刷新请求
     */
    async refreshToken(): Promise<boolean> {
        // 如果已经有刷新请求在进行中，返回同一个promise
        if (this.refreshTokenPromise) {
            console.log('Token refresh already in progress, waiting...');
            return this.refreshTokenPromise;
        }

        const currentToken = getToken();
        if (!currentToken?.refreshToken) {
            console.warn('No refresh token available');
            return false;
        }

        console.log('Starting token refresh...');
        
        // 创建新的刷新promise
        this.refreshTokenPromise = this.performTokenRefresh(currentToken.refreshToken)
            .finally(() => {
                // 刷新完成后清空promise，允许下次刷新
                this.refreshTokenPromise = null;
            });

        return this.refreshTokenPromise;
    }

    /**
     * 执行实际的token刷新请求
     */
    private async performTokenRefresh(refreshTokenValue: string): Promise<boolean> {
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
                    console.log('Token refreshed successfully');
                    updateToken(
                        data.accessToken,
                        data.refreshToken,
                        data.expiredTime
                    );
                    return true;
                } else {
                    console.warn('Token refresh response missing data');
                    return false;
                }
            } else {
                console.error(`Token refresh failed with status: ${response.status}`);
                return false;
            }
        } catch (error) {
            console.error('Token refresh error:', error);
            return false;
        }
    }

    /**
     * 清除正在进行的刷新操作
     * 用于清理或重置状态
     */
    clearPendingRefresh(): void {
        this.refreshTokenPromise = null;
    }
}

// 导出单例实例
export const tokenRefreshManager = new TokenRefreshManager();