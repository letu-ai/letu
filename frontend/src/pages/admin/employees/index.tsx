import { createFileRoute } from '@tanstack/react-router';
import Permission from '@/components/Permission';
import { BasisPermissions } from '@/application/permissions';
import { DeleteOutlined, EditOutlined, PlusOutlined } from '@ant-design/icons';
import { Button, Form, Input, Popconfirm, Space, Tag } from 'antd';
import { useRef } from 'react';
import { deleteEmployee, getEmployeePagedList, type EmployeeListDto } from './-service';
import SmartTable from '@/components/SmartTable';
import EmployeeForm, { type IEmployeeFormRef } from './-EmployeeForm';
import type { SmartTableRef, SmartTableColumnType } from '@/components/SmartTable/type.ts';
import { App } from 'antd';


export const Route = createFileRoute('/admin/employees/')({
    component: EmployeeList
});

function EmployeeList() {
    const tableRef = useRef<SmartTableRef>(null);
    const modalRef = useRef<IEmployeeFormRef>(null);
    const { message } = App.useApp();
    const columns: SmartTableColumnType<EmployeeListDto>[] = [
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
            width: 150,
            render: (_: any, record: EmployeeListDto) => (
                <Space>
                    <Permission permissions={BasisPermissions.OrganizationUnit.Update}>
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
                    <Permission permissions={BasisPermissions.OrganizationUnit.Delete}>
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
                    const data = await getEmployeePagedList(params);
                    return data;
                }}
                searchItems={[
                    <Form.Item key="keyword" label="关键词" name="keyword">
                        <Input placeholder="请输入姓名/工号" />
                    </Form.Item>,
                ]}
                toolbar={
                    <>
                        <Permission permissions={BasisPermissions.OrganizationUnit.Create}>
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
                    </>
                }
            />
            {/* 新增/编辑员工弹窗 */}
            <EmployeeForm ref={modalRef} refresh={() => tableRef?.current?.reload()} />
        </>
    );
}
