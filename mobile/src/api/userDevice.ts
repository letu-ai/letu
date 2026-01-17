/**
 * 用户设备信息 API
 */
import httpClient from './httpClient';
import { getDeviceInfo } from '@/utils/deviceInfo';

/**
 * 保存用户设备信息输入
 */
export interface ISaveUserDeviceInput {
  packageName: string;      // 应用包名
  deviceId: string;         // 登录设备ID
  deviceName: string;       // 设备友好名
  clientType: 'Android' | 'IOS' | 'Web' | 'PC' | 'WechatMiniProgram' | 'HarmonyOS' | 'Other';
  appVersion: string;       // 应用版本号
  pushDeviceId: string;     // 推送设备ID
  pushDeviceToken?: string; // 推送设备Token（可选）
}

/**
 * 保存当前用户的设备信息
 */
export async function saveUserDevice(pushDeviceId: string, pushDeviceToken?: string): Promise<void> {
  const deviceInfo = await getDeviceInfo();

  const input: ISaveUserDeviceInput = {
    ...deviceInfo,
    pushDeviceId,
    pushDeviceToken,
  };

  await httpClient.post('/api/account/user-devices', input, {
    anonymous: false, // 需要登录
  });
}

/**
 * 删除当前用户的设备信息
 */
export async function deleteUserDevice(deviceId: string, packageName: string): Promise<void> {
  await httpClient.delete('/api/account/user-devices', {
    anonymous: false,
    params: { deviceId, packageName },
  });
}
