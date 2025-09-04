import { createFileRoute, useRouter } from '@tanstack/react-router'
import { requireAuth } from '@/utils/authUtils'
import { Outlet } from '@tanstack/react-router';
import Sidebar from '@/components/layout/Sidebar';
import { FloatButton, Layout } from 'antd';
import { useMediaQuery } from 'react-responsive';
import ErrorFallback from '@/components/ErrorFallback';
import { ErrorBoundary } from 'react-error-boundary';
import { useEffect, useRef } from 'react';
import useLayoutStore from '@/application/layoutStore';
import Navbar from '@/components/layout/Navbar';
import { AppConfigProvider, loadConfiguration } from '@/components/AppConfigProvider';

const { Content, Sider } = Layout;

export const Route = createFileRoute('/admin')({
    component: AdminLayout,
    beforeLoad: async ({ location }) => {
        requireAuth(location);
    },
    loader: async () => {
        const config = await loadConfiguration("admin")
        return { config }
    },
    staleTime: 1000 * 60 * 30, // 30分钟过期
    errorComponent: ({ error }) => {
        const router = useRouter();

        const handleRetry = () => {
            router.invalidate();
        };

        return (
            <div className='h-screen'>
                <ErrorFallback error={error} resetErrorBoundary={handleRetry} />
            </div>
        )
    }
})

function AdminLayout() {
    const { config } = Route.useLoaderData()

    const collapsed = useLayoutStore(state => state.collapsed);
    const toggleCollapsed = useLayoutStore(state => state.toggleCollapsed);
    const isMinScreen = useMediaQuery({ maxWidth: '768px' });

    // 使用 ref 来跟踪是否是初始化阶段，避免与用户手动操作冲突
    const isInitializedRef = useRef(false);

    useEffect(() => {
        // 只在初始化时或屏幕尺寸从大变小/从小变大时自动调整
        if (!isInitializedRef.current) {
            // 初始化时根据屏幕尺寸设置默认状态
            if (isMinScreen && !collapsed) {
                toggleCollapsed();
            } else if (!isMinScreen && collapsed) {
                toggleCollapsed();
            }
            isInitializedRef.current = true;
        }
        // 注意：移除了对 collapsed 的依赖，避免用户手动操作后被重置
    }, [isMinScreen, toggleCollapsed]);

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
