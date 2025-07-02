import { getApiAccessLogList } from '@/api/monitor/monitorLog.ts';
import { Form, Input } from 'antd';
import React from 'react';
import type { SmartTableColumnType } from '@/components/SmartTable/type.ts';
import SmartTable from '@/components/SmartTable';

const BusinessLogList: React.FC = () => {
  const columns: SmartTableColumnType[] = [
    {
      title: 'API',
      dataIndex: 'path',
    },
    {
      title: '动作',
      dataIndex: 'method',
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
      title: '耗时',
      dataIndex: 'duration',
      render: (duration: number) => {
        if (duration > 0) return `${duration}ms`;
        return null;
      },
    },
    {
      title: '请求时间',
      dataIndex: 'requestTime',
    },
  ];

  return (
    <SmartTable
      columns={columns}
      rowKey="id"
      request={async (params) => {
        const { data } = await getApiAccessLogList(params);
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
