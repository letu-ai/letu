import Permission from '@/components/Permission';
import { BasisPermissions } from '@/application/permissions';
import { deletePositionGroup, getPositionGroupList, type PositionGroupListDto } from './-service';
import { DeleteOutlined, EditOutlined, ExclamationCircleFilled, PlusOutlined } from '@ant-design/icons';
import { Button, Form, Input, Popconfirm, Space } from 'antd';
import { useRef } from 'react';
import PositionGroupForm, { type ModalRef } from './-PositionGroupForm';
import SmartTable from '@/components/SmartTable';
import type { SmartTableRef, SmartTableColumnType } from '@/components/SmartTable/type';
import { App } from 'antd';
import { createFileRoute } from '@tanstack/react-router';

export const Route = createFileRoute('/admin/positions/groups')({
    component: PositionGroupList
});

function PositionGroupList() {
    const modalRef = useRef<ModalRef>(null);
    const tableRef = useRef<SmartTableRef>(null);
    const { message, modal } = App.useApp();
    const columns: SmartTableColumnType<PositionGroupListDto>[] = [
        {
            title: '职位分组名称',
            dataIndex: 'groupName',
        },
        {
            title: '备注',
            dataIndex: 'remark',
        },
        {
            title: '排序值',
            dataIndex: 'sort',
        },
        {
            title: '操作',
            dataIndex: 'option',
            width: 140,
            fixed: 'right',
            render: (_: any, record: PositionGroupListDto) => (
                <Space>
                    <Permission permissions={BasisPermissions.Position.Update}>
                        <Button
                            type="link"
                            icon={<EditOutlined />}
                            onClick={() => {
                                rowEdit(record);
                            }}
                        >
                            编辑
                        </Button>
                    </Permission>
                    <Permission permissions={BasisPermissions.Position.Delete}>
                        <Popconfirm
                            title="确定删除吗？"
                            description="删除后无法撤销"
                            onConfirm={() => {
                                rowDelete(record.id);
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
    const handleOpenModal = () => {
        if (modalRef.current) {
            modalRef.current.openModal();
        }
    };

    const rowDelete = (id: string) => {
        modal.confirm({
            title: '确认删除？',
            icon: <ExclamationCircleFilled />,
            onOk() {
                deletePositionGroup(id).then(() => {
                    message.success('删除成功');
                    tableRef?.current?.reload();
                });
            },
        });
    };
    const rowEdit = (record: PositionGroupListDto) => {
        modalRef.current?.openModal(record);
    };

    return (
        <>
            <SmartTable
                ref={tableRef}
                columns={columns}
                rowKey="id"
                request={async (params) => {
                    const data = await getPositionGroupList(params);
                    return {
                        items: data,
                        totalCount: data.length,
                    };
                }}
                searchItems={
                    <Form.Item label="职位分组名称" name="groupName">
                        <Input placeholder="请输入职位分组名称" />
                    </Form.Item>
                }
                toolbar={
                    <>
                        <Permission permissions={BasisPermissions.Position.Create}>
                            <Button color="primary" variant="solid" icon={<PlusOutlined />} onClick={() => handleOpenModal()}>
                                新增
                            </Button>
                        </Permission>
                    </>
                }
            />
            {/* 职位分组新增/编辑弹窗 */}
            <PositionGroupForm ref={modalRef} refresh={() => tableRef?.current?.reload()} />
        </>
    );
}