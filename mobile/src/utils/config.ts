/**
 * API 配置
 */
import { Platform } from 'react-native';
import {
  API_BASE_URL_ANDROID_DEV,
  API_BASE_URL_IOS_DEV,
  API_BASE_URL_DEVICE,
  API_BASE_URL_PROD,
} from '@env';

/**
 * 获取API基础地址
 * 优先级：环境变量 > 默认值
 */
function getApiBaseUrl(): string {
  // 生产环境
  if (!__DEV__) {
    return API_BASE_URL_PROD || 'https://your-production-api.com';
  }

  // 开发环境
  // 如果设置了真机调试地址，优先使用（适用于真机调试）
  if (API_BASE_URL_DEVICE) {
    return API_BASE_URL_DEVICE;
  }

  // 根据平台使用对应的模拟器地址
  if (Platform.OS === 'android') {
    return API_BASE_URL_ANDROID_DEV || 'http://10.0.2.2:5050';
  } else {
    return API_BASE_URL_IOS_DEV || 'http://localhost:5050';
  }
}

const API_BASE_URL = getApiBaseUrl();

export { getApiBaseUrl, API_BASE_URL };

