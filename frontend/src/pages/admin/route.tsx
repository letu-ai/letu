import { createFileRoute } from '@tanstack/react-router'
import { requireAuth } from '@/utils/authUtils'
import { Outlet } from '@tanstack/react-router';
import Sidebar from '@/components/layout/Sidebar';
import { FloatButton, Layout } from 'antd';
import { useMediaQuery } from 'react-responsive';
import ErrorFallback from '@/components/ErrorFallback';
import { ErrorBoundary } from 'react-error-boundary';
import { useEffect } from 'react';
import useLayoutStore from '@/application/layoutStore';
import Application from '@/components/Application';
import Navbar from '@/components/layout/Navbar';

const { Content, Sider } = Layout;

export const Route = createFileRoute('/admin')({
    component: AdminLayout,
    beforeLoad: async ({ location }) => {
        requireAuth(location);
    },
})

function AdminLayout() {
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
        <Application app="admin">
            <Layout hasSider>
                <Sider trigger={null} collapsible collapsed={collapsed}>
                    <Sidebar/>
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
        </Application>
    );
}
