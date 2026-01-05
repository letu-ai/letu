import { createFileRoute } from '@tanstack/react-router';
import { getOnlineUsers, onlineUserLogout, type IOnlineUserListOutput, type ISessionRevokeInput} from './-service';
import { Button, Form, Input, Tag } from 'antd';
import { useRef } from 'react';
import Permission from '@/components/Permission';
import { BasisPermissions } from '@/application/permissions';
import SmartTable from '@/components/SmartTable';
import type { SmartTableColumnType, SmartTableRef } from '@/components/SmartTable/type';
import ProIcon from '@/components/ProIcon';
import { App } from 'antd';
import { useAppConfig } from '@/components/AppConfigProvider';
import dayjs from 'dayjs';
import type { ClientType, LoginChannel } from '@/pages/account/-service';

export const Route = createFileRoute('/admin/online-users/')({
    component: OnlineUserList
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

// 登录渠道映射
const getLoginChannelText = (channel: LoginChannel): string => {
    const map: Record<LoginChannel, string> = {
        Account: '账号密码',
        SMS: '短信',
        ThirdParty: '第三方',
    };
    return map[channel] || '未知';
};

function OnlineUserList() {
    const tableRef = useRef<SmartTableRef>(null);
    const appConfig = useAppConfig();
    const { currentUser } = appConfig;
    const sessionId = currentUser.sessionId;
    const { message } = App.useApp();
    const columns: SmartTableColumnType<IOnlineUserListOutput>[] = [
        {
            title: '用户',
            dataIndex: 'userName',
            width: 150,
            render: (userName: string | null, record: IOnlineUserListOutput) => {
                return (
                    <div>
                        <div style={{ fontWeight: 500, marginBottom: 4 }}>
                            {userName || '-'}
                            {sessionId === record.sessionId && (
                                <Tag color="magenta" style={{ marginLeft: 8 }}>
                                    当前会话
                                </Tag>
                            )}
                        </div>
                    </div>
                );
            },
        },
        {
            title: '登录方式',
            width: 180,
            key: 'clientType',
            render: (_: any, record: IOnlineUserListOutput) => {
                return (
                    <div className="flex gap-1">
                        <Tag color="blue">{getClientTypeText(record.clientType)}</Tag>
                        <span className="text-sm">{getLoginChannelText(record.loginChannel)}</span>
                    </div>
                );
            },
        },
        {
            title: '设备信息',
            width: 250,
            key: 'deviceName',
            render: (_: any, record: IOnlineUserListOutput) => {
                return (
                    <div className="flex flex-col gap-1">
                        {record.deviceName && (
                            <span className="text-sm">{record.deviceName}</span>
                        )}
                        {record.userAgent && (
                            <span className="text-xs text-gray-500 truncate max-w-[300px]" title={record.userAgent}>{record.userAgent}</span>
                        )}
                        {record.appVersion && (
                            <span className="text-sm">{record.appVersion}</span>
                        )}
                        {!record.deviceName && !record.userAgent && !record.appVersion && (
                            <span className="text-sm text-gray-500">-</span>
                        )}
                    </div>
                );
            },
        },
        {
            title: '网络',
            width: 200,
            key: 'ipAddress',
            render: (_: any, record: IOnlineUserListOutput) => {
                return (
                    <div className="flex flex-col gap-1">
                        {record.ipAddress && (
                            <span className="text-sm">{record.ipAddress}</span>
                        )}
                        {record.geo && (
                            <span className="text-sm">{record.geo}</span>
                        )}
                        {!record.ipAddress && !record.geo && (
                            <span className="text-sm text-gray-500">-</span>
                        )}
                    </div>
                );
            },
        },
        {
            title: '登录时间',
            width: 200,
            key: 'creationTime',
            render: (_: any, record: IOnlineUserListOutput) => {
                return (
                    <div className="flex flex-col gap-1">
                        <span className="text-sm">{record.creationTime ? dayjs(record.creationTime).format('YYYY-MM-DD HH:mm:ss') : '-'}</span>
                        <div>
                            <Tag color="green">{record.lastActiveTime ? `活动: ${dayjs(record.lastActiveTime).fromNow()}` : '-'}</Tag>
                        </div>
                    </div>
                );
            },
        },
        {
            title: '操作',
                width: 80,
            fixed: 'right',
            key: 'option',
            render: (_: any, record: IOnlineUserListOutput) => {
                return (
                    <Permission permissions={BasisPermissions.User.Revoke}>
                        <Button
                            type="link"
                            icon={<ProIcon icon="iconify:hugeicons:logout-04" />}
                            onClick={() => {
                                onlineUserLogout({ userId: record.userId, sessionId: record.sessionId } as ISessionRevokeInput).then(() => {
                                    message.success('注销成功');
                                    tableRef.current?.reload();
                                });
                            }}
                        >
                            注销
                        </Button>
                    </Permission>
                );
            },
        },
    ];

    return (
        <SmartTable
            ref={tableRef}
            columns={columns}
            rowKey="sessionId"
            request={async (params) => {
                const data = await getOnlineUsers(params);
                return data;
            }}
            searchItems={
                <Form.Item label="账号" name="userName">
                    <Input placeholder="请输入账号" />
                </Form.Item>
            }
        />
    );
}