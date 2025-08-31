import { createFileRoute } from '@tanstack/react-router';
import { Menu, Layout, Typography } from "antd";
import { useLocation, useNavigate, Outlet } from "@tanstack/react-router";
import { useEffect, useState } from "react";

const { Sider, Content } = Layout;
const { Title } = Typography;

const settingsMenu = [
    {
        key: "feature",
        label: "功能管理",
    },
    {
        key: "timezone",
        label: "时区",
    },
    {
        key: "account",
        label: "账户",
    },
    {
        key: "emailing",
        label: "邮件",
    }
];

export const Route = createFileRoute('/admin/settings')({
    component: SettingsLayout
});

function SettingsLayout() {
    const location = useLocation();
    const navigate = useNavigate();
    const [selectedKey, setSelectedKey] = useState("feature");

    // 根据当前路径设置选中的菜单项
    useEffect(() => {
        const path = location.pathname;
        const pathSegments = path.split('/').filter(Boolean);
        
        // 确保是在 settings 页面路径下
        if (pathSegments.includes('settings')) {
            const lastSegment = pathSegments[pathSegments.length - 1];
            
            // 如果最后一个片段匹配菜单项，设置为选中
            if (settingsMenu.some(item => item.key === lastSegment)) {
                setSelectedKey(lastSegment);
            } else if (path === "/admin/settings" || lastSegment === "settings") {
                // 如果是设置页面根路径，默认选中 feature，但不跳转
                setSelectedKey("feature");
            }
        }
    }, [location.pathname]);

    const handleMenuClick = (e: any) => {
        setSelectedKey(e.key);
        navigate({ to: `/admin/settings/${e.key}` });
    };

    return (
        <div style={{ height: "100%" }}>
            <Title level={2} style={{ paddingBottom: 16 }}>
                系统参数设置
            </Title>
            <Layout style={{ minHeight: 600, backgroundColor: "#fff", borderRadius: 8 }}>
                <Sider width={240} style={{ backgroundColor: "#fafafa" }}>
                    <Menu
                        mode="vertical"
                        selectedKeys={[selectedKey]}
                        onClick={handleMenuClick}
                        style={{ height: "100%", borderRight: 0 }}
                        items={settingsMenu}
                    />
                </Sider>
                <Content style={{ padding: 24 }}>
                    <Outlet />
                </Content>
            </Layout>
        </div>
    );
}
