import { getOnlineUsers, onlineUserLogout, type OnlineUserResultDto } from '@/api/monitor/onlineUser';
import { Form, Input, message } from 'antd';
import React from 'react';
import Permission from '@/components/Permission';
import SmartTable from '@/components/SmartTable';
import type { SmartTableColumnType } from '@/components/SmartTable/type.ts';

const OnlineUserList: React.FC = () => {
  const columns: SmartTableColumnType[] = [
    {
      title: '账号',
      dataIndex: 'userName',
    },
    {
      title: 'IP',
      dataIndex: 'ip',
    },
    {
      title: '地址',
      dataIndex: 'address',
    },
    {
      title: '浏览器',
      dataIndex: 'browser',
    },
    {
      title: '登录时间',
      dataIndex: 'creationTime',
    },
    {
      title: '操作',
      dataIndex: 'option',
      render: (_: any, record: OnlineUserResultDto) => {
        return (
          <Permission permissions={'Monitor.Logout'}>
            <a
              key="logout"
              onClick={() => {
                onlineUserLogout(record.userId + ':' + record.sessionId).then(() => {
                  message.success('注销成功');
                  //actionRef.current?.reload()
                });
              }}
            >
              注销
            </a>
          </Permission>
        );
      },
    },
  ];

  return (
    <>
      <SmartTable
        columns={columns}
        rowKey="id"
        request={async (params) => {
          const { data } = await getOnlineUsers(params);
          return data;
        }}
        searchItems={
          <Form.Item label="账号" name="userName">
            <Input placeholder="请输入账号" />
          </Form.Item>
        }
      />
    </>
  );
};

export default OnlineUserList;
