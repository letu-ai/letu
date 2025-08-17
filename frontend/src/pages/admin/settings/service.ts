import httpClient from '@/utils/httpClient';

export interface ITimeZone {
    name: string;
    value: string;
}

export interface ITimeZoneSettings {
    timeZoneId: string;
    concurrencyStamp: string;
}

export function fetchTimeZones(): Promise<ITimeZone[]> {
    return httpClient.get<void, ITimeZone[]>("/api/admin/setting-management/timezone/timezones");
}

export function fetchTimeZoneSettings(): Promise<string> {
    return httpClient.get<void, string>("/api/admin/setting-management/timezone");
}

export function updateTimeZoneSettings(data: string): Promise<void> {
    return httpClient.post<string, void>("/api/admin/setting-management/timezone", JSON.stringify(data));
}

export interface IEmailSettings {
    smtpHost: string;
    smtpPort: number;
    smtpUserName: string;
    smtpPassword: string;
    smtpDomain: string;
    smtpEnableSsl?: boolean;
    smtpUseDefaultCredentials?: boolean;
    defaultFromAddress: string;
    defaultFromDisplayName: string;
}

export interface ISendTestEmailInput {
    senderEmailAddress: string;
    targetEmailAddress: string;
    subject: string;
    body: string;
}

export function fetchEmailSettings(): Promise<IEmailSettings> {
    return httpClient.get<void, IEmailSettings>("/api/admin/setting-management/emailing");
}

export function updateEmailSettings(data: IEmailSettings): Promise<void> {
    return httpClient.post<IEmailSettings, void>("/api/admin/setting-management/emailing", data);
}

export function sendTestEmail(data: ISendTestEmailInput): Promise<void> {
    return httpClient.post<ISendTestEmailInput, void>("/api/admin/setting-management/emailing/send-test-email", data);
}


export interface IAccountSettings {
    // Account
    isSelfRegistrationEnabled?: boolean;
    enableLocalLogin?: boolean;
    allowPasswordRecovery?: boolean;
    
    // Password
    passwordRequiredLength: number;
    passwordRequiredUniqueChars: number;
    passwordRequireNonAlphanumeric?: boolean;
    passwordRequireLowercase?: boolean;
    passwordRequireUppercase?: boolean;
    passwordRequireDigit?: boolean;
    forceUsersToPeriodicallyChangePassword?: boolean;
    passwordChangePeriodDays: number;

    // Lockout
    allowedForNewUsers?: boolean;
    lockoutDuration: number;
    maxFailedAccessAttempts: number;

    // SignIn
    signInRequireConfirmedEmail?: boolean;
    signInEnablePhoneNumberConfirmation?: boolean;
    signInRequireConfirmedPhoneNumber?: boolean;
    signInAllowMultipleLogin?: boolean;

    // User
    isUserNameUpdateEnabled?: boolean;
    isEmailUpdateEnabled?: boolean;

}

export function fetchAccountSettings(): Promise<IAccountSettings> {
    return httpClient.get<void, IAccountSettings>("/api/admin/setting-management/account");
}

export function updateAccountSettings(data: IAccountSettings): Promise<void> {
    return httpClient.post<IAccountSettings, void>("/api/admin/setting-management/account", data);
}

