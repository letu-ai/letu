import { type EntityChangeLogDto, getEntityChangeLogList } from '../service';
import { Button, Form, Input, Select, Tag } from 'antd';
import React from 'react';
import type { SmartTableColumnType } from '@/components/SmartTable/type.ts';
import SmartTable from '@/components/SmartTable';
import { FileTextOutlined } from '@ant-design/icons';
import { useNavigate } from 'react-router-dom';

// 变更类型标签
const getChangeTypeTag = (type: number) => {
  switch (type) {
    case 0:
      return <Tag color="success">新增</Tag>;
    case 1:
      return <Tag color="processing">修改</Tag>;
    case 2:
      return <Tag color="error">删除</Tag>;
    default:
      return <Tag>未知</Tag>;
  }
};

// 获取实体类型显示名称
const getEntityTypeDisplayName = (fullName: string) => {
  if (!fullName) return '';
  
  // 简化显示，去掉命名空间
  const parts = fullName.split('.');
  return parts[parts.length - 1];
};

const EntityChangeLogList: React.FC = () => {
  const navigate = useNavigate();
  
  // 查看详情
  const handleViewDetails = (id: string) => {
    navigate(`/admin/loggings/auditlog/entity/${id}`);
  };

  const columns: SmartTableColumnType[] = [
    {
      title: '变更时间',
      dataIndex: 'changeTime',
      width: 180,
    },
    {
      title: '变更类型',
      dataIndex: 'changeType',
      width: 100,
      render: (type: number) => getChangeTypeTag(type),
    },
    {
      title: '实体类型',
      dataIndex: 'entityTypeFullName',
      render: (text: string) => getEntityTypeDisplayName(text),
    },
    {
      title: '实体ID',
      dataIndex: 'entityId',
      width: 280,
      ellipsis: true,
    },
    {
      title: '操作用户',
      dataIndex: 'userName',
      width: 120,
    },
    {
      title: '操作',
      dataIndex: 'operate',
      width: 70,
      fixed: 'right',
      render: (_: any, record: EntityChangeLogDto) => {
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

  const changeTypeOptions = [
    { label: '新增', value: 0 },
    { label: '修改', value: 1 },
    { label: '删除', value: 2 },
  ];

  return (
    <SmartTable
      columns={columns}
      rowKey="id"
      request={async (params) => {
        const data = await getEntityChangeLogList(params);
        return data;
      }}
      searchItems={
        <>
          <Form.Item label="实体类型" name="entityTypeFullName">
            <Input placeholder="请输入实体类型" />
          </Form.Item>
          <Form.Item label="实体ID" name="entityId">
            <Input placeholder="请输入实体ID" />
          </Form.Item>
          <Form.Item label="变更类型" name="changeType">
            <Select
              placeholder="请选择变更类型"
              allowClear
              options={changeTypeOptions}
            />
          </Form.Item>
          <Form.Item label="用户" name="userName">
            <Input placeholder="请输入用户名" />
          </Form.Item>
        </>
      }
      toolbar={<h5>数据变更审计日志列表</h5>}
    />
  );
};

export default EntityChangeLogList; 