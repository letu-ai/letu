/**
 * AsyncStorage 封装
 */
import AsyncStorage from '@react-native-async-storage/async-storage';

const STORAGE_KEYS = {
  ACCESS_TOKEN: '@auth/accessToken',
  REFRESH_TOKEN: '@auth/refreshToken',
  TOKEN_EXPIRED_TIME: '@auth/tokenExpiredTime',
  REMEMBERED_USERNAME: '@auth/rememberedUsername',
  REMEMBER_ME: '@auth/rememberMe',
  DEVICE_INFO: '@device/info',
  PUSH_INIT: '@push/init',
} as const;

export const storage = {
  // Token相关
  async getAccessToken(): Promise<string | null> {
    return await AsyncStorage.getItem(STORAGE_KEYS.ACCESS_TOKEN);
  },

  async setAccessToken(token: string): Promise<void> {
    await AsyncStorage.setItem(STORAGE_KEYS.ACCESS_TOKEN, token);
  },

  async getRefreshToken(): Promise<string | null> {
    return await AsyncStorage.getItem(STORAGE_KEYS.REFRESH_TOKEN);
  },

  async setRefreshToken(token: string): Promise<void> {
    await AsyncStorage.setItem(STORAGE_KEYS.REFRESH_TOKEN, token);
  },

  async getTokenExpiredTime(): Promise<Date | null> {
    const timeStr = await AsyncStorage.getItem(STORAGE_KEYS.TOKEN_EXPIRED_TIME);
    return timeStr ? new Date(timeStr) : null;
  },

  async setTokenExpiredTime(time: Date): Promise<void> {
    await AsyncStorage.setItem(STORAGE_KEYS.TOKEN_EXPIRED_TIME, time.toISOString());
  },

  async clearTokens(): Promise<void> {
    await Promise.all([
      AsyncStorage.removeItem(STORAGE_KEYS.ACCESS_TOKEN),
      AsyncStorage.removeItem(STORAGE_KEYS.REFRESH_TOKEN),
      AsyncStorage.removeItem(STORAGE_KEYS.TOKEN_EXPIRED_TIME),
    ]);
  },

  // 记住我相关
  async getRememberedUsername(): Promise<string | null> {
    return await AsyncStorage.getItem(STORAGE_KEYS.REMEMBERED_USERNAME);
  },

  async setRememberedUsername(username: string): Promise<void> {
    await AsyncStorage.setItem(STORAGE_KEYS.REMEMBERED_USERNAME, username);
  },

  async getRememberMe(): Promise<boolean> {
    const value = await AsyncStorage.getItem(STORAGE_KEYS.REMEMBER_ME);
    return value === 'true';
  },

  async setRememberMe(value: boolean): Promise<void> {
    await AsyncStorage.setItem(STORAGE_KEYS.REMEMBER_ME, value.toString());
  },

  async clearRememberMe(): Promise<void> {
    await Promise.all([
      AsyncStorage.removeItem(STORAGE_KEYS.REMEMBERED_USERNAME),
      AsyncStorage.removeItem(STORAGE_KEYS.REMEMBER_ME),
    ]);
  },

  // JSON存储辅助方法
  async getJSON<T = any>(key: string): Promise<T | null> {
    const value = await AsyncStorage.getItem(key);
    return value ? JSON.parse(value) : null;
  },

  async setJSON(key: string, value: any): Promise<void> {
    await AsyncStorage.setItem(key, JSON.stringify(value));
  },

  async removeItem(key: string): Promise<void> {
    await AsyncStorage.removeItem(key);
  },
};

