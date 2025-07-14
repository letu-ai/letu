import Permission from '@/components/Permission';
import { DeleteOutlined, EditOutlined, PlusOutlined, UserAddOutlined } from '@ant-design/icons';
import { Button, Form, Input, Popconfirm, Space, Tag } from 'antd';
import React, { useRef } from 'react';
import { deleteEmployee, getEmployeePagedList, type EmployeeListDto } from '@/api/organization/employee';
import SmartTable from '@/components/SmartTable';
import EmployeeForm, { type EmployeeModalRef } from '@/pages/org/components/EmployeeForm.tsx';
import type { SmartTableRef, SmartTableColumnType } from '@/components/SmartTable/type.ts';
import BindUserForm, { type BindUserFormRef } from '@/pages/org/components/BindUserForm.tsx';
import useApp from 'antd/es/app/useApp';

const EmployeeList: React.FC = () => {
  const tableRef = useRef<SmartTableRef>(null);
  const modalRef = useRef<EmployeeModalRef>(null);
  const bindUserModalRef = useRef<BindUserFormRef>(null);
  const { message } = useApp();
  const columns: SmartTableColumnType[] = [
    {
      title: '员工姓名',
      dataIndex: 'name',
    },
    {
      title: '工号',
      dataIndex: 'code',
    },
    {
      title: '性别',
      dataIndex: 'sex',
      render: (text: number) => {
        if (text === 1) return '男';
        return '女';
      },
    },
    {
      title: '电话',
      dataIndex: 'phone',
    },
    {
      title: '状态',
      dataIndex: 'status',
      render: (text: number) => {
        if (text === 1) return <Tag color="green">正常</Tag>;
        return <Tag color="red">离职</Tag>;
      },
    },
    {
      title: '操作',
      dataIndex: 'option',
      fixed: 'right',
      width: 210,
      render: (_: any, record: EmployeeListDto) => (
        <Space>
          <Permission permissions={'Org.Employee.Update'}>
            <Button
              type="link"
              icon={<EditOutlined />}
              key="edit"
              onClick={() => {
                modalRef?.current?.openModal(record);
              }}
            >
              编辑
            </Button>
          </Permission>
          <Permission permissions={'Org.Employee.BindUser'}>
            <Button
              type="link"
              icon={<UserAddOutlined />}
              onClick={() => {
                bindUserModalRef?.current?.openModal(record);
              }}
            >
              绑定用户
            </Button>
          </Permission>
          <Permission permissions={'Org.Employee.Delete'}>
            <Popconfirm
              key="delete"
              title="确定删除吗？"
              description="删除后无法撤销"
              onConfirm={() => {
                deleteEmployee(record.id!).then(() => {
                  message.success('删除成功');
                  tableRef.current?.reload();
                });
              }}
            >
              <Button type="link" danger icon={<DeleteOutlined />}>
                删除
              </Button>
            </Popconfirm>
          </Permission>
        </Space>
      ),
    },
  ];

  return (
    <>
      <SmartTable
        columns={columns}
        rowKey="id"
        ref={tableRef}
        request={async (params) => {
          const { data } = await getEmployeePagedList(params);
          return data;
        }}
        searchItems={[
          <Form.Item label="关键词" name="keyword">
            <Input placeholder="请输入姓名/手机号/工号" />
          </Form.Item>,
        ]}
        toolbar={
          <Permission permissions={'Org.Employee.Add'}>
            <Button
              color="primary"
              variant="solid"
              icon={<PlusOutlined />}
              onClick={() => {
                modalRef?.current?.openModal();
              }}
            >
              新增
            </Button>
          </Permission>
        }
      />
      {/* 新增/编辑员工弹窗 */}
      <EmployeeForm ref={modalRef} refresh={() => tableRef?.current?.reload()} />
      {/* 绑定用户弹窗 */}
      <BindUserForm ref={bindUserModalRef} refresh={() => tableRef?.current?.reload()} />
    </>
  );
};

export default EmployeeList;
