import { useEffect, useState } from 'react';
import { Card, Button, Tag, Spin, Alert } from 'antd';
import { ArrowLeftOutlined, CheckOutlined } from '@ant-design/icons';
import { createFileRoute, Link } from '@tanstack/react-router';
import { 
    getNotificationDetail, 
    readed, 
    type MyNotificationListDto 
} from './-service';
import { formatTime } from '@/utils/timeUtils';
import { App } from 'antd';

export const Route = createFileRoute('/my/notifications/$id')({
    component: NotificationDetail
});

function NotificationDetail() {
    const { id } = Route.useParams();
    const [notification, setNotification] = useState<MyNotificationListDto | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const { message } = App.useApp();

    useEffect(() => {
        const fetchNotificationDetail = async () => {
            try {
                setLoading(true);
                const data = await getNotificationDetail(id);
                setNotification(data);

                // 如果是未读通知，自动标记为已读
                if (!data.isReaded) {
                    await readed([id]);
                    setNotification(prev => prev ? { ...prev, isReaded: true } : null);
                    message.success('通知已标记为已读');
                }
            } catch (err) {
                setError('获取通知详情失败');
                console.error('获取通知详情失败:', err);
            } finally {
                setLoading(false);
            }
        };

        fetchNotificationDetail();
    }, [id, message]);

    if (loading) {
        return (
            <div className="flex justify-center items-center h-64">
                <Spin size="large"/>
            </div>
        );
    }

    if (error || !notification) {
        return (
            <div className="max-w-4xl mx-auto p-4">
                <Alert
                    message="错误"
                    description={error || '通知不存在'}
                    type="error"
                    showIcon
                    action={
                        <Link to="/my/notifications">
                            <Button size="small" type="primary">
                                返回列表
                            </Button>
                        </Link>
                    }
                />
            </div>
        );
    }

    return (
        <div className="max-w-4xl mx-auto p-4">
            {/* 顶部操作栏 */}
            <div className="mb-4 flex items-center justify-between">
                <Link 
                    to="/my/notifications"
                    className="flex items-center text-blue-600 hover:text-blue-800"
                >
                    <ArrowLeftOutlined className="mr-2" />
                    返回通知列表
                </Link>
                
                <div className="flex items-center space-x-2">
                    <Tag color={notification.isReaded ? 'green' : 'red'}>
                        {notification.isReaded ? '已读' : '未读'}
                    </Tag>
                    {!notification.isReaded && (
                        <Button 
                            type="primary" 
                            size="small" 
                            icon={<CheckOutlined />}
                            onClick={async () => {
                                try {
                                    await readed([notification.id]);
                                    setNotification(prev => prev ? { ...prev, isReaded: true } : null);
                                    message.success('标记为已读成功');
                                } catch {
                                    message.error('标记失败');
                                }
                            }}
                        >
                            标记已读
                        </Button>
                    )}
                </div>
            </div>

            {/* 通知详情卡片 */}
            <Card className="shadow-md">
                <div className="space-y-4">
                    {/* 标题 */}
                    <div>
                        <h1 className="text-2xl font-bold text-gray-900 mb-2">
                            {notification.title || '无标题'}
                        </h1>
                        <div className="text-sm text-gray-500">
                            创建时间：{formatTime(notification.creationTime)}
                            {notification.readedTime && (
                                <span className="ml-4">
                                    已读时间：{formatTime(notification.readedTime)}
                                </span>
                            )}
                        </div>
                    </div>

                    {/* 内容 */}
                    <div className="border-t pt-4">
                        <div className="prose max-w-none">
                            {notification.content ? (
                                <div className="whitespace-pre-wrap text-gray-700 leading-relaxed">
                                    {notification.content}
                                </div>
                            ) : (
                                <div className="text-gray-500 italic">
                                    暂无详细内容
                                </div>
                            )}
                        </div>
                    </div>
                </div>
            </Card>
        </div>
    );
}