import { useRoutes } from 'react-router-dom';
import { routes } from '@/router';
import zhCN from 'antd/locale/zh_CN';
import { ConfigProvider, Spin } from 'antd';
import { Suspense, useMemo } from 'react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import useThemeStore from '@/application/themeStore';
import useLayoutStore from '@/application/layoutStore';
import { App as AntApp } from 'antd';


const fallback = (
    <div
        style={{
            display: 'flex',
            justifyContent: 'center',
            alignItems: 'center',
            height: '100vh',
        }}
    >
        <Spin />
    </div>
);

const ThemedApp = () => {
    const themeConfig = useThemeStore(state => state.theme);
    const size = useLayoutStore(state => state.size);

    return (
        <ConfigProvider locale={zhCN} componentSize={size} theme={themeConfig}>
            <App />
        </ConfigProvider>
    )
}

function App() {
    const themeConfig = useThemeStore(state => state.theme);
    const appStyle = useMemo(() => ({
        '--color-primary': themeConfig.token?.colorPrimary,
        "--color-link": themeConfig.token?.colorLink,
        "--color-success": themeConfig.token?.colorSuccess,
        "--color-warning": themeConfig.token?.colorWarning,
        "--color-error": themeConfig.token?.colorError,
        "--color-background": themeConfig.token?.colorBgBase,
        "--color-text": themeConfig.token?.colorText,
    } as React.CSSProperties), [themeConfig]);


    // 创建 QueryClient 实例（管理缓存和请求）
    const queryClient = new QueryClient();

    return (
        <div style={appStyle}>
            <QueryClientProvider client={queryClient}>
                <AntApp>
                    <Suspense fallback={fallback}>
                        {useRoutes(routes)}
                    </Suspense>
                </AntApp>
            </QueryClientProvider>
        </div>
    );
}

export default ThemedApp;
