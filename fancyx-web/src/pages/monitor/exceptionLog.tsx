import { getExceptionLogList } from '@/api/monitor/monitorLog.ts';
import { Form, Input, Tag } from 'antd';
import React from 'react';
import type { SmartTableColumnType } from '@/components/SmartTable/type.ts';
import SmartTable from '@/components/SmartTable';

const BusinessLogList: React.FC = () => {
  const columns: SmartTableColumnType[] = [
    {
      title: '异常信息',
      dataIndex: 'message',
    },
    {
      title: '异常API',
      dataIndex: 'requestPath',
    },
    {
      title: 'IP',
      dataIndex: 'ip',
    },
    {
      title: '浏览器',
      dataIndex: 'browser',
    },
    {
      title: '状态',
      dataIndex: 'isHandled',
      render: (isHandled: boolean) => {
        if (isHandled) {
          return <Tag color="success">已处理</Tag>;
        }
        return <Tag color="red">待处理</Tag>;
      },
    },
  ];

  return (
    <SmartTable
      columns={columns}
      rowKey="id"
      request={async (params) => {
        const { data } = await getExceptionLogList(params);
        return data;
      }}
      searchItems={
        <>
          <Form.Item label="API" name="path">
            <Input placeholder="请输入API地址" />
          </Form.Item>
          <Form.Item label="访问用户" name="userName">
            <Input placeholder="请输入访问用户名" />
          </Form.Item>
        </>
      }
    />
  );
};

export default BusinessLogList;
