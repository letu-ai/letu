import { Outlet } from 'react-router-dom';
import ErrorFallback from '@/components/ErrorFallback';
import { ErrorBoundary } from 'react-error-boundary';
import { useEffect } from 'react';
import { useConfigStore } from '@/application/configStore.tsx';
import { Layout } from 'antd';

function Index() {
    const loadConfiguration = useConfigStore((state) => state.loadConfiguration);

    useEffect(() => {
        // 直接使用 loadConfiguration，已内置防重复调用逻辑
        loadConfiguration()
            .then(() => {
                console.log('配置加载完成');
            })
            .catch((error) => {
                console.error('加载配置失败:', error);
            });
    }, [loadConfiguration]);

    return (
        <ErrorBoundary FallbackComponent={ErrorFallback}>
            <Layout.Content>
                <Outlet />
            </Layout.Content>
        </ErrorBoundary>
    );
}

export default Index;
