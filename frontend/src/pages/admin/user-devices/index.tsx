import { createFileRoute } from '@tanstack/react-router';
import { getUserDevices, type IUserDeviceListOutput } from './-service';
import { Form, Input, Select, Tag } from 'antd';
import { useRef } from 'react';
import SmartTable from '@/components/SmartTable';
import type { SmartTableColumnType, SmartTableRef } from '@/components/SmartTable/type';
import dayjs from 'dayjs';
import type { ClientType } from '@/pages/account/-service';

export const Route = createFileRoute('/admin/user-devices/')({
    component: UserDeviceList
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

// 客户端类型选项
const clientTypeOptions: { label: string; value: ClientType }[] = [
    { label: 'Web', value: 'Web' },
    { label: 'PC', value: 'PC' },
    { label: 'Android', value: 'Android' },
    { label: 'IOS', value: 'IOS' },
    { label: '微信小程序', value: 'WechatMiniProgram' },
    { label: 'HarmonyOS', value: 'HarmonyOS' },
    { label: '其他', value: 'Other' },
];

function UserDeviceList() {
    const tableRef = useRef<SmartTableRef>(null);

    const columns: SmartTableColumnType<IUserDeviceListOutput>[] = [
        {
            title: '用户',
            dataIndex: 'userName',
            width: 150,
            render: (userName: string | null, record: IUserDeviceListOutput) => {
                return (
                    <div>
                        <div style={{ fontWeight: 500, marginBottom: 4 }}>
                            {userName || '-'}
                        </div>
                        {record.userNickName && (
                            <div className="text-xs text-gray-500">
                                昵称: {record.userNickName}
                            </div>
                        )}
                    </div>
                );
            },
        },
        {
            title: '客户端类型',
            dataIndex: 'clientType',
            width: 120,
            render: (clientType: ClientType) => {
                let color = 'default';
                if (clientType === 'Android') color = 'green';
                if (clientType === 'IOS') color = 'blue';
                if (clientType === 'Web') color = 'geekblue';
                if (clientType === 'PC') color = 'cyan';
                if (clientType === 'WechatMiniProgram') color = 'lime';
                if (clientType === 'HarmonyOS') color = 'purple';

                return <Tag color={color}>{getClientTypeText(clientType)}</Tag>;
            },
        },
        {
            title: '设备信息',
            width: 250,
            key: 'deviceInfo',
            render: (_: any, record: IUserDeviceListOutput) => {
                return (
                    <div className="flex flex-col gap-1">
                        {record.deviceName && (
                            <span className="text-sm">{record.deviceName}</span>
                        )}
                        {record.deviceId && (
                            <span className="text-xs text-gray-500">
                                设备ID: {record.deviceId}
                            </span>
                        )}
                        {record.packageName && (
                            <span className="text-xs text-gray-500">
                                包名: {record.packageName}
                            </span>
                        )}
                        {record.appVersion && (
                            <span className="text-sm">版本: {record.appVersion}</span>
                        )}
                        {record.pushDeviceId && (
                            <span className="text-xs text-gray-500">
                                推送ID: {record.pushDeviceId}
                            </span>
                        )}
                        {!record.deviceName && !record.deviceId && !record.packageName &&
                            !record.appVersion && !record.pushDeviceId && (
                                <span className="text-sm text-gray-500">-</span>
                            )}
                    </div>
                );
            },
        },
        {
            title: '最后活跃时间',
            width: 180,
            dataIndex: 'lastActiveTime',
            render: (lastActiveTime: string) => {
                return (
                    <div className="flex flex-col gap-1">
                        <span className="text-sm">
                            {lastActiveTime ? dayjs(lastActiveTime).format('YYYY-MM-DD HH:mm:ss') : '-'}
                        </span>
                        <span className="text-xs text-gray-500">
                            {lastActiveTime ? `(${dayjs(lastActiveTime).fromNow()})` : ''}
                        </span>
                    </div>
                );
            },
        },
        {
            title: '首次记录时间',
            width: 180,
            dataIndex: 'creationTime',
            render: (creationTime: string) => {
                return (
                    <span className="text-sm">
                        {creationTime ? dayjs(creationTime).format('YYYY-MM-DD HH:mm:ss') : '-'}
                    </span>
                );
            },
        },
    ];

    return (
        <SmartTable
            ref={tableRef}
            columns={columns}
            rowKey="id"
            request={async (params) => {
                const data = await getUserDevices(params);
                return data;
            }}
            searchItems={
                <>
                    <Form.Item label="用户名" name="userName">
                        <Input placeholder="请输入用户名" />
                    </Form.Item>
                    <Form.Item label="客户端类型" name="clientType">
                        <Select
                            placeholder="请选择客户端类型"
                            allowClear
                            options={clientTypeOptions}
                        />
                    </Form.Item>
                </>
            }
        />
    );
}
