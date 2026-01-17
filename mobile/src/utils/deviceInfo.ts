/**
 * 设备信息收集工具
 */
import { Platform } from 'react-native';
import DeviceInfo from 'react-native-device-info';
import { storage } from './storage';

// 设备信息缓存key
const DEVICE_CACHE_KEY = '@device/info';

export interface DeviceInfo {
  packageName: string;           // 应用包名
  deviceId: string;              // 设备唯一ID
  deviceName: string;            // 设备友好名称
  clientType: 'Android' | 'IOS'; // 客户端类型
  appVersion: string;            // 应用版本号
}

/**
 * 获取设备信息（带缓存）
 */
export async function getDeviceInfo(): Promise<DeviceInfo> {
  // 先尝试从缓存读取
  const cached = await storage.getJSON<DeviceInfo>(DEVICE_CACHE_KEY);
  if (cached) {
    return cached;
  }

  // 收集设备信息
  const info: DeviceInfo = {
    packageName: await DeviceInfo.getBundleId(),
    deviceId: await DeviceInfo.getUniqueId(),
    deviceName: await getDeviceFriendlyName(),
    clientType: Platform.OS === 'ios' ? 'IOS' : 'Android',
    appVersion: DeviceInfo.getVersion(),
  };

  // 缓存设备信息
  await storage.setJSON(DEVICE_CACHE_KEY, info);

  return info;
}

/**
 * 获取设备友好名称
 */
async function getDeviceFriendlyName(): Promise<string> {
  const model = await DeviceInfo.getModel();
  const brand = await DeviceInfo.getBrand();

  // iOS设备
  if (Platform.OS === 'ios') {
    return model; // 如 "iPhone 13 Pro"
  }

  // Android设备
  // 某些Android设备的brand和model可能相同，避免重复
  return brand === model ? model : `${brand} ${model}`;
}

/**
 * 清除设备信息缓存
 */
export async function clearDeviceInfoCache(): Promise<void> {
  await storage.removeItem(DEVICE_CACHE_KEY);
}
