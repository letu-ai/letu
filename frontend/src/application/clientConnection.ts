import { getToken, isTokenValid } from '@/utils/authUtils';
import { fetchEventSource } from '@/lib/node-fetch-event-source';
import { getApiBaseUrl } from '@/utils/urlUtils';
import { tokenRefreshManager } from '@/utils/tokenRefreshManager';

// 连接状态枚举
const ConnectionState = {
    IDLE: 'idle',
    CONNECTING: 'connecting',
    CONNECTED: 'connected',
    DESTROYED: 'destroyed'
} as const;

type ConnectionState = typeof ConnectionState[keyof typeof ConnectionState];

// 消息处理器接口
interface MessageHandler {
    (data: any): void;
}

class ClientConnectionManager {
    private state: ConnectionState = ConnectionState.IDLE;
    private abortController: AbortController | null = null;

    private reconnectAttempt = 0;
    private readonly reconnectIntervals = [5000, 10000, 20000, 40000, 80000, 160000, 300000];

    private listeners = new Map<string, Set<MessageHandler>>();

    constructor() {
        setTimeout(() => {
            if (this.state === ConnectionState.IDLE) {
                this.connect();
            }
        }, 100);
    }

    public getConnectionState(): ConnectionState {
        return this.state;
    }

    public getReadyState(): number {
        switch (this.state) {
            case ConnectionState.CONNECTED:
                return 1;
            case ConnectionState.CONNECTING:
                return 0;
            default:
                return 2;
        }
    }

    private async connect(): Promise<void> {
        if (this.state === ConnectionState.CONNECTING ||
            this.state === ConnectionState.CONNECTED ||
            this.state === ConnectionState.DESTROYED) {
            return;
        }

        this.setState(ConnectionState.CONNECTING);

        try {
            if (!await this.validateToken()) {
                this.setState(ConnectionState.IDLE);
                return;
            }

            await this.establishConnection();

        } catch {
            this.setState(ConnectionState.IDLE);
        }
    }

    private async validateToken(): Promise<boolean> {
        try {
            const isValid = await isTokenValid();
            const token = getToken();
            return !!(isValid && token?.accessToken);
        } catch {
            return false;
        }
    }

    private async establishConnection(): Promise<void> {
        const token = getToken();
        if (!token?.accessToken) {
            throw new Error('No access token available');
        }

        this.abortController = new AbortController();
        const url = getApiBaseUrl() + '/api/my/notification/stream';

        await fetchEventSource(url, {
            signal: this.abortController.signal,
            headers: {
                'Authorization': `Bearer ${token.accessToken}`,
                'Accept': 'text/event-stream',
            },

            onopen: async (response) => {
                if (response.ok) {
                    console.log(`✓ SSE connected${this.reconnectAttempt > 0 ? ` (${this.reconnectAttempt} retries)` : ''}`);
                    this.setState(ConnectionState.CONNECTED);
                    this.reconnectAttempt = 0;
                    this.emit('connected', { message: 'Connected to server' });
                } else {
                    throw new Error(`Server error: ${response.status} ${response.statusText}`);
                }
            },

            onmessage: async (event) => {
                try {
                    if (!event.event || event.event === 'message') {
                        const data = JSON.parse(event.data);
                        this.emit('message', data);
                    } else if (event.event === 'notification') {
                        const data = JSON.parse(event.data);
                        this.emit('notification', data);
                    } else if (event.event === 'heartbeat') {
                        // 心跳事件，不需要处理
                    }
                } catch (error) {
                    console.error('Failed to parse server message:', error);
                }
            },

            onclose: () => {
                if (this.state === ConnectionState.CONNECTED) {
                    this.setState(ConnectionState.CONNECTING);
                    // 添加延时重连
                    const interval = this.getCurrentReconnectInterval();
                    this.reconnectAttempt++;
                    setTimeout(() => {
                        if (this.state === ConnectionState.CONNECTING) {
                            this.setState(ConnectionState.IDLE);
                            this.connect();
                        }
                    }, interval);
                }
            },

            onerror: (error) => {
                // 检测401错误（token过期）
                const isAuthError = (error as any)?.statusCode === 401 ||
                    (error as any)?.isAuthError === true ||
                    error?.message?.includes('401') ||
                    error?.message?.includes('Unauthorized') ||
                    error?.message?.includes('Token expired');

                if (isAuthError) {
                    console.log('SSE: Token expired, attempting to refresh...');

                    // 先终止当前连接
                    if (this.abortController) {
                        this.abortController.abort();
                        this.abortController = null;
                    }

                    this.setState(ConnectionState.IDLE);

                    // 启动token刷新
                    tokenRefreshManager.refreshToken().then(refreshed => {
                        if (refreshed) {
                            console.log('SSE: Token refreshed successfully, reconnecting with new token...');
                            // 刷新成功后，重置重连计数
                            this.reconnectAttempt = 0;
                            // 使用新token重新建立连接
                            this.connect();
                        } else {
                            console.log('SSE: Token refresh failed, stopping reconnection');
                            this.emit('auth-failed', { message: 'Authentication failed' });
                        }
                    }).catch(refreshError => {
                        console.error('SSE: Error during token refresh:', refreshError);
                        this.emit('auth-failed', { message: 'Authentication failed' });
                    });

                    // 返回null阻止fetchEventSource内部重连，由我们自己控制重连
                    return null;
                }

                // 其他错误按原有逻辑处理
                const interval = this.getCurrentReconnectInterval();
                this.reconnectAttempt++;
                this.setState(ConnectionState.CONNECTING);

                return interval;
            }
        });
    }


    private getCurrentReconnectInterval(): number {
        const index = Math.min(this.reconnectAttempt, this.reconnectIntervals.length - 1);
        return this.reconnectIntervals[index];
    }


    private setState(newState: ConnectionState): void {
        this.state = newState;
    }

    public on(eventType: string, handler: MessageHandler): void {
        if (!this.listeners.has(eventType)) {
            this.listeners.set(eventType, new Set());
        }
        this.listeners.get(eventType)!.add(handler);
    }

    public off(eventType: string, handler: MessageHandler): void {
        const handlers = this.listeners.get(eventType);
        if (handlers) {
            handlers.delete(handler);
            if (handlers.size === 0) {
                this.listeners.delete(eventType);
            }
        }
    }

    private emit(eventType: string, data: any): void {
        const handlers = this.listeners.get(eventType);
        if (handlers) {
            handlers.forEach(handler => {
                try {
                    handler(data);
                } catch (error) {
                    console.error(`Error in message handler for ${eventType}:`, error);
                }
            });
        }
    }

    public destroy(): void {
        this.setState(ConnectionState.DESTROYED);

        if (this.abortController) {
            this.abortController.abort();
            this.abortController = null;
        }

        this.listeners.clear();
    }
}

// 真正的全局单例实现
const GLOBAL_KEY = '__clientConnection_instance__';

function createSingletonInstance(): ClientConnectionManager {
    let instance: ClientConnectionManager = (globalThis as any)[GLOBAL_KEY];

    if (!instance) {
        instance = new ClientConnectionManager();
        (globalThis as any)[GLOBAL_KEY] = instance;
    }

    return instance;
}

// HMR支持：开发环境中的清理逻辑
if (import.meta.hot) {
    import.meta.hot.dispose(() => {
        const instance = (globalThis as any)[GLOBAL_KEY];
        if (instance) {
            instance.destroy();
            delete (globalThis as any)[GLOBAL_KEY];
        }
    });
}

// 导出单例实例
export const clientConnection = createSingletonInstance();

// 导出类型
export type { MessageHandler };
export { ConnectionState };