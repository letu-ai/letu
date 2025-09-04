import zhCN from 'antd/locale/zh_CN';
import { ConfigProvider, theme } from 'antd';
import { useMemo } from 'react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import useThemeStore from '@/application/themeStore';
import useLayoutStore from '@/application/layoutStore';
import { App as AntApp } from 'antd';
import { useEffect } from 'react';
import httpClient from './utils/httpClient';
import ResponseErrorMessage from './utils/ResponseErrorMessage';
import { StaticRoutes } from './utils/globalValue';
import { StyleProvider } from '@ant-design/cssinjs';

interface IAppProps {
    children: React.ReactNode;
}

// 创建 QueryClient 实例（管理缓存和请求）
const queryClient = new QueryClient();

const App = ({ children }: IAppProps) => {
    const themeConfig = useThemeStore(state => state.theme);
    const size = useLayoutStore(state => state.size);

    return (
        <StyleProvider layer>
            <ConfigProvider locale={zhCN} componentSize={size} theme={themeConfig}>
                <QueryClientProvider client={queryClient}>
                    <AntApp>
                        <InnerApp>{children}</InnerApp>
                    </AntApp>
                </QueryClientProvider>
            </ConfigProvider >
        </StyleProvider>
    )
}

const { useToken } = theme;

function InnerApp({ children }: IAppProps) {
    const { token } = useToken();
    const appStyle = useMemo(() => ({
        '--color-primary': token.colorPrimary,
        "--color-primary-bg": token.colorPrimaryBg,
        "--color-primary-bg-hover": token.colorPrimaryBgHover,
        "--color-primary-border": token.colorPrimaryBorder,
        "--color-primary-border-hover": token.colorPrimaryBorderHover,
        "--color-primary-hover": token.colorPrimaryHover,
        "--color-primary-active": token.colorPrimaryActive,
        "--color-primary-text": token.colorPrimaryText,
        "--color-primary-text-hover": token.colorPrimaryTextHover,
        "--color-primary-text-active": token.colorPrimaryTextActive,

        "--color-link": token.colorLink,
        "--color-link-hover": token.colorLinkHover,
        "--color-link-active": token.colorLinkActive,

        "--color-success": token.colorSuccess,
        "--color-warning": token.colorWarning,
        "--color-error": token.colorError,
        "--color-background": token.colorBgBase,
        "--color-text": token.colorText,
        "--color-text-secondary": token.colorTextSecondary,
        "--color-text-muted": token.colorTextTertiary,
        "--color-text-disabled": token.colorTextQuaternary,

        '--color-error-bg': token.colorErrorBg,
        '--color-error-bg-hover': token.colorErrorBgHover,
        '--color-error-border': token.colorErrorBorder,
        '--color-error-border-hover': token.colorErrorBorderHover,
        '--color-error-hover': token.colorErrorHover,
        '--color-error-active': token.colorErrorActive,
        '--color-error-text-hover': token.colorErrorTextHover,
        '--color-error-text': token.colorErrorText,
        '--color-error-text-active': token.colorErrorTextActive,
    } as React.CSSProperties), [token]);
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
