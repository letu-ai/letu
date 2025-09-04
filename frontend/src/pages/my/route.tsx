import { createFileRoute, Outlet, Link, useRouter } from '@tanstack/react-router'
import { FloatButton, Layout } from 'antd'
import { UserOutlined, LockOutlined, HistoryOutlined, BellOutlined } from '@ant-design/icons'
import { requireAuth } from '@/utils/authUtils'
import Navbar from '@/components/layout/Navbar'
import Sidebar from '@/components/layout/Sidebar'
import { ErrorBoundary } from 'react-error-boundary'
import ErrorFallback from '@/components/ErrorFallback'
import { AppConfigProvider, loadConfiguration } from '@/components/AppConfigProvider'

const { Sider, Content } = Layout

export const Route = createFileRoute('/my')({
    component: MyLayout,
    beforeLoad: async ({ location }) => {
        requireAuth(location)
    },
    loader: async () => {
        const config = await loadConfiguration()
        return {
            config
        }
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

const menuItems = [
    {
        key: '/my/profile',
        icon: <UserOutlined />,
        label: <Link to="/my/profile">个人资料</Link>,
    },
    {
        key: '/my/password',
        icon: <LockOutlined />,
        label: <Link to="/my/password">修改密码</Link>,
    },
    {
        key: '/my/security-logs',
        icon: <HistoryOutlined />,
        label: <Link to="/my/security-logs">登录日志</Link>,
    },
    {
        key: '/my/notifications',
        icon: <BellOutlined />,
        label: <Link to="/my/notifications">我的通知</Link>,
    },
]

function MyLayout() {
    const { config } = Route.useLoaderData()

    return (
        <AppConfigProvider config={config}>
            <Layout hasSider>
                <Sider>
                    <Sidebar menu={menuItems} />
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
