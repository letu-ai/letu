import zhCN from 'antd/locale/zh_CN';
import { ConfigProvider } from 'antd';
import { useMemo } from 'react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import useThemeStore from '@/application/themeStore';
import useLayoutStore from '@/application/layoutStore';
import { App as AntApp } from 'antd';
import { useEffect } from 'react';
import httpClient from './utils/httpClient';
import ResponseErrorMessage from './utils/ResponseErrorMessage';
import { StaticRoutes } from './utils/globalValue';

interface IAppProps {
    children: React.ReactNode;
}

// 创建 QueryClient 实例（管理缓存和请求）
const queryClient = new QueryClient();

const App = ({ children }: IAppProps) => {
    const themeConfig = useThemeStore(state => state.theme);
    const size = useLayoutStore(state => state.size);

    return (
        <ConfigProvider locale={zhCN} componentSize={size} theme={themeConfig}>
            <QueryClientProvider client={queryClient}>
                <AntApp>
                    <InnerApp>{children}</InnerApp>
                </AntApp>
            </QueryClientProvider>
        </ConfigProvider >
    )
}


function InnerApp({ children }: IAppProps) {
    const themeConfig = useThemeStore(state => state.theme);
    const appStyle = useMemo(() => ({
        '--color-primary': themeConfig.token?.colorPrimary,
        "--color-link": themeConfig.token?.colorLink,
        "--color-success": themeConfig.token?.colorSuccess,
        "--color-warning": themeConfig.token?.colorWarning,
        "--color-error": themeConfig.token?.colorError,
        "--color-background": themeConfig.token?.colorBgBase,
        "--color-text": themeConfig.token?.colorText,
        '--color-error-bg': themeConfig.token?.colorErrorBg,
        '--color-error-bg-hover': themeConfig.token?.colorErrorBgHover,  
        '--color-error-border': themeConfig.token?.colorErrorBorder,
        '--color-error-border-hover': themeConfig.token?.colorErrorBorderHover,
        '--color-error-hover': themeConfig.token?.colorErrorHover,
        '--color-error-active': themeConfig.token?.colorErrorActive,
        '--color-error-text-hover': themeConfig.token?.colorErrorTextHover,
        '--color-error-text': themeConfig.token?.colorErrorText,
        '--color-error-text-active': themeConfig.token?.colorErrorTextActive,
    } as React.CSSProperties), [themeConfig]);
    const { message } = AntApp.useApp();
    useEffect(() => {
        httpClient.setErrorHandler((errorInfo) => {
            message.error(<ResponseErrorMessage error={errorInfo} />, 3, () => {
                if (errorInfo.jumpLogin && window.location.pathname !== StaticRoutes.login) {
                    window.location.href = StaticRoutes.logout; //去注销登页面清除登录信息
                }
            });
        });
    }, [message]);

    return (
        <div style={appStyle}>
            {children}
        </div>
    );
}

export default App;
