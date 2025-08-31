import { createFileRoute, Link } from '@tanstack/react-router';
import Permission from "@/components/Permission";
import { BasisPermissions } from "@/application/permissions";
import {
    deleteNotifications,
    getNotificationList,
    publishNotification,
    withdrawNotification,
    type NotificationResultDto,
    NotificationStatus,
    NotificationPriority,
    NotificationType,
    SendScopeType,
    NOTIFICATION_TYPE_OPTIONS,
    NOTIFICATION_STATUS_OPTIONS,
    NOTIFICATION_PRIORITY_OPTIONS,
    cleanExpiredNotifications,
} from "./-service";
import {
    DeleteOutlined,
    EditOutlined,
    PlusOutlined,
    SendOutlined,
    StopOutlined,
    EyeOutlined,
    ClockCircleOutlined,
} from "@ant-design/icons";
import {
    Button,
    Form,
    Input,
    Popconfirm,
    Select,
    Space,
    Tooltip,
    Tag,
    Progress,
} from "antd";
import React, { useRef } from "react";
import type { SmartTableRef, SmartTableColumnType } from "@/components/SmartTable/type";
import SmartTable from "@/components/SmartTable";
import NotificationForm, { type ModalRef } from "./-NotificationForm";
import RecipientModal, { type RecipientModalRef } from "./-RecipientModal";
import { App } from "antd";
import dayjs from "dayjs";


export const Route = createFileRoute('/admin/notifications/')({ 
    component: NotificationList
  });

  
// 状态标签组件
const StatusTag: React.FC<{ status: NotificationStatus }> = ({ status }) => {
    const statusConfig = {
        [NotificationStatus.DRAFT]: { color: "default", text: "草稿" },
        [NotificationStatus.PUBLISHED]: { color: "success", text: "已发布" },
        [NotificationStatus.WITHDRAWN]: { color: "error", text: "已撤回" },
    } as const;

    const config = statusConfig[status];
    if (!config) {
        console.warn(`Unknown notification status: ${status}`);
        return <Tag color="default">未知状态</Tag>;
    }
    return <Tag color={config.color}>{config.text}</Tag>;
};

// 优先级标签组件
const PriorityTag: React.FC<{ priority: NotificationPriority }> = ({ priority }) => {
    const priorityConfig = {
        [NotificationPriority.NORMAL]: { color: "default", text: "普通" },
        [NotificationPriority.IMPORTANT]: { color: "warning", text: "重要" },
        [NotificationPriority.URGENT]: { color: "error", text: "紧急" },
    } as const;

    const config = priorityConfig[priority];
    if (!config) {
        console.warn(`Unknown notification priority: ${priority}`);
        return <Tag color="default">未知优先级</Tag>;
    }
    return <Tag color={config.color}>{config.text}</Tag>;
};

// 通知类型标签组件
const NotificationTypeTag: React.FC<{ type: NotificationType }> = ({ type }) => {
    const typeConfig = {
        [NotificationType.SYSTEM_ANNOUNCEMENT]: { color: "blue", text: "系统公告" },
        [NotificationType.TASK_REMINDER]: { color: "green", text: "任务提醒" },
        [NotificationType.APPROVAL_NOTICE]: { color: "orange", text: "审批通知" },
        [NotificationType.OTHER]: { color: "default", text: "其他" },
    } as const;

    const config = typeConfig[type];
    if (!config) {
        console.warn(`Unknown notification type: ${type}`);
        return <Tag color="default">未知类型</Tag>;
    }
    return <Tag color={config.color}>{config.text}</Tag>;
};

// 发送范围组件
const SendScopeText: React.FC<{ type: SendScopeType }> = ({ type }) => {
    const scopeConfig = {
        [SendScopeType.SPECIFIC_USERS]: "指定用户",
        [SendScopeType.BY_ROLE]: "按角色",
        [SendScopeType.BY_DEPARTMENT]: "按部门",
        [SendScopeType.BY_POSITION]: "按职位",
        [SendScopeType.ALL_EMPLOYEES]: "全体员工",
    } as const;

    const text = scopeConfig[type];
    if (!text) {
        console.warn(`Unknown send scope type: ${type}`);
        return <>未知范围</>;
    }
    return <>{text}</>;
};

