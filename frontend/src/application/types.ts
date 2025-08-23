export interface ICurrentUser {
    isAuthenticated: boolean;
    id?: string | null;
    tenantId?: string | null;
    impersonatorUserId?: string | null;
    impersonatorTenantId?: string | null;
    impersonatorUserName?: string | null;
    impersonatorTenantName?: string | null;
    userName?: string | null;
    name?: string | null;
    surName?: string | null;
    email?: string | null;
    emailVerified: boolean;
    phoneNumber?: string | null;
    phoneNumberVerified: boolean;
    roles: string[];
    sessionId?: string | null;
}

export interface ICurrentTenant {
    id?: string | null;
    name?: string | null;
    isAvailable: boolean;
}

export interface IAbpLanguage {
    cultureName: string;
    uiCultureName: string;
    displayName: string;
    flagIcon?: string;
}

export interface IJsonSerilizable {
    toJSON(): string;
}

export interface IAbpNameValuePair {
    name: string;
    value: IJsonSerilizable | string | string[];
}

export interface IAbpDateTimeFormat {
    calendarAlgorithmType: string;
    dateTimeFormatLong: string;
    shortDatePattern: string;
    fullDateTimePattern: string;
    dateSeparator: string;
    shortTimePattern: string;
    longTimePattern: string;
}

export interface IAbpCulture {
    displayName: string;
    englishName: string;
    threeLetterIsoLanguageName: string;
    twoLetterIsoLanguageName: string;
    isRightToLeft: boolean;
    cultureName: string;
    name: string;
    nativeName: string;
    dateTimeFormat: IAbpDateTimeFormat;
}

export interface IAbpResourceValue {
    value?: string,
    found: boolean
}

export interface IAbpResource {
    texts: Record<string, string>,
    baseResources: string[]
}

// 时区信息接口
export interface IAbpTimezone {
    iana: {
        timeZoneName: string;
    };
    windows: {
        timeZoneId: string;
    };
}

export interface ILetuApplicationConfiguration {
    /* LOCALIZATION ***********************************************/
    localization: {
        values: Record<string, Record<string, string>>;
        resources: Record<string, IAbpResource>;
        languages: IAbpLanguage[];
        currentCulture: IAbpCulture;
        defaultResourceName?: string | null;
        languagesMap: Record<string, IAbpNameValuePair[]>;
        languageFilesMap: Record<string, IAbpNameValuePair[]>;
    };

    /* AUTHORIZATION **********************************************/
    auth: {
        grantedPolicies: Record<string, boolean>;
    };

    /* SETTINGS *************************************************/
    setting: {
        values: Record<string, string>;
    };

    /* CURRENT USER **********************************************/
    currentUser: ICurrentUser;

    /* FEATURES *************************************************/
    features: {
        values: Record<string, string>;
    };

    /* GLOBAL FEATURES *************************************************/
    globalFeatures: {
        enabledFeatures: string[];
    };

    /* MULTI TENANCY *************************************************/
    multiTenancy: {
        isEnabled: boolean;
    };

    /* CURRENT TENANT *************************************************/
    currentTenant: ICurrentTenant;

    /* TIMING *************************************************/
    timing: {
        timeZone: IAbpTimezone;
    };

    /* CLOCK *****************************************/
    clock: {
        kind: string;
    };

    /* OBJECT EXTENSIONS *************************************************/
    objectExtensions: {
        modules: Record<string, any>;
        enums: Record<string, any>;
    };

    /* EXTRA PROPERTIES *************************************************/
    extraProperties: Record<string, any>;

    menu: INavigationMenuDto[];
}

export interface INavigationMenuDto {
  id: string;
  parentId?: string;
  title: string;
  icon?: string | null;
  path: string | null;
  isExternal: boolean;
  sort: number;
}

// 权限相关类型定义
export interface IPermissionInfo {
    name: string;
    displayName?: string;
    parentName?: string;
    isGranted: boolean;
}

export interface IPermissionGroup {
    name: string;
    displayName?: string;
    permissions: IPermissionInfo[];
}