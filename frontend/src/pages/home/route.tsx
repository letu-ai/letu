import { createFileRoute } from '@tanstack/react-router';
import { requireAuth } from '@/utils/authUtils'

import { Outlet } from '@tanstack/react-router';
import Sidebar from '@/components/layout/Sidebar';
import { FloatButton, Layout } from 'antd';
import { useMediaQuery } from 'react-responsive';
import ErrorFallback from '@/components/ErrorFallback';
import { ErrorBoundary } from 'react-error-boundary';
import { useEffect } from 'react';
import useLayoutStore from '@/application/layoutStore';
import { AppConfigProvider, loadConfiguration } from '@/components/AppConfigProvider';
import Navbar from '@/components/layout/Navbar';
import RouteErrorComponent from '@/components/RouteErrorComponent';

export const Route = createFileRoute('/home')({
    component: AppLayout,
    beforeLoad: async ({ location }) => {
        requireAuth(location);
    },
    loader: async () => {
        const config = await loadConfiguration("app")
        return {
            config
        }
    },
    staleTime: 1000 * 60 * 30, // 30分钟过期
    errorComponent: RouteErrorComponent,
})


const { Content, Sider } = Layout;


function AppLayout() {
    const { config } = Route.useLoaderData()

    const collapsed = useLayoutStore(state => state.collapsed);
    const toggleCollapsed = useLayoutStore(state => state.toggleCollapsed);
    const isMinScreen = useMediaQuery({ maxWidth: '768px' });

    useEffect(() => {
        const needToggleCollapsed = (isMinScreen && !collapsed) || (!isMinScreen && collapsed);
        if (needToggleCollapsed) {
            toggleCollapsed();
        }
    }, [isMinScreen, collapsed, toggleCollapsed]);


    return (
        <AppConfigProvider config={config}>
            <Layout hasSider>
                <Sider trigger={null} collapsible collapsed={collapsed}>
                    <Sidebar />
                </Sider>
                <Layout>
                    <Navbar />
                    <ErrorBoundary FallbackComponent={ErrorFallback}>
                        <Content className=' p-4 bg-gray-100'>
                            <Outlet />
                        </Content>
                    </ErrorBoundary>
                    <FloatButton.BackTop />
                </Layout>
            </Layout>
        </AppConfigProvider>
    );
}