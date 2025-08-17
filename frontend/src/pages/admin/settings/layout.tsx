import { Menu, Layout, Typography } from "antd";
import { useLocation, useNavigate, Outlet } from "react-router-dom";
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

export default function SettingsLayout() {
    const location = useLocation();
    const navigate = useNavigate();
    const [selectedKey, setSelectedKey] = useState("feature");

    // 根据当前路径设置选中的菜单项
    useEffect(() => {
        const path = location.pathname;
        const pathSegments = path.split('/');
        const lastSegment = pathSegments[pathSegments.length - 1];

        if (settingsMenu.some(item => item.key === lastSegment)) {
            setSelectedKey(lastSegment);
        } else {
            // 如果路径不匹配任何菜单项，默认跳转到feature
            setSelectedKey("feature");
            navigate("feature", { replace: true });
        }
    }, [location.pathname, navigate]);

    const handleMenuClick = (e: any) => {
        setSelectedKey(e.key);
        navigate(e.key);
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
