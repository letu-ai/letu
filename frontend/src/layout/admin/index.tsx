import { useOutlet } from 'react-router-dom';
import Sidebar from '@/layout/admin/components/Sidebar.tsx';
import Navbar from './components/Navbar.tsx';
import Tab from '@/layout/admin/components/Tab.tsx';
import { FloatButton, Layout } from 'antd';
import { useMediaQuery } from 'react-responsive';
import ErrorFallback from '@/components/ErrorFallback';
import { ErrorBoundary } from 'react-error-boundary';
import { useEffect } from 'react';
import { useConfigStore } from '@/application/configStore.tsx';
import Authorize from '@/components/Authorize';
import useLayoutStore from '@/store/layoutStore';

const { Content, Sider } = Layout;

function Index() {
    const curOutlet = useOutlet();
    const collapsed = useLayoutStore(state => state.collapsed);
    const toggleCollapsed = useLayoutStore(state => state.toggleCollapsed);
    const isMinScreen = useMediaQuery({ maxWidth: '768px' });
    const loadConfiguration = useConfigStore((state) => state.loadConfiguration);

    useEffect(() => {
        const needToggleCollapsed = (isMinScreen && !collapsed) || (!isMinScreen && collapsed);
        if (needToggleCollapsed) {
            toggleCollapsed();
        }
    }, [isMinScreen, collapsed, toggleCollapsed]);

    useEffect(() => {
        // 直接使用 loadConfiguration，已内置防重复调用逻辑
        loadConfiguration()
            .then(() => {
                console.log('配置加载完成');
            })
            .catch((error) => {
                console.error('加载配置失败:', error);
            });
    }, [loadConfiguration]);

    return (
        <Authorize>
            <Layout hasSider className="letu-layout">
                <Sider trigger={null} collapsible collapsed={collapsed}>
                    <Sidebar />
                </Sider>
                <Layout>
                    <Navbar />
                    <Tab />
                    <ErrorBoundary FallbackComponent={ErrorFallback}>
                        <Content>{curOutlet}</Content>
                    </ErrorBoundary>
                    <FloatButton.BackTop />
                </Layout>
            </Layout>
        </Authorize>
    );
}

export default Index;
