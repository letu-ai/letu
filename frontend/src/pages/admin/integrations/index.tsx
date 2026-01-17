import { SettingOutlined } from '@ant-design/icons'
import { createFileRoute } from '@tanstack/react-router'
import { useState } from 'react'
import { App } from 'antd'
import AmapSettingsForm, { type IAmapSettings } from './-components/AmapSettingForm'
import RagFlowSettingsForm, { type IRagFlowSettings } from './-components/RagFlowSettingForm'
import FastgptSettingsForm, { type IFastgptSettings } from './-components/FastgptSettingForm'
import AliyunPushSettingForm, { type IAliyunPushSettings } from './-components/AliyunPushSettingForm'
import IntegrationCard from './-components/IntegrationCard'
import { fetchSettingValues, getIntegrationsStatus, setIntegrationEnableStatus, updateSettingValues } from './-service'
import { useAsyncEffect } from 'ahooks'

export const Route = createFileRoute('/admin/integrations/')({
    component: IntegrationSettings,
})

interface IntegrationState {
    show: boolean;
    loading: boolean;
    saving: boolean;
    isError: boolean;
}


function IntegrationSettings() {
    const { message } = App.useApp();
    const [integrations, setIntegrations] = useState<Record<string, IntegrationState>>({
        "amap": { loading: false, saving: false, isError: false, show: false },
        "ragflow": { loading: false, saving: false, isError: false, show: false },
        "fastgpt": { loading: false, saving: false, isError: false, show: false },
        "aliyun-push": { loading: false, saving: false, isError: false, show: false }
    });
    const [enableStatus, setEnableStatus] = useState<Record<string, boolean>>({});

    useAsyncEffect(async () => {
        const status = await getIntegrationsStatus();
        setEnableStatus(status.reduce((acc, item) => {
            acc[item.name] = item.isEnabled;
            return acc;
        }, {} as Record<string, boolean>));
    }, []);

    // 获取各服务的状态
    const amapState = integrations['amap'];
    const ragflowState = integrations['ragflow'];
    const fastgptState = integrations['fastgpt'];
    const aliyunPushState = integrations['aliyun-push'];
    // 处理展开事件
    const handleExpand = async (serviceName: string) => {
        updateState(serviceName, { show: true });
    };

    const updateState = (serviceName: string, state: Partial<IntegrationState>) => {
        setIntegrations(prev => ({ ...prev, [serviceName]: { ...prev[serviceName], ...state } }));
    };

    // 处理启用/禁用切换
    const handleEnableChange = async (serviceName: string, enabled: boolean) => {
        try {
            await setIntegrationEnableStatus(serviceName, enabled);
            setEnableStatus(prev => ({ ...prev, [serviceName]: enabled }));
            message.success(enabled ? '服务已启用' : '服务已禁用');
        } catch {
            message.error('操作失败，请稍后重试');
        }
    };

    async function handleRequest<T>(serviceName: string) {
        try {
            updateState(serviceName, { loading: true });
            return await fetchSettingValues<T>(serviceName);
        } catch {
            updateState(serviceName, { isError: true });
            message.error('获取配置失败');
        } finally {
            updateState(serviceName, { loading: false });
        }
    }

    // 处理保存事件
    async function handleSave(serviceName: string, config: any) {
        try {
            updateState(serviceName, { saving: true });
            await updateSettingValues(serviceName, config);
            message.success('配置保存成功');
        } catch {
            message.error('保存配置失败，请稍后重试');
            updateState(serviceName, { isError: true });
        }
        finally {
            updateState(serviceName, { saving: false });
        }
    }

    return (
        <div className="container mx-auto py-8 px-4 max-w-4xl">
            <div className="mb-8">
                <div className="flex items-center gap-3 mb-2">
                    <SettingOutlined className="text-3xl" />
                    <h1 className="mb-0 text-3xl font-bold text-foreground">集成设置</h1>
                </div>
                <p className="text-muted-foreground text-lg">管理您的第三方服务集成，配置 API 密钥和连接参数</p>
            </div>

            <div className="space-y-6">
                {/* 地图服务 */}
                <div className="space-y-4">
                    <h2 className="text-xl font-semibold">地图服务</h2>
                    <IntegrationCard
                        icon={<img title="高德地图" src="/images/logos/amap.png" className="w-24" />}
                        title="高德地图"
                        description="管理您的地图服务集成，配置 API 密钥"
                        enabled={enableStatus['amap'] || false}
                        onExpand={() => handleExpand('amap')}
                        onEnableChange={(enabled) => handleEnableChange('amap', enabled)}
                    >
                        <AmapSettingsForm
                            loading={amapState.loading}
                            saving={amapState.saving}
                            isError={amapState.isError}
                            onRequest={async () => {
                                return await handleRequest<IAmapSettings>('amap');
                            }}
                            onSave={(config) => handleSave('amap', config)}
                        />
                    </IntegrationCard>
                </div>

                {/* RagFlow */}
                <div className="space-y-4">
                    <h2 className="text-xl font-semibold">AI 服务</h2>
                    <IntegrationCard
                        icon={<img title="RagFlow" src="/images/logos/ragflow.png" className="w-24" />}
                        title="RagFlow"
                        description="管理RagFlow AI服务集成"
                        enabled={enableStatus['ragflow'] || false}
                        onExpand={() => handleExpand('ragflow')}
                        onEnableChange={(enabled) => handleEnableChange('ragflow', enabled)}
                    >
                        <RagFlowSettingsForm
                            loading={ragflowState.loading}
                            saving={ragflowState.saving}
                            isError={ragflowState.isError}
                            onRequest={async () => {
                                return await handleRequest<IRagFlowSettings>('ragflow');
                            }}
                            onSave={(config) => handleSave('ragflow', config)}
                        />
                    </IntegrationCard>

                    <IntegrationCard
                        icon={<img title="FastGPT" src="/images/logos/fastgpt.svg" className="w-24" />}
                        title="FastGPT"
                        description="管理FastGPT AI服务集成"
                        enabled={enableStatus['fastgpt'] || false}
                        onExpand={() => handleExpand('fastgpt')}
                        onEnableChange={(enabled) => handleEnableChange('fastgpt', enabled)}
                    >
                        <FastgptSettingsForm
                            loading={fastgptState.loading}
                            saving={fastgptState.saving}
                            isError={fastgptState.isError}
                            onRequest={async () => {
                                return await handleRequest<IFastgptSettings>('fastgpt');
                            }}
                            onSave={(config) => handleSave('fastgpt', config)}
                        />
                    </IntegrationCard>
                </div>

                {/* 推送服务 */}
                <div className="space-y-4">
                    <h2 className="text-xl font-semibold">推送服务</h2>
                    <IntegrationCard
                        icon={<img title="阿里云移动推送" src="/images/logos/aliyun_emas.svg" className="w-24" />}
                        title="阿里云移动推送"
                        description="管理阿里云移动推送服务集成，配置推送相关参数"
                        enabled={enableStatus['aliyun-push'] || false}
                        onExpand={() => handleExpand('aliyun-push')}
                        onEnableChange={(enabled) => handleEnableChange('aliyun-push', enabled)}
                    >
                        <AliyunPushSettingForm
                            loading={aliyunPushState.loading}
                            saving={aliyunPushState.saving}
                            isError={aliyunPushState.isError}
                            onRequest={async () => {
                                return await handleRequest<IAliyunPushSettings>('aliyun-push');
                            }}
                            onSave={(config) => handleSave('aliyun-push', config)}
                        />
                    </IntegrationCard>
                </div>

                {/* 可以在这里添加更多服务分类 */}
                {/*
                <div className="space-y-4">
                    <h2 className="text-xl font-semibold">支付服务</h2>
                    <AlipaySettings />
                    <WechatPaySettings />
                </div>

                <div className="space-y-4">
                    <h2 className="text-xl font-semibold">短信服务</h2>
                    <AliyunSmsSettings />
                </div>
                */}
            </div>

            <div className="mt-8 p-4 bg-gray-50 rounded-lg">
                <p className="text-sm text-gray-600">
                    💡 提示：所有敏感信息（如 API 密钥）都会被安全加密存储。如需帮助配置集成，请查看相关文档或联系技术支持。
                </p>
            </div>
        </div>
    )
}
