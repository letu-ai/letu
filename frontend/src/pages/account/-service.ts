import httpClient from '@/utils/httpClient';
import { getTenantInfo } from '@/utils/authUtils';
import type { IHttpClientConfig } from '@/utils/httpClient';
import type { AxiosRequestConfig } from 'axios';


function buildTenantHeaders(): IHttpClientConfig {
    const tenantInfo = getTenantInfo();
    const config = {} as AxiosRequestConfig;
    if (tenantInfo?.tenantId) {
        config.headers = {
            [tenantInfo.tenantKey]: tenantInfo.tenantId
        }
    }

    return config;
}

/**
 * 登录
 * @param input
 */
export function loginByPassword(input: IPasswordLoginInput) {
    const config = buildTenantHeaders();
    config.anonymous = true;
    config.withCredentials = true; //确保登录成功后设置的cookie能被浏览器正确接收
    input.clientType = "Web";

    return httpClient.post<IPasswordLoginInput, IUserTokenOutput>('/api/identity/login', input, config);
}
/**
 * 短信登录
 * @param input
 */
export function loginBySms(input: ISmsLoginInput) {
    const config = buildTenantHeaders();
    config.withCredentials = true; //确保登录成功后设置的cookie能被浏览器正确接收
    config.anonymous = true;

    return httpClient.post<ISmsLoginInput, IUserTokenOutput>('/api/identity/SmsLogin', input, config);
}

/**
 * 注销
 */
export function logout() {
    const config = buildTenantHeaders();
    config.withCredentials = true; //确保注销成功后，cookie能被浏览器正确删除

    return httpClient.post<void>('/api/identity/logout', null, config);
}

/**
 * 获取短信验证码
 * @param phone
 */
export function sendLoginSmsCode(phone: string) {
    const config = {} as IHttpClientConfig;
    return httpClient.post<string, string>('/api/identity/SendLoginSmsCode?phone=' + phone, undefined, config);
}

/**
 * 刷新token
 * @param refreshToken
 * @returns
 */
export function refreshToken(refreshToken: string) {
    const config = {} as IHttpClientConfig;
    config.withCredentials = true; //确保刷新token成功后，cookie能被浏览器正确接收

    return httpClient.post<string, IUserTokenOutput>('/api/identity/refresh-token', { refreshToken }, config);
}

export function getLoginSettings() {
    const config = buildTenantHeaders() as IHttpClientConfig;
    config.anonymous = true; // 匿名请求，不需要token认证
    config.withCredentials = true; 
    return httpClient.get<ILoginSettingsOutput>('/api/account/login-settings', config);
}

export function switchTenant(tenantName?: string) {
    return httpClient.post<void, ISwitchTenantOutput>('/api/account/switch-tenant', null, { params: { tenantName } });
}


export interface ILoginSettingsOutput {
    tenantName?: string;

    multiTenancyEnabled: boolean;

    enableUserNameLogin: boolean;

    enableEmailLogin: boolean;

    enablePhoneNumberLogin: boolean;

    enableUserNameRegistration: boolean;

    enableEmailRegistration: boolean;

    enablePhoneNumberRegistration: boolean;

    isSelfRegistrationEnabled: boolean;

    allowPasswordRecovery: boolean;

    externalProviders?: IExternalProviderOutput[];
}

export interface IExternalProviderOutput {
    displayName: string;
    name: string;
}

export interface ISwitchTenantOutput {
    success: boolean;

    cookieKey: string;

    tenantId?: string;
}


export type ClientType = "Web" | "PC" | "Android" | "IOS" | "WechatMiniProgram" | "HarmonyOS" | "Other";
export type LoginChannel = "Account" | "SMS" | "ThirdParty";

export interface IPasswordLoginInput {
    userName: string;
    password: string;
    rememberMe: boolean;
    clientType: ClientType;
    appVersion: string;
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