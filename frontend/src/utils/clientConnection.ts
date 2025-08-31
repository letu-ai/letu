import { getToken, ensureTokenValid } from '@/utils/authUtils';
import { fetchEventSource } from '@/lib/node-fetch-event-source';
import { getBaseUrl } from '@/utils/httpClient';

interface MessageHandler {
  (data: any): void;
}

class ClientConnectionManager {
  private abortController: AbortController | null = null;
  private connectionPromise: Promise<void> | null = null;
  private reconnectInterval = 5000; // 5秒重连
  private maxReconnectAttempts = 10;
  private reconnectAttempts = 0;
  private isConnecting = false;
  private isConnected = false;
  private connectionCheckInterval: NodeJS.Timeout | null = null;
  private listeners: Map<string, MessageHandler[]> = new Map();

  constructor() {
    this.init();
  }

  private init() {
    // 立即尝试连接
    this.attemptConnection();
    
    // 定期检查连接状态
    this.connectionCheckInterval = setInterval(() => {
      this.checkConnectionHealth();
    }, 30000); // 30秒检查一次
  }

  private async attemptConnection() {
    if (this.isConnecting || this.isConnected) {
      return;
    }

    try {
      const isValid = await ensureTokenValid();
      if (!isValid) {
        console.log('Token validation failed, will retry connection later');
        setTimeout(() => this.attemptConnection(), this.reconnectInterval);
        return;
      }
    } catch (error) {
      console.error('Token validation error during connection attempt:', error);
      setTimeout(() => this.attemptConnection(), this.reconnectInterval);
      return;
    }

    this.connect();
  }

  private async connect() {
    if (this.isConnecting) return;

    this.isConnecting = true;
    const token = getToken();
    
    if (!token?.accessToken) {
      console.warn('No valid access token available for connection');
      this.isConnecting = false;
      this.scheduleReconnect();
      return;
    }

    try {
      this.abortController = new AbortController();
      const url = getBaseUrl() + '/api/my/notification/stream';
      
      this.connectionPromise = fetchEventSource(url, {
        signal: this.abortController.signal,
        headers: {
          'Authorization': `Bearer ${token.accessToken}`,
          'Accept': 'text/event-stream',
        },
        
        onopen: async (response) => {
          if (response.ok) {
            console.log('Client connection established');
            this.isConnecting = false;
            this.isConnected = true;
            this.reconnectAttempts = 0;
            this.dispatchMessage('connected', { message: 'Connected to server' });
          } else {
            throw new Error(`Server error: ${response.status} ${response.statusText}`);
          }
        },

        onmessage: async (event) => {
          try {
            // 默认消息事件
            if (!event.event || event.event === 'message') {
              const data = JSON.parse(event.data);
              this.dispatchMessage('message', data);
            }
            // 处理自定义事件类型
            else if (event.event === 'notification') {
              const data = JSON.parse(event.data);
              this.dispatchMessage('notification', data);
            }
            else if (event.event === 'connected') {
              console.log('Server connection confirmed:', event.data);
            }
            else if (event.event === 'heartbeat') {
              // 心跳事件，保持连接活跃
            }
          } catch (error) {
            console.error('Failed to parse server message:', error);
          }
        },

        onclose: () => {
          console.log('Connection closed by server');
          this.isConnected = false;
          this.scheduleReconnect();
        },

        onerror: (error) => {
          console.error('Client connection error:', error);
          this.isConnected = false;
          this.isConnecting = false;
          // 返回重连间隔时间，否则 fetchEventSource 会使用默认值
          return this.reconnectInterval;
        }
      });

      // 等待连接完成或被中断
      await this.connectionPromise;
      
    } catch (error) {
      console.error('Failed to establish client connection:', error);
      this.isConnecting = false;
      this.isConnected = false;
      this.scheduleReconnect();
    } finally {
      this.connectionPromise = null;
    }
  }

  private cleanupConnection() {
    if (this.abortController) {
      this.abortController.abort();
      this.abortController = null;
    }
    this.connectionPromise = null;
    this.isConnecting = false;
    this.isConnected = false;
  }

  private scheduleReconnect() {
    if (this.reconnectAttempts >= this.maxReconnectAttempts) {
      console.error('Max reconnection attempts reached');
      this.dispatchMessage('error', { message: 'Max reconnection attempts reached' });
      return;
    }

    this.reconnectAttempts++;
    setTimeout(() => {
      console.log(`Attempting to reconnect (${this.reconnectAttempts}/${this.maxReconnectAttempts})...`);
      this.attemptConnection();
    }, this.reconnectInterval);
  }

  private async checkConnectionHealth() {
    try {
      const isValid = await ensureTokenValid();
      
      if (!isValid && this.isConnected) {
        // token失效，关闭连接
        console.log('Token expired, closing connection');
        this.cleanupConnection();
      } else if (isValid && !this.isConnected && !this.isConnecting) {
        // token有效但连接断开，尝试重连
        console.log('Token valid but connection lost, attempting to reconnect');
        this.attemptConnection();
      }
    } catch (error) {
      console.error('Error during connection health check:', error);
      if (this.isConnected) {
        // 健康检查失败，关闭连接
        console.log('Health check failed, closing connection');
        this.cleanupConnection();
      }
    }
  }

  public registerMessageHandler(eventType: string, handler: MessageHandler) {
    if (!this.listeners.has(eventType)) {
      this.listeners.set(eventType, []);
    }
    this.listeners.get(eventType)!.push(handler);
  }

  public unregisterMessageHandler(eventType: string, handler: MessageHandler) {
    const handlers = this.listeners.get(eventType);
    if (handlers) {
      const index = handlers.indexOf(handler);
      if (index !== -1) {
        handlers.splice(index, 1);
      }
    }
  }

  private dispatchMessage(eventType: string, data: any) {
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

  public getConnectionState(): number {
    if (this.isConnected) {
      return 1; // EventSource.OPEN
    } else if (this.isConnecting) {
      return 0; // EventSource.CONNECTING
    } else {
      return 2; // EventSource.CLOSED
    }
  }

  public destroy() {
    if (this.connectionCheckInterval) {
      clearInterval(this.connectionCheckInterval);
      this.connectionCheckInterval = null;
    }
    this.cleanupConnection();
    this.listeners.clear();
  }
}

// 创建并导出单例实例
export const clientConnection = new ClientConnectionManager();

// 导出类型定义
export type { MessageHandler };