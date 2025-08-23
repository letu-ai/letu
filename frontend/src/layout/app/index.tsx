import { useOutlet } from 'react-router-dom';
import Sidebar from '@/layout/components/Sidebar';
import Navbar from '../components/Navbar';
import Tab from '@/layout/components/Tab';
import { FloatButton, Layout } from 'antd';
import { useMediaQuery } from 'react-responsive';
import ErrorFallback from '@/components/ErrorFallback';
import { ErrorBoundary } from 'react-error-boundary';
import { useEffect } from 'react';
import Authorize from '@/components/Authorize';
import useLayoutStore from '@/application/layoutStore';
import Application from '@/components/Application';
import httpClient from '@/utils/httpClient';
import { App } from 'antd';
import ResponseErrorMessage from '@/utils/ResponseErrorMessage';
import { StaticRoutes } from '@/utils/globalValue';

const { Content, Sider } = Layout;


function Index() {
    const curOutlet = useOutlet();
    const collapsed = useLayoutStore(state => state.collapsed);
    const toggleCollapsed = useLayoutStore(state => state.toggleCollapsed);
    const isMinScreen = useMediaQuery({ maxWidth: '768px' });
    const { message } = App.useApp();

    useEffect(() => {
        const needToggleCollapsed = (isMinScreen && !collapsed) || (!isMinScreen && collapsed);
        if (needToggleCollapsed) {
            toggleCollapsed();
        }
    }, [isMinScreen, collapsed, toggleCollapsed]);

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
        <Authorize>
            <Application app="app">
                <Layout hasSider className="letu-layout">
                    <Sider trigger={null} collapsible collapsed={collapsed}>
                        <Sidebar />
                    </Sider>
                    <Layout>
                        <Navbar />
                        <ErrorBoundary FallbackComponent={ErrorFallback}>
                            <Content>{curOutlet}</Content>
                        </ErrorBoundary>
                        <FloatButton.BackTop />
                    </Layout>
                </Layout>
            </Application>
        </Authorize>
    );
}

export default Index;