// 阅读进度组件
const ReadProgress: React.FC<{ record: NotificationResultDto }> = ({ record }) => {
    if (record.recipientCount === 0) return <>-</>;

    const percent = Math.round((record.readCount / record.recipientCount) * 100);
    return (
        <div style={{ width: 100 }}>
            <Progress percent={percent} size="small" />
            <div style={{ fontSize: 12, color: "#666" }}>
                {record.readCount}/{record.recipientCount}
            </div>
        </div>
    );
};

// 时间显示组件
const TimeText: React.FC<{ time?: string }> = ({ time }) => {
    return <>{time ? dayjs(time).format("YYYY-MM-DD HH:mm") : "-"}</>;
};

function NotificationList() {
    const tableRef = useRef<SmartTableRef>(null);
    const modalRef = useRef<ModalRef>(null);
    const recipientModalRef = useRef<RecipientModalRef>(null);
    const { message } = App.useApp();

    const columns: SmartTableColumnType<NotificationResultDto>[] = [
        {
            title: "通知标题",
            dataIndex: "title",
            ellipsis: true,
            render: (text: string, record) => (
                <Link to={`/admin/notifications/$id`} params={{ id: record.id }}>{text}</Link>
            ),
        },
        {
            title: "类型",
            dataIndex: "notificationType",
            width: 100,
            render: (type: NotificationType) => <NotificationTypeTag type={type} />,
        },
        {
            title: "优先级",
            dataIndex: "priority",
            width: 80,
            render: (priority: NotificationPriority) => <PriorityTag priority={priority} />,
        },
        {
            title: "发送范围",
            dataIndex: "sendScopeType",
            width: 100,
            render: (type: SendScopeType) => <SendScopeText type={type} />,
        },
        {
            title: "状态",
            dataIndex: "status",
            width: 80,
            render: (status: NotificationStatus) => <StatusTag status={status} />,
        },
        {
            title: "阅读进度",
            dataIndex: "readProgress",
            width: 120,
            render: (_, record) => <ReadProgress record={record} />,
        },
        {
            title: "发送人",
            dataIndex: "senderName",
            width: 100,
            ellipsis: true,
        },
        {
            title: "发布时间",
            dataIndex: "publishTime",
            width: 160,
            render: (time?: string) => <TimeText time={time} />,
        },
        {
            title: "操作",
            dataIndex: "option",
            width: 60,
            render: (_, record) => (
                <Space>
                    {/* 编辑按钮 - 只有草稿状态才能编辑 */}
                    {record.status === NotificationStatus.DRAFT && (
                        <Permission permissions={BasisPermissions.Notification.Update}>
                            <Tooltip title="编辑">
                                <Button
                                    type="link"
                                    icon={<EditOutlined />}
                                    onClick={() => {
                                        modalRef?.current?.openModal(record);
                                    }}
                                />
                            </Tooltip>
                        </Permission>
                    )}

                    {/* 发布按钮 - 只有草稿状态才能发布 */}
                    {record.status === NotificationStatus.DRAFT && (
                        <Permission permissions={BasisPermissions.Notification.Update}>
                            <Popconfirm
                                title="确定发布这条通知吗？"
                                description="发布后将立即发送给目标用户"
                                onConfirm={async () => {
                                    try {
                                        await publishNotification(record.id);
                                        message.success("发布成功");
                                        tableRef.current?.reload();
                                    } catch (error) {
                                        console.error(error);
                                    }
                                }}
                            >
                                <Tooltip title="发布">
                                    <Button type="link" icon={<SendOutlined />} />
                                </Tooltip>
                            </Popconfirm>
                        </Permission>
                    )}

                    {/* 撤回按钮 - 只有已发布状态才能撤回 */}
                    {record.status === NotificationStatus.PUBLISHED && (
                        <Permission permissions={BasisPermissions.Notification.Update}>
                            <Popconfirm
                                title="确定撤回这条通知吗？"
                                description="撤回后用户将无法再查看此通知"
                                onConfirm={async () => {
                                    try {
                                        await withdrawNotification(record.id);
                                        message.success("撤回成功");
                                        tableRef.current?.reload();
                                    } catch (error) {
                                        console.error(error);
                                    }
                                }}
                            >
                                <Tooltip title="撤回">
                                    <Button type="link" icon={<StopOutlined />} />
                                </Tooltip>
                            </Popconfirm>
                        </Permission>
                    )}

                    {/* 查看接收人按钮 - 已发布的通知才有接收人 */}
                    {record.status !== NotificationStatus.DRAFT && (
                        <Tooltip title="查看接收人">
                            <Button
                                type="link"
                                icon={<EyeOutlined />}
                                onClick={() => {
                                    recipientModalRef.current?.openModal(record.id, record.title);
                                }}
                            />
                        </Tooltip>
                    )}

                    {/* 删除按钮 - 已发布的通知不能删除 */}
                    {record.status !== NotificationStatus.PUBLISHED && (
                        <Permission permissions={BasisPermissions.Notification.Delete}>
                            <Popconfirm
                                title="确定删除吗？"
                                description="删除后无法撤销"
                                onConfirm={async () => {
                                    try {
                                        await deleteNotifications([record.id]);
                                        message.success("删除成功");
                                        tableRef.current?.reload();
                                    } catch (error) {
                                        console.error(error);
                                    }
                                }}
                            >
                                <Tooltip title="删除">
                                    <Button type="link" danger icon={<DeleteOutlined />} />
                                </Tooltip>
                            </Popconfirm>
                        </Permission>
                    )}
                </Space>
            ),
        },
    ];

    return (
        <>
            <SmartTable
                columns={columns}
                ref={tableRef}
                rowKey="id"
                request={async (params) => {
                    const data = await getNotificationList(params);
                    return data;
                }}
                searchItems={[
                    <Form.Item label="通知标题" name="title">
                        <Input placeholder="请输入通知标题" />
                    </Form.Item>,
                    <Form.Item label="通知类型" name="notificationType">
                        <Select
                            allowClear
                            placeholder="请选择通知类型"
                            options={NOTIFICATION_TYPE_OPTIONS}
                        />
                    </Form.Item>,
                    <Form.Item label="通知状态" name="status">
                        <Select
                            allowClear
                            placeholder="请选择通知状态"
                            options={NOTIFICATION_STATUS_OPTIONS}
                        />
                    </Form.Item>,
                    <Form.Item label="优先级" name="priority">
                        <Select
                            allowClear
                            placeholder="请选择优先级"
                            options={NOTIFICATION_PRIORITY_OPTIONS}
                        />
                    </Form.Item>,
                ]}
                toolbar={
                    <Space size="middle">
                        <Permission permissions={BasisPermissions.Notification.Create}>
                            <Button
                                type="primary"
                                icon={<PlusOutlined />}
                                onClick={() => {
                                    modalRef?.current?.openModal();
                                }}
                            >
                                新建通知
                            </Button>
                        </Permission>
                        <Permission permissions={BasisPermissions.Notification.Delete}>
                            <Button
                                icon={<ClockCircleOutlined />}
                                onClick={async () => {
                                    try {
                                        await cleanExpiredNotifications();
                                        message.success('清理完成');
                                        tableRef.current?.reload();
                                    } catch (error) {
                                        console.error(error);
                                    }
                                }}
                            >
                                清理过期通知
                            </Button>
                        </Permission>
                    </Space>
                }
            />
            {/* 新增/编辑通知弹窗 */}
            <NotificationForm ref={modalRef} refresh={() => tableRef?.current?.reload()} />
            {/* 查看接收人弹窗 */}
            <RecipientModal ref={recipientModalRef} />
        </>
    );
}