import { create } from 'zustand';
import type {
    IAbpConfiguration,
    ICurrentUser,
    ICurrentTenant
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
    } as ICurrentTenant
};

// Config Store 接口
interface IConfigStore {
    // 状态属性
    config: IAbpConfiguration | null;
    isLoadingState: boolean;
    isReadyState: boolean;
    error: Error | null;

    // Actions
    loadConfiguration: () => Promise<void>;

    isReady: () => boolean;
    isLoading: () => boolean;
    hasError: () => boolean;
    getError: () => Error | null;

    // 基础属性 getters
    getCurrentUser: () => ICurrentUser;
    getCurrentTenant: () => ICurrentTenant;

    // 本地化
    localize: (key: string, sourceName?: string, ...args: string[]) => string;
    isLocalized: (key: string, sourceName?: string) => boolean;

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
    nowDate: () => Date;

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
export const useConfigStore = create<IConfigStore>((set, get) => ({
    // 初始状态
    config: null,
    isLoadingState: false,
    isReadyState: false,
    error: null,

    // 加载配置 - 自动防重复调用
    loadConfiguration: async () => {
        const currentState = get();
        
        // 防重复调用：如果已经准备完成或正在加载中，直接返回
        if (currentState.isReadyState || currentState.isLoadingState) {
            return;
        }

        set({ isLoadingState: true, error: null });

        try {
            const config = await httpClient.get<IAbpConfiguration>('/api/abp/application-configuration', {
                params: {
                    includeLocalizationResources: false
                }
            });
            set({
                config,
                isLoadingState: false,
                isReadyState: true,
                error: null
            });
            console.log('ABP配置加载完成:', config);
        } catch (error) {
            set({
                isLoadingState: false,
                isReadyState: false,
                error: error as Error
            });
            console.error('加载ABP配置失败:', error);
        }
    },

    // 状态查询
    isReady: () => get().isReadyState,
    isLoading: () => get().isLoadingState,
    hasError: () => get().error !== null,
    getError: () => get().error,

    // 基础属性 getters
    getCurrentUser: () => {
        const { config } = get();
        return config?.currentUser || DEFAULT_VALUES.currentUser;
    },

    getCurrentTenant: () => {
        const { config } = get();
        return config?.currentTenant || DEFAULT_VALUES.currentTenant;
    },

    // 本地化
    localize: (key: string, sourceName?: string, ...args: string[]) => {
        const { config } = get();

        if (sourceName === '_') return key;
        if (!config) return key;

        const resourceName = sourceName || config.localization.defaultResourceName;
        if (!resourceName) {
            console.warn('Localization source name is not specified and the defaultResourceName was not defined!');
            return key;
        }

        // 获取资源
        const resource = config.localization.resources[resourceName] ||
            (config.localization.values[resourceName] ? {
                texts: config.localization.values[resourceName],
                baseResources: []
            } : null);

        if (!resource) {
            console.warn('Could not find localization source: ' + resourceName);
            return key;
        }

        // 获取文本值
        let value = resource.texts[key];
        if (value === undefined) {
            // 尝试从基础资源中查找
            for (const baseResource of resource.baseResources) {
                const baseResourceObj = config.localization.resources[baseResource];
                if (baseResourceObj && baseResourceObj.texts[key]) {
                    value = baseResourceObj.texts[key];
                    break;
                }
            }
        }

        if (value === undefined) {
            return key;
        }

        // 简单的字符串格式化 - 替换 {0}, {1} 等占位符
        if (args && args.length > 0) {
            return args.reduce((result, arg, index) => {
                return result.replace(new RegExp(`\\{${index}\\}`, 'g'), arg);
            }, value);
        }
        return value;
    },

    isLocalized: (key: string, sourceName?: string) => {
        const { config } = get();

        if (sourceName === '_') return true;
        if (!config) return false;

        const resourceName = sourceName || config.localization.defaultResourceName || "";
        if (!resourceName) return false;

        const resource = config.localization.resources[resourceName] ||
            (config.localization.values[resourceName] ? {
                texts: config.localization.values[resourceName],
                baseResources: []
            } : null);

        return resource !== null && resource.texts[key] !== undefined;
    },

    // 权限
    isGranted: (policyName?: string) => {
        if (!policyName) return true;

        const { config } = get();
        // 如果配置未加载，出于安全考虑返回 false
        if (!config) return false;

        return config.auth.grantedPolicies[policyName] !== undefined;
    },

    isAnyGranted: (...args: string[]) => {
        if (!args || args.length <= 0) return true;
        return args.some(policy => get().isGranted(policy));
    },

    areAllGranted: (...args: string[]) => {
        if (!args || args.length <= 0) return true;
        return args.every(policy => get().isGranted(policy));
    },

    // 设置
    getSetting: (name: string) => {
        const { config } = get();
        return config?.setting.values[name];
    },

    getSettingBoolean: (name: string) => {
        const value = get().getSetting(name);
        return value === 'true' || value === 'True';
    },

    getSettingInt: (name: string) => {
        const value = get().getSetting(name);
        return value ? parseInt(value) : 0;
    },

    // 时钟
    getClockKind: () => {
        const { config } = get();
        return config?.clock.kind || DEFAULT_VALUES.clockKind;
    },

    supportsMultipleTimezone: () => {
        return get().getClockKind() === 'Utc';
    },

    nowDate: () => {
        return new Date();
    },

    // 功能特性
    isFeatureEnabled: (name: string) => {
        const value = get().getFeature(name);
        return value === 'true' || value === 'True';
    },

    getFeature: (name: string) => {
        const { config } = get();
        return config?.features.values[name];
    },

    // 全局功能特性
    getEnabledFeatures: () => {
        const { config } = get();
        return config?.globalFeatures.enabledFeatures || [];
    },

    isGlobalFeatureEnabled: (name: string) => {
        return get().getEnabledFeatures().includes(name);
    },

    // 多租户
    isMultiTenancyEnabled: () => {
        const { config } = get();
        return config?.multiTenancy.isEnabled || false;
    }
}));


// 导出主要的 Config Store
export default useConfigStore;