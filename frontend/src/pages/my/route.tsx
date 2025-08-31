import { createFileRoute, Outlet, Link } from '@tanstack/react-router'
import { FloatButton, Layout } from 'antd'
import { UserOutlined, LockOutlined, HistoryOutlined, BellOutlined } from '@ant-design/icons'
import { requireAuth } from '@/utils/authUtils'
import Navbar from '@/components/layout/Navbar'
import Application from '@/components/Application'
import Sidebar from '@/components/layout/Sidebar'
import { ErrorBoundary } from 'react-error-boundary'
import ErrorFallback from '@/components/ErrorFallback'

const { Sider, Content } = Layout

export const Route = createFileRoute('/my')({
    component: MyLayout,
    beforeLoad: async ({ location }) => {
        requireAuth(location)
    },
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
    return (
        <Application>
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
        </Application>
    );
}
