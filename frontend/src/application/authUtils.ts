import type { IUserTokenOutput } from '@/pages/account/service';

// 存储键名
const TOKEN_KEY = 'auth-token';
const REMEMBER_ME_KEY = 'auth-remember-me';
const SAVED_USERNAME_KEY = 'auth-saved-username';

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
