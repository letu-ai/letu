import { createFileRoute } from '@tanstack/react-router';
import { Menu, Layout, Typography } from "antd";
import { useLocation, useNavigate, Outlet } from "@tanstack/react-router";
import { useEffect, useState } from "react";

const { Sider, Content } = Layout;
const { Title } = Typography;

const settingsMenu = [
    {
        key: "site",
        label: "站点",
    },
    {
        key: "account",
        label: "账户",
    },
    {
        key: "emailing",
        label: "邮件",
    },
    {
        key: "timezone",
        label: "时区",
    },
    {
        key: "amap",
        label: "高德地图",
    },
    {
        key: "feature",
        label: "功能管理",
    },
];

export const Route = createFileRoute('/admin/settings')({
    component: SettingsLayout
});

function SettingsLayout() {
    const location = useLocation();
    const navigate = useNavigate();
    const [selectedKey, setSelectedKey] = useState("site");

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
        <div className="h-full w-4xl mx-auto">
            <Title level={2} className="pt-4">
                系统参数设置
            </Title>
            <Layout className="min-h-[600px] bg-white rounded-lg">
                <Sider width={240} className="bg-gray-50 p-4">
                    <Menu
                        mode="vertical"
                        selectedKeys={[selectedKey]}
                        onClick={handleMenuClick}
                        style={{ height: "100%", borderRight: 0 }}
                        className="h-full border-r-0 bg-gray-50"
                        items={settingsMenu}
                    />
                </Sider>
                <Content className="p-6">
                    <Outlet />
                </Content>
            </Layout>
        </div>
    );
}
