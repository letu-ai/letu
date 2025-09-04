import httpClient from '@/utils/httpClient';

/**
 * 登录
 * @param input
 */
export function loginByPassword(input: IPasswordLoginInput) {
    return httpClient.post<IPasswordLoginInput, IUserTokenOutput>('/api/identity/login', input);
}

/**
 * 短信登录
 * @param input
 */
export function loginBySms(input: ISmsLoginInput) {
    return httpClient.post<ISmsLoginInput, IUserTokenOutput>('/api/identity/SmsLogin', input);
}

/**
 * 注销
 */
export function logout() {
    return httpClient.post<void>('/api/identity/logout');
}

/**
 * 获取短信验证码
 * @param phone
 */
export function sendLoginSmsCode(phone: string) {
    return httpClient.post<string, string>('/api/identity/SendLoginSmsCode?phone=' + phone);
}

/**
 * 刷新token
 * @param refreshToken
 * @returns
 */
export function refreshToken(refreshToken: string) {
    return httpClient.post<string, IUserTokenOutput>('/api/identity/refresh-token', { refreshToken });
}

export function getLoginSettings() {
    return httpClient.get<ILoginSettingsOutput>('/api/account/login-settings');
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