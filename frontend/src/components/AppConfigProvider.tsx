import { createContext, useContext, useMemo, useState, type ReactNode, useEffect } from 'react'
import type {
    ILetuApplicationConfiguration,
    ICurrentUser,
    ICurrentTenant,
    INavigationMenuDto,
    IUserExtraInfo
} from '@/application/types'
import httpClient from '@/utils/httpClient';
import useThemeStore from '@/application/themeStore';

interface IAppConfigProviderProps {
    config: ILetuApplicationConfiguration
    children: ReactNode
}

// 默认值
const DEFAULT_VALUES = {
    clockKind: 'Unspecified',
    currentUser: {
        isAuthenticated: false,
        id: null,
        tenantId: null,
        impersonatorUserId: null,
        impersonatorTenantId: null,
        impersonatorUserName: null,
        impersonatorTenantName: null,
        userName: null,
        name: null,
        surName: null,
        email: null,
        emailVerified: false,
        phoneNumber: null,
        phoneNumberVerified: false,
        roles: [],
        sessionId: null
    } as ICurrentUser,
    currentTenant: {
        id: null,
        name: null,
        isAvailable: false
    } as ICurrentTenant,
    menu: []
};

// Context 接口定义
interface IAppConfigContext {
    // 状态
    isReady: boolean;
    currentUser: ICurrentUser;
    userExtraInfo: IUserExtraInfo;
    currentTenant: ICurrentTenant;
    menu: INavigationMenuDto[];

    // 配置管理
    setConfiguration: (config: ILetuApplicationConfiguration) => void;
    clearConfiguration: () => void;

    // 权限
    isGranted: (policyName?: string) => boolean;
    isAnyGranted: (...args: string[]) => boolean;
    areAllGranted: (...args: string[]) => boolean;

    // 设置
    getSetting: (name: string) => string | undefined;
    getSettingBoolean: (name: string) => boolean;
    getSettingInt: (name: string) => number;

    // 时钟
    getClockKind: () => string;
    supportsMultipleTimezone: () => boolean;

    // 功能特性
    isFeatureEnabled: (name: string) => boolean;
    getFeature: (name: string) => string | undefined;

    // 全局功能特性
    getEnabledFeatures: () => string[];
    isGlobalFeatureEnabled: (name: string) => boolean;

    // 多租户
    isMultiTenancyEnabled: () => boolean;
}

const AppConfigContext = createContext<IAppConfigContext | null>(null)

export function AppConfigProvider({ config, children }: IAppConfigProviderProps) {
    const [configuration, setConfiguration] = useState<ILetuApplicationConfiguration | null>(config)
    const [isReady, setIsReady] = useState(!!config)
    const { setThemeColor } = useThemeStore()
    
    // 主题初始化逻辑
    useEffect(() => {
        if (!isReady || !configuration) return;

        // 尝试多种可能的配置键获取站点主色调
        const primaryColor = configuration?.setting?.values?.['Letu.Application.Site.PrimaryColor'];
        
        if (primaryColor && primaryColor !== '#7E57C2') {
            // 只有当颜色值存在且不是默认值时才更新主题
            setThemeColor(primaryColor);
        }
    }, [isReady, configuration, setThemeColor]);
    
    const contextValue = useMemo<IAppConfigContext>(() => {
        return {
            // 状态
            isReady,
            currentUser: configuration?.currentUser || DEFAULT_VALUES.currentUser,
            userExtraInfo: configuration?.userExtraInfo || {},
            currentTenant: configuration?.currentTenant || DEFAULT_VALUES.currentTenant,
            menu: configuration?.menu || DEFAULT_VALUES.menu,

            // 配置管理
            setConfiguration: (config: ILetuApplicationConfiguration) => {
                setConfiguration(config)
                setIsReady(true)
            },

            clearConfiguration: () => {
                setConfiguration(null)
                setIsReady(false)
            },

            // 权限
            isGranted: (policyName?: string) => {
                if (!policyName) return true
                if (!configuration) return false
                return configuration.auth.grantedPolicies[policyName] !== undefined
            },

            isAnyGranted: (...args: string[]) => {
                if (!args || args.length <= 0) return true
                if (!configuration) return false
                return args.some(policy => configuration.auth.grantedPolicies[policy] !== undefined)
            },

            areAllGranted: (...args: string[]) => {
                if (!args || args.length <= 0) return true
                if (!configuration) return false
                return args.every(policy => configuration.auth.grantedPolicies[policy] !== undefined)
            },

            // 设置
            getSetting: (name: string) => {
                return configuration?.setting.values[name]
            },

            getSettingBoolean: (name: string) => {
                const value = configuration?.setting.values[name]
                return value === 'true' || value === 'True'
            },

            getSettingInt: (name: string) => {
                const value = configuration?.setting.values[name]
                return value ? parseInt(value) : 0
            },

            // 时钟
            getClockKind: () => {
                return configuration?.clock.kind || DEFAULT_VALUES.clockKind
            },

            supportsMultipleTimezone: () => {
                const clockKind = configuration?.clock.kind || DEFAULT_VALUES.clockKind
                return clockKind === 'Utc'
            },

            // 功能特性
            isFeatureEnabled: (name: string) => {
                const value = configuration?.features.values[name]
                return value === 'true' || value === 'True'
            },

            getFeature: (name: string) => {
                return configuration?.features.values[name]
            },

            // 全局功能特性
            getEnabledFeatures: () => {
                return configuration?.globalFeatures.enabledFeatures || []
            },

            isGlobalFeatureEnabled: (name: string) => {
                const enabledFeatures = configuration?.globalFeatures.enabledFeatures || []
                return enabledFeatures.includes(name)
            },

            // 多租户
            isMultiTenancyEnabled: () => {
                return configuration?.multiTenancy.isEnabled || false
            }
        }
    }, [configuration, isReady])
    
    return (
        <AppConfigContext.Provider value={contextValue}>
            {children}
        </AppConfigContext.Provider>
    )
}

export function useAppConfig() {
    const context = useContext(AppConfigContext)
    if (!context) {
        throw new Error('useAppConfig must be used within a AppConfigProvider')
    }
    return context
}


export async function loadConfiguration(appName?: string) {
    const config = await httpClient.get<void, ILetuApplicationConfiguration>('/api/application/configuration', {
        params: {
            includeLocalizationResources: false,
            applicationName: appName ?? null
        }
    });
    return config;
}
