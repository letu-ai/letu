import { createFileRoute } from '@tanstack/react-router';
import { Button, Card, Table, Tag, Popconfirm, message } from 'antd';
import { useState, useEffect } from 'react';
import { useAppConfig } from '@/components/AppConfigProvider';
import dayjs from 'dayjs';
import type { ClientType } from '@/pages/account/-service';
import ProIcon from '@/components/ProIcon';
import relativeTime from 'dayjs/plugin/relativeTime';
import 'dayjs/locale/zh-cn';
import { getMySessions, revokeSession, type IUserSessionListOutput } from './active-sessions/-service';

dayjs.extend(relativeTime);
dayjs.locale('zh-cn');

export const Route = createFileRoute('/my/active-sessions')({
    component: RouteComponent,
});

// 客户端类型映射
const getClientTypeText = (type: ClientType): string => {
    const map: Record<ClientType, string> = {
        Web: 'Web',
        PC: 'PC',
        Android: 'Android',
        IOS: 'IOS',
        WechatMiniProgram: '微信小程序',
        HarmonyOS: 'HarmonyOS',
        Other: '其他',
    };
    return map[type] || '未知';
};

function RouteComponent() {
    const [sessions, setSessions] = useState<IUserSessionListOutput[]>([]);
    const [loading, setLoading] = useState(false);
    const appConfig = useAppConfig();
    const { currentUser } = appConfig;
    const currentSessionId = currentUser.sessionId;

    const loadSessions = async () => {  
        setLoading(true);
        try {
            const data = await getMySessions();
            setSessions(data);
        } catch (error) {
            message.error('加载会话列表失败');
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        loadSessions();
    }, []);

    const handleRevoke = async (sessionId: string) => {
        try {
            await revokeSession(sessionId);
            await loadSessions();
        } catch (error) {
            message.error('注销失败');
        }
    };

    const columns = [
        {
            title: '登录设备',
            dataIndex: 'deviceName',
            key: 'deviceName',
            render: (deviceName: string | null, record: IUserSessionListOutput) => {
                return (
                    <div className="flex gap-1 items-center">
                        <Tag color="blue">{getClientTypeText(record.clientType)}</Tag>
                        <span className="font-medium">{deviceName || '-'}</span>
                        {currentSessionId === record.id && (
                            <Tag color="magenta" className="ml-2">
                                当前会话
                            </Tag>
                        )}
                    </div>
                );
            },
        },
        {
            title: '创建时间',
            dataIndex: 'creationTime',
            key: 'creationTime',
            width: 200,
            render: (time: string) => {
                return time ? dayjs(time).format('YYYY-MM-DD HH:mm:ss') : '-';
            },
        },
        {
            title: '最后活动',
            dataIndex: 'lastActiveTime',
            key: 'lastActiveTime',
            width: 200,
            render: (time: string) => {
                return (
                    time && (
                        <Tag color="green">{dayjs(time).fromNow()}</Tag>
                    )
                );
            },
        },
        {
            title: '操作',
            key: 'action',
            width: 100,
            fixed: 'right' as const,
            render: (_: any, record: IUserSessionListOutput) => {
                const isCurrentSession = currentSessionId !== null && currentSessionId === record.id;
                return (
                    <Popconfirm
                        title="确定要注销此会话吗？"
                        onConfirm={() => handleRevoke(record.id)}
                        okText="确定"
                        cancelText="取消"
                        disabled={isCurrentSession}
                    >
                        <Button
                            type="link"
                            danger
                            icon={<ProIcon icon="iconify:hugeicons:logout-04" />}
                            disabled={isCurrentSession}
                        >
                            注销
                        </Button>
                    </Popconfirm>
                );
            },
        },
    ];

    return (
        
        <Card title="活跃会话" className="max-w-4xl mx-auto">
            <Table
                columns={columns}
                dataSource={sessions}
                rowKey="id"
                loading={loading}
                pagination={false}
            />
            <p className="text-sm text-gray-500 mt-2">
                注销最长需要10分钟才能生效。
            </p>
        </Card>
    );
}
