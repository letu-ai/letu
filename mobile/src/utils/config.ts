/**
 * API 配置
 */
import { Platform } from 'react-native';

// 开发环境API地址，Android模拟器使用10.0.2.2访问localhost
const API_BASE_URL = __DEV__
  ? Platform.OS === 'android'
    ? 'http://10.0.2.2:5050'
    : 'http://localhost:5050'
  : 'https://your-production-api.com';

export function getApiBaseUrl(): string {
  return API_BASE_URL;
}

