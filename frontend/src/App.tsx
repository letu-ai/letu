import { useRoutes } from 'react-router-dom';
import { routes } from '@/router';
import zhCN from 'antd/locale/zh_CN';
import { ConfigProvider, Spin } from 'antd';
import { Suspense, useMemo } from 'react';
import { AuthProvider } from '@/components/AuthProvider';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import Application from '@/components/Application';
import useThemeStore from '@/store/themeStore';
import useLayoutStore from '@/store/layoutStore';


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
    }), [themeConfig]);


    // 创建 QueryClient 实例（管理缓存和请求）
    const queryClient = new QueryClient();

    return (
        <>
            <AuthProvider>
                <div style={appStyle}>
                    <Application>
                        <QueryClientProvider client={queryClient}>
                            {/* 使用固定的基础路由结构，避免Hook调用数量变化 */}
                            <Suspense fallback={fallback}>
                                {useRoutes(routes)}
                            </Suspense>
                        </QueryClientProvider>
                    </Application>
                </div>
            </AuthProvider>
        </>
    );
}

export default ThemedApp;
