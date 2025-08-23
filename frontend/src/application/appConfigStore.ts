import { create } from 'zustand';
import type {
    ILetuApplicationConfiguration,
    ICurrentUser,
    ICurrentTenant,
    INavigationMenuDto
} from './types';
import httpClient from '@/utils/httpClient';

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

// Config Store 接口
export interface IConfigStore {
    // 状态属性
    isLoading: boolean;
    isReady: boolean;
    error: Error | null;
    currentUser: ICurrentUser;
    currentTenant: ICurrentTenant;
    menu: INavigationMenuDto[];

    // Actions
    loadConfiguration: (appName?: string) => Promise<void>;
    // reloadConfiguration: () => Promise<void>;
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

// 创建 ABP Store
export const useAppConfigStore = create<IConfigStore>((set, get) => {
    let _config: ILetuApplicationConfiguration | null = null;
    let _lastAppName: string | undefined;

    const _loadConfiguration = async (appName?: string) => {
        const { isLoading, isReady } = get();

        // 防重复调用：如果已经准备完成或正在加载中，直接返回
        if (isLoading) {
            return;
        }

        if (isReady && _lastAppName === appName) {
            return; // 已经准备完成且应用名称相同，直接返回
        }

        set({ isLoading: true, error: null });

        try {
            const config = await httpClient.get<void, ILetuApplicationConfiguration>('/api/application/configuration', {
                params: {
                    includeLocalizationResources: false,
                    applicationName: appName
                }
            });

            set({
                isLoading: false,
                isReady: true,
                error: null,
                currentUser: config.currentUser,
                currentTenant: config.currentTenant,
                menu: config.menu
            });

            _config = config;
            _lastAppName = appName; // 记录最后一次加载的应用名称
        }
        catch (error) {
            set({
                isLoading: false,
                isReady: false,
                error: error as Error
            });
            console.error('加载ABP配置失败:', error);
        }
    }

    return {
        // 初始状态
        isLoading: false,
        isReady: false,
        error: null,
        currentUser: DEFAULT_VALUES.currentUser,
        currentTenant: DEFAULT_VALUES.currentTenant,
        menu: DEFAULT_VALUES.menu,

        // 加载配置 - 自动防重复调用
        loadConfiguration: async (appName?: string) => {
            await _loadConfiguration(appName);
        },

        // 清理配置 - 用于注销时清理状态
        clearConfiguration: () => {
            _config = null
            set({
                isLoading: false,
                isReady: false,
                error: null,
                currentUser: DEFAULT_VALUES.currentUser,
                currentTenant: DEFAULT_VALUES.currentTenant,
                menu: DEFAULT_VALUES.menu
            });
        },

        // 权限
        isGranted: (policyName?: string) => {
            if (!policyName)
                return true;
            // 如果配置未加载，出于安全考虑返回 false
            if (!_config)
                return false;

            return _config.auth.grantedPolicies[policyName] !== undefined;
        },

        isAnyGranted: (...args: string[]) => {
            if (!args || args.length <= 0)
                return true;

            if (_config == null)
                return false;

            return args.some(policy => _config!.auth.grantedPolicies[policy] !== undefined);
        },

        areAllGranted: (...args: string[]) => {
            if (!args || args.length <= 0)
                return true;

            if (!_config)
                return false;

            return args.every(policy => _config!.auth.grantedPolicies[policy] !== undefined);
        },

        // 设置
        getSetting: (name: string) => {
            return _config?.setting.values[name];
        },

        getSettingBoolean: (name: string) => {
            const value = _config?.setting.values[name];
            return value === 'true' || value === 'True';
        },

        getSettingInt: (name: string) => {
            const value = _config?.setting.values[name];
            return value ? parseInt(value) : 0;
        },

        // 时钟
        getClockKind: () => {
            return _config?.clock.kind || DEFAULT_VALUES.clockKind;
        },

        supportsMultipleTimezone: () => {
            const clockKind = _config?.clock.kind || DEFAULT_VALUES.clockKind;
            return clockKind === 'Utc';
        },

        // 功能特性
        isFeatureEnabled: (name: string) => {
            const value = _config?.features.values[name];
            return value === 'true' || value === 'True';
        },

        getFeature: (name: string) => {
            return _config?.features.values[name];
        },

        // 全局功能特性
        getEnabledFeatures: () => {
            return _config?.globalFeatures.enabledFeatures || [];
        },

        isGlobalFeatureEnabled: (name: string) => {
            const enabledFeatures = _config?.globalFeatures.enabledFeatures || [];
            return enabledFeatures.includes(name);
        },

        // 多租户
        isMultiTenancyEnabled: () => {
            return _config?.multiTenancy.isEnabled || false;
        }
    }
});


// 导出主要的 Config Store
export default useAppConfigStore;