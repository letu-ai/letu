import { readed, getMyNotificationList, type MyNotificationListDto } from "./-service";
import { CheckOutlined, WifiOutlined } from '@ant-design/icons';
import { Button, Form, Input, Select, Tag, Space, Badge } from 'antd';
import { useRef, useEffect, useState, useCallback } from 'react';
import type { SmartTableRef, SmartTableColumnType } from '@/components/SmartTable/type';
import SmartTable from '@/components/SmartTable';
import { App } from 'antd';
import { createFileRoute, Link } from '@tanstack/react-router';
import { clientConnection } from '@/application/clientConnection';
import { formatTimeFromNow } from "@/utils/timeUtils";

export const Route = createFileRoute('/my/notifications/')({
    component: NotificationList
});

function NotificationList() {
    const tableRef = useRef<SmartTableRef>(null);
    const { message } = App.useApp();
    const [newNotificationCount, setNewNotificationCount] = useState(0);
    const columns: SmartTableColumnType<MyNotificationListDto>[] = [
        {
            title: '通知标题',
            dataIndex: 'title',
        },
        {
            title: '通知内容',
            dataIndex: 'content',
            render: (content: string, record) => {
                return <Link to="/my/notifications/$id" params={{ id: record.id }}>
                    {content.length > 100 ? content.slice(0, 100) + '...' : content}
                </Link>;
            }
        },
        {
            title: '状态',
            dataIndex: 'isReaded',
            render: (isReaded: boolean) => {
                return isReaded ? <Tag color="green">已读</Tag> : <Tag color="red">未读</Tag>;
            },
        },
        {
            title: '创建时间',
            dataIndex: 'creationTime',
            render: (creationTime: string) => {
                return <span>{formatTimeFromNow(creationTime)}</span>;
            },
        },
        {
            title: '操作',
            dataIndex: 'option',
            width: 70,
            fixed: 'right',
            render: (_: any, record: MyNotificationListDto) => {
                if (!record.isReaded) {
                    return (
                        <Button
                            type="link"
                            icon={<CheckOutlined />}
                            onClick={() => {
                                batchReaded([record.id]);
                            }}
                        >
                            已读
                        </Button>
                    );
                }
            },
        },
    ];

    const batchReaded = (ids: string[]) => {
        readed(ids).then(() => {
            message.success('已读成功');
            tableRef?.current?.reload();
        });
    };

    // 处理新通知
    const handleNewNotification = useCallback(() => {
        setNewNotificationCount(prev => prev + 1);
        // 显示提示消息
        message.info('收到新通知', 2);
    }, [message]);

    // 刷新列表并清空新通知计数
    const refreshList = () => {
        tableRef?.current?.reload();
        setNewNotificationCount(0);
    };

    useEffect(() => {
        // 监听新通知
        clientConnection.on('notification', handleNewNotification);

        // 组件卸载时清理监听器
        return () => {
            clientConnection.off('notification', handleNewNotification);
        };
    }, [handleNewNotification]);

    return (
        <SmartTable
            columns={columns}
            ref={tableRef}
            selection
            rowKey="id"
            request={async (params) => {
                const data = await getMyNotificationList(params);
                return data;
            }}
            searchItems={[
                <Form.Item key="title" label="通知标题" name="title">
                    <Input placeholder="请输入通知标题" />
                </Form.Item>,
                <Form.Item key="isReaded" label="通知状态" name="isReaded">
                    <Select
                        allowClear
                        placeholder="请选择通知状态"
                        options={[
                            { label: '已读', value: true },
                            { label: '未读', value: false },
                        ]}
                    />
                </Form.Item>,
            ]}
            toolbar={
                <Space>
                    {newNotificationCount > 0 && (
                        <Badge count={newNotificationCount} size="small">
                            <Button
                                type="default"
                                icon={<WifiOutlined />}
                                onClick={refreshList}
                            >
                                刷新列表
                            </Button>
                        </Badge>
                    )}
                    <Button
                        type="primary"
                        icon={<CheckOutlined />}
                        onClick={() => {
                            const ids = tableRef?.current?.getSelectedKeys() as string[];
                            if (ids.length <= 0) {
                                message.warning('请选择一条记录进行操作');
                                return;
                            }
                            batchReaded(ids);
                        }}
                    >
                        批量已读
                    </Button>
                </Space>
            }
        />
    );
}
