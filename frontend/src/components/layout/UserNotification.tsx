import { useEffect, useState } from 'react';
import { Popover, Button } from 'antd';
import ProIcon from '@/components/ProIcon';
import {
    getMyNotificationNavbarInfo,
    readed,
    type UserNotificationNavbarItemDto,
} from '@/pages/my/notifications/-service';
import { clientConnection } from '@/application/clientConnection';
import useApp from 'antd/es/app/useApp';
import { CheckOutlined, EyeOutlined } from '@ant-design/icons';
import { formatTimeFromNow } from '@/utils/timeUtils';
import { Link, useNavigate } from '@tanstack/react-router';

const UserNotification = () => {
    const [visible, setVisible] = useState(false);
    const [notifications, setNotifications] = useState<UserNotificationNavbarItemDto[]>([]);
    const [unreadCount, setUnreadCount] = useState(0);
    const { message } = useApp();
    const { notification } = useApp();
    const navigate = useNavigate();

    const fetchNotifications = () => {
        getMyNotificationNavbarInfo().then((data) => {
            setNotifications(data.items ?? []);
            setUnreadCount(data.noReadedCount);
        }).catch((error) => {
            console.error('获取通知失败:', error);
        });
    };

    useEffect(() => {
        fetchNotifications();

        // 监听新通知
        const handleNewNotification = () => {
            // 收到新通知时刷新导航栏信息
            fetchNotifications();
            // 显示提示
            notification.info({
                message: '新通知',
                description: '您有新的通知消息',
                duration: 3,
                placement: 'topRight',
            });
        };

        clientConnection.on('notification', handleNewNotification);

        // 组件卸载时清理监听器
        return () => {
            clientConnection.off('notification', handleNewNotification);
        };
    }, [notification]);



    // 一键全部已读
    const markAllAsRead = () => {
        const ids = notifications.map((x) => x.id);
        if (ids.length <= 0) {
            return;
        }
        readed(ids).then(() => {
            message.success('一键已读成功', 1, () => {
                fetchNotifications();
                setVisible(false);
            });
        });
    };

    // 处理点击通知项
    const handleNotificationClick = async (item: UserNotificationNavbarItemDto) => {
        if (!item.isReaded) {
            // 标记为已读
            await readed([item.id]);
            // 刷新通知列表
            fetchNotifications();
        }
        setVisible(false);
        // 跳转到通知详情页面
        navigate({ to: '/my/notifications/$id', params: { id: item.id } });
    };

    const content = (
        <div className="w-80 max-h-96 overflow-hidden">
            {/* 通知列表 */}
            <div className="max-h-72 overflow-y-auto">
                {notifications.slice(0, 5).map((item) => (
                    <div
                        key={item.id}
                        className={`p-3 border-b border-gray-100 last:border-b-0 hover:bg-gray-50 cursor-pointer transition-colors duration-150 ${!item.isReaded ? 'bg-blue-50' : ''
                            }`}
                        onClick={() => handleNotificationClick(item)}
                    >
                        <div className="flex items-start justify-between">
                            <div className="flex-1 min-w-0">
                                {/* 通知标题 */}
                                <div className={`text-sm font-medium truncate ${!item.isReaded ? 'text-gray-900' : 'text-gray-600'
                                    }`}>
                                    {item.title || '无标题'}
                                </div>
                                {/* 时间 */}
                                <div className="text-xs text-gray-500 mt-1">
                                    {formatTimeFromNow(item.creationTime)}
                                </div>
                            </div>
                            {/* 未读标识 */}
                            {!item.isReaded && (
                                <div className="w-2 h-2 bg-blue-500 rounded-full ml-2 mt-1 flex-shrink-0"></div>
                            )}
                        </div>
                    </div>
                ))}
                {notifications.length === 0 && (
                    <div className="p-6 text-center text-gray-500 text-sm">
                        暂无通知消息
                    </div>
                )}
            </div>

            {/* 底部操作栏 */}
            <div className="border-t border-gray-100 p-2 flex justify-between items-center">
                <Link
                    to="/my/notifications"
                    className="text-sm text-blue-600 hover:text-blue-800 flex items-center"
                    onClick={() => setVisible(false)}
                >
                    <EyeOutlined className="mr-1" />
                    查看全部
                </Link>
                <div className="flex-1"></div>
                {unreadCount > 0 && (
                    <Button
                        type="primary"
                        size="small"
                        icon={<CheckOutlined />}
                        onClick={markAllAsRead}
                        className="text-xs"
                    >
                        全部已读
                    </Button>
                )}
            </div>
        </div>
    );

    return (
        <Popover
            content={content}
            title={
                <div className="flex items-center justify-between">
                    <span>通知中心</span>
                    {unreadCount > 0 && (
                        <span className="text-xs text-gray-500">({unreadCount}条未读)</span>
                    )}
                </div>
            }
            trigger="click"
            open={visible}
            onOpenChange={setVisible}
            placement="bottomRight"
        >
            <div className="relative">
                <Button type="text" className="navbar-btn">
                    <ProIcon icon="antd:BellOutlined" />
                </Button>
                {unreadCount > 0 && (
                    <div className="absolute top-1 -right-1 min-w-[16px] h-[16px] bg-error text-white rounded-full flex items-center justify-center text-xs">
                        {unreadCount > 99 ? '99+' : unreadCount}
                    </div>
                )}
            </div>
        </Popover>
    );
};

export default UserNotification;
