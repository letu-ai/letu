/**
 * 认证相关 API 服务
 * 参考 frontend/src/pages/account/-service.ts
 */
import httpClient from '@/api/httpClient';


/**
 * 认证相关类型定义
 */

export interface IPasswordLoginInput {
    userName: string;
    password: string;
    rememberMe?: boolean;
  }
  
  export interface IUserTokenOutput {
    type: string;
    accessToken: string;
    refreshToken?: string;
    expiredTime: Date;
  }
  
  export interface IRefreshTokenInput {
    refreshToken: string;
  }
  

/**
 * 密码登录
 */
export function loginByPassword(input: IPasswordLoginInput): Promise<IUserTokenOutput> {
  return httpClient.post<IPasswordLoginInput, IUserTokenOutput>(
    '/api/identity/login',
    input,
    {
      anonymous: true,
    }
  );
}

/**
 * 注销
 */
export function logout(): Promise<void> {
  return httpClient.post<void>('/api/identity/logout', null, {
    anonymous: false,
  });
}

/**
 * 刷新Token
 */
export function refreshToken(refreshToken: string): Promise<IUserTokenOutput> {
  return httpClient.post<IRefreshTokenInput, IUserTokenOutput>(
    '/api/identity/refresh-token',
    { refreshToken },
    {
      anonymous: true,
    }
  );
}

