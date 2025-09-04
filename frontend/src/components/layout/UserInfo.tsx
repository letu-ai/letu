import { Avatar, Button, Card, Dropdown, Typography, type MenuProps } from 'antd';
import { LogoutOutlined, SettingOutlined, UserOutlined } from '@ant-design/icons';
import { useAppConfig } from '@/components/AppConfigProvider';
import { Link} from '@tanstack/react-router';


const { Text } = Typography

export function UserInfo() {
    const { currentUser: user } = useAppConfig();

    const menuItems: MenuProps["items"] = [
        {
            key: "settings",
            label: (
                <Link to="/admin/users" className="flex items-center gap-2 px-2 py-1">
                    <span className="text-gray-500"><SettingOutlined /></span>
                    <span>系统设置</span>
                </Link>
            ),
        },
        {
            key: "profile",
            label: (
                <Link to="/my/profile" className="flex items-center gap-2 px-2 py-1">
                    <span className="text-gray-500"><UserOutlined /></span>
                    <span>我的账户</span>
                </Link>
            ),
        },
        {
            type: "divider",
        },
        {
            key: "logout",
            label: (
                <Link to="/account/logout" className="flex items-center gap-2 px-2 py-1 text-antd-error-bg hover:text-antd-error-bg-hover">
                    <span><LogoutOutlined /></span>
                    <span>注销</span>
                </Link>
            ),
            danger: true,
        },
    ]

    return (
        <Dropdown
            trigger={["click"]}
            placement="bottomRight"
            menu={{ items: menuItems }}
            popupRender={(menu) => (
                <div>
                    <Card className="w-80 shadow-lg border border-gray-200" styles={{ body: { padding: "24px" } }}>
                        <div className="flex items-start gap-4 mb-4">
                            <Avatar size={48} src={user.avatar || "/placeholder.svg"}>
                            </Avatar>

                            <div className="flex-1 space-y-2">
                                <div>
                                    <Text strong className="text-base leading-none block">
                                        {user.name}
                                    </Text>
                                    <Text type="secondary" className="text-sm mt-1 block">
                                        {user.email}
                                    </Text>
                                </div>

                                <div className="space-y-1.5 pt-1">
                                    <div className="flex items-center gap-2">
                                        <span className="text-gray-500">👥</span>
                                        <Text type="secondary" className="text-sm">
                                            {user.department}
                                        </Text>
                                    </div>
                                    <div className="flex items-center gap-2">
                                        <span className="text-gray-500">🏢</span>
                                        <Text type="secondary" className="text-sm">
                                            {user.organization}
                                        </Text>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </Card>
                    <div className="border-t border-gray-200 mt-2">{menu}</div>
                </div>
            )}
        >
            <Button
                type="text"
                className="h-auto p-2 hover:bg-gray-50 transition-colors flex items-center gap-3"
                aria-label="User menu"
            >
                <Avatar size={40} src={user.avatar || "/placeholder.svg"}>
                </Avatar>
                <div className="text-left hidden sm:block">
                    <Text strong className="text-sm leading-none block">
                        {user.name}
                    </Text>
                    <Text type="secondary" className="text-xs mt-1 block">
                        {user.email}
                    </Text>
                </div>
            </Button>
        </Dropdown>
    )
}

export default UserInfo;
