import httpClient from '@/utils/httpClient';

/**
 * 登录
 * @param dto
 */
export function loginByPassword(dto: IPasswordLoginInput) {
  return httpClient.post<IPasswordLoginInput, IUserTokenOutput>('/api/account/login', dto);
}

/**
 * 短信登录
 * @param dto
 */
export function loginBySms(dto: ISmsLoginInput) {
  return httpClient.post<ISmsLoginInput, IUserTokenOutput>('/api/account/SmsLogin', dto);
}

/**
 * 注销
 */
export function logout() {
  return httpClient.post<void>('/api/account/logout');
}

/**
 * 获取短信验证码
 * @param phone
 */
export function sendLoginSmsCode(phone: string) {
  return httpClient.post<string, string>('/api/account/SendLoginSmsCode?phone=' + phone);
}

/**
 * 刷新token
 * @param refreshToken
 * @returns
 */
export function refreshToken(refreshToken: string) {
  return httpClient.post<string, IUserTokenOutput>('/api/account/refresh-token', { refreshToken });
}

/**
 * 修改个人基本信息
 * @param info
 */
export function updateInfo(info: PersonalInfoDto) {
  return httpClient.put<PersonalInfoDto, void>('/api/account/updateInfo', info);
}

/**
 * 修改个人密码
 * @param dto
 */
export function updatePwd(dto: UserPwdDto) {
  return httpClient.put<UserPwdDto, void>('/api/account/updatePwd', dto);
}

/**
 * 用户权限信息
 */
export function getUserAuth() {
  return httpClient.get<unknown, UserAuthInfoDto>('/api/account/userAuth');
}

export interface IPasswordLoginInput {
  userName: string;
  password: string;
  rememberMe: boolean;
}

export interface ISmsLoginInput {
  phone: string;
  code: string;
}


export interface IRefreshTokenInput {
    refreshToken: string;
}

export interface IUserTokenOutput {
    type: string;
    accessToken: string;
    refreshToken?: string;
    expiredTime: Date;
}

export interface PersonalInfoDto {
  avatar?: string;
  nickName?: string;
  sex?: number;
  phone?: string;
}

export interface UserPwdDto {
  oldPwd: string;
  newPwd: string;
}

interface UserInfoDto {
  userId: string;
  userName: string;
  avatar: string;
  nickName: string;
  sex: number;
  employeeId?: string | null;
  phone?: string | null;
}

export interface IFrontendMenu {
  id: string;
  title: string;
  icon: string | null;
  display: boolean;
  path: string;
  component: string | null;
  children: IFrontendMenu[] | null;
  layerName: string;
  menuType: number;
  isExternal: boolean;
}

interface UserAuthInfoDto {
    sessionId: string;
    user: UserInfoDto;
    permissions: string[];
    menus: IFrontendMenu[];
}
