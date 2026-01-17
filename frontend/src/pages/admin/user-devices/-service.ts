import httpClient from '@/utils/httpClient';
import type { PagedResult, PagedResultRequest } from '@/types/api';
import type { ClientType } from '@/pages/account/-service';

/**
 * 获取用户设备列表
 * @param dto
 */
export function getUserDevices(dto: IUserDeviceListInput) {
  return httpClient.get<IUserDeviceListInput, PagedResult<IUserDeviceListOutput>>(
    '/api/admin/user-devices',
    {
      params: dto,
    },
  );
}

export interface IUserDeviceListInput extends PagedResultRequest {
  /** 用户ID(精确匹配) */
  userId?: string;
  /** 用户名(模糊搜索) */
  userName?: string;
  /** 客户端类型筛选 */
  clientType?: ClientType;
  /** 包名筛选 */
  packageName?: string;
}

export interface IUserDeviceListOutput {
  /** 设备ID */
  id: string;
  /** 用户ID */
  userId: string;
  /** 用户名 */
  userName: string | null;
  /** 用户昵称 */
  userNickName: string | null;
  /** 客户端类型 */
  clientType: ClientType;
  /** 包名 */
  packageName: string | null;
  /** 设备ID */
  deviceId: string | null;
  /** 设备名称 */
  deviceName: string | null;
  /** 推送设备ID */
  pushDeviceId: string | null;
  /** 应用版本 */
  appVersion: string | null;
  /** 最后活跃时间 */
  lastActiveTime: string;
  /** 创建时间 */
  creationTime: string;
}
