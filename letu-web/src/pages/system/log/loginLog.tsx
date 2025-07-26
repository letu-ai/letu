import { getLoginLogList } from '@/api/system/log/loginLog';
import { Form, Input, Tag } from 'antd';
import type { SmartTableColumnType } from '@/components/SmartTable/type.ts';
import SmartTable from '@/components/SmartTable';
import React from 'react';

const LoginLogList: React.FC = () => {
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
      title: '结果',
      dataIndex: 'isSuccess',
      render: (text: boolean) => {
        return text ? <Tag color="green">成功</Tag> : <Tag color="red">失败</Tag>;
      },
    },
    {
      title: '结果消息',
      dataIndex: 'operationMsg',
    },
    {
      title: '登录时间',
      dataIndex: 'creationTime',
    },
  ];

  return (
    <>
      <SmartTable
        columns={columns}
        rowKey="id"
        request={async (params) => {
          const { data } = await getLoginLogList(params);
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

export default LoginLogList;
