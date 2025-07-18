import { readed, getMyNotificationList, type MyNotificationListDto } from '@/api/organization/myNotification.ts';
import { DeleteOutlined } from '@ant-design/icons';
import { Button, Form, Input, Select, Space, Tag } from 'antd';
import React, { useRef } from 'react';
import type { SmartTableRef, SmartTableColumnType } from '@/components/SmartTable/type.ts';
import SmartTable from '@/components/SmartTable';
import useApp from 'antd/es/app/useApp';
import { ErrorCode } from '@/utils/globalValue';

const NotificationList: React.FC = () => {
  const tableRef = useRef<SmartTableRef>(null);
  const { message } = useApp();
  const columns: SmartTableColumnType[] = [
    {
      title: '通知标题',
      dataIndex: 'title',
    },
    {
      title: '通知描述',
      dataIndex: 'description',
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
    },
    {
      title: '操作',
      dataIndex: 'option',
      width: 210,
      fixed: 'right',
      render: (_: any, record: MyNotificationListDto) => (
        <Space>
          <Button
            type="link"
            danger
            icon={<DeleteOutlined />}
            onClick={() => {
              readed([record.id]).then((res) => {
                if (res.code === ErrorCode.Success) {
                  message.success('已读成功');
                }
              });
            }}
          >
            删除
          </Button>
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
          const { data } = await getMyNotificationList(params);
          return data;
        }}
        searchItems={[
          <Form.Item label="通知标题" name="title">
            <Input placeholder="请输入通知标题" />
          </Form.Item>,
          <Form.Item label="通知状态" name="isReaded">
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
      />
    </>
  );
};

export default NotificationList;
