import { type RequestLogDto, getRequestLogList } from '../service';
import { Button, Form, Input, Tag } from 'antd';
import React, { useState } from 'react';
import type { SmartTableColumnType } from '@/components/SmartTable/type.ts';
import SmartTable from '@/components/SmartTable';
import { FileTextOutlined } from '@ant-design/icons';
import RequestDetails from './_RequestDetails';

// HTTP方法标签
const getHttpMethodTag = (method?: string) => {
  switch (method) {
    case "GET":
      return <Tag color="green">{method}</Tag>;
    case "POST":
      return <Tag color="cyan">{method}</Tag>;
    case "PUT":
      return <Tag color="blue">{method}</Tag>;
    case "DELETE":
      return <Tag color="red">{method}</Tag>;
    case "PATCH":
      return <Tag color="magenta">{method}</Tag>;
    default:
      return <Tag>{method}</Tag>;
  }
};

// 状态码标签
const getHttpStatusCodeTag = (code: number) => {
  if (code >= 200 && code < 300)
    return <Tag color="green">{code}</Tag>;
  else if (code >= 300 && code < 400)
    return <Tag color="cyan">{code}</Tag>;
  else if (code >= 400 && code < 500)
    return <Tag color="red">{code}</Tag>;
  else if (code >= 500 && code < 600)
    return <Tag color="magenta">{code}</Tag>;
  else
    return <Tag>{code}</Tag>;
};

const RequestLogList: React.FC = () => {
  const [isOpenModal, setIsOpenModal] = useState(false);
  const [selectedLogId, setSelectedLogId] = useState<string | undefined>(undefined);
  
  // 查看详情
  const handleViewDetails = (id: string) => {
    setSelectedLogId(id);
    setIsOpenModal(true);
  };

  const columns: SmartTableColumnType[] = [
    {
      title: '请求时间',
      dataIndex: 'executionTime',
      width: 180,
    },
    {
      title: '请求地址',
      dataIndex: 'url',
      render: (_: any, record: RequestLogDto) => (
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          {getHttpStatusCodeTag(record.httpStatusCode)}
          {getHttpMethodTag(record.httpMethod)}
          <span>{record.url}</span>
        </div>
      ),
    },
    {
      title: '操作用户',
      dataIndex: 'userName',
      width: 120,
    },
    {
      title: 'IP地址',
      dataIndex: 'clientIpAddress',
      width: 120,
    },
    {
      title: '耗时',
      dataIndex: 'executionDuration',
      width: 100,
      render: (duration: number) => {
        if (duration <= 500)
          return <Tag color="green">{duration} ms</Tag>;
        else if (duration > 500 && duration <= 3000)
          return <Tag color="cyan">{duration} ms</Tag>;
        else if (duration > 3000 && duration <= 10000)
          return <Tag color="warning">{duration} ms</Tag>;
        else
          return <Tag color="magenta">{Math.floor(duration / 1000)} s</Tag>;
      },
    },
    {
      title: '应用名称',
      dataIndex: 'applicationName',
      width: 120,
    },
    {
      title: '操作',
      dataIndex: 'operate',
      width: 70,
      fixed: 'right',
      render: (_: any, record: RequestLogDto) => {
        return (
          <Button
            type="link"
            icon={<FileTextOutlined />}
            onClick={() => handleViewDetails(record.id)}
          >
            详情
          </Button>
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
          const data = await getRequestLogList(params);
          return data;
        }}
        searchItems={
          <>
            <Form.Item label="URL" name="url">
              <Input placeholder="请输入请求URL" />
            </Form.Item>
            <Form.Item label="用户" name="userName">
              <Input placeholder="请输入用户名" />
            </Form.Item>
            <Form.Item label="HTTP方法" name="httpMethod">
              <Input placeholder="请输入HTTP方法" />
            </Form.Item>
          </>
        }
        toolbar={<h5>访问审计日志列表</h5>}
      />
      
      {/* 使用详情组件 */}
      <RequestDetails 
        open={isOpenModal} 
        onClose={() => {
          setIsOpenModal(false);
          setSelectedLogId(undefined);
        }} 
        id={selectedLogId}
      />
    </>
  );
};

export default RequestLogList; 