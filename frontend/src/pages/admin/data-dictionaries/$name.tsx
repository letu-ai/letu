import Permission from '@/components/Permission';
import { BasisPermissions } from '@/application/permissions';
import { deleteDictionaryItem, getDictionaryItemList, type IDictionaryItemOutput, type IDictionaryItemListOutput } from './-service';
import { ArrowLeftOutlined, CopyOutlined, DeleteOutlined, EditOutlined, PlusOutlined } from '@ant-design/icons';
import { Button, Form, Input, Popconfirm, Space, Tag } from 'antd';
import { useRef } from 'react';
import type { SmartTableRef, SmartTableColumnType } from '@/components/SmartTable/type.ts';
import ItemForm, { type ModalRef } from './-ItemForm';
import SmartTable from '@/components/SmartTable';
import useApp from 'antd/es/app/useApp';
import { Link } from '@tanstack/react-router';
import { createFileRoute } from '@tanstack/react-router';

export const Route = createFileRoute('/admin/data-dictionaries/$name')({
    component: DictionaryDetails
});

function DictionaryDetails() {
    const tableRef = useRef<SmartTableRef>(null);
    const modalRef = useRef<ModalRef>(null);
    const { message } = useApp();
    const columns: SmartTableColumnType<IDictionaryItemListOutput>[] = [
        {
            title: '字典项',
            dataIndex: 'label',
        },
        {
            title: '值',
            dataIndex: 'value',
            render: (text: string) => {
                return <Tag color="blue" className="font-bold">{text}</Tag>
            },

        },
        {
            title: '显示顺序',
            dataIndex: 'sort',
            render: (text: number) => {
                return <span className="text-muted">{text}</span>;
            },
        },
        {
            title: '备注',
            dataIndex: 'remark',
        },
        {
            title: '启用',
            dataIndex: 'isEnabled',
            render: (text: boolean) => {
                return <Tag color={text ? 'success' : 'error'}>{text ? '启用' : '禁用'}</Tag>;
            },
        },
        {
            title: '静态',
            dataIndex: 'isStatic',
            width: 80,
            render: (text: boolean) => {
                return text ? <Tag color="warning">静态</Tag> : null;
            },
        },
        {
            title: '操作',
            width: 210,
            fixed: 'right',
            render: (_: any, record: IDictionaryItemListOutput) => (
                <Space>
                    <Permission permissions={BasisPermissions.DataDictionary.Update}>
                        <Button
                            type="link"
                            icon={<EditOutlined />}
                            key="edit"
                            disabled={record.isStatic}
                            onClick={() => {
                                modalRef?.current?.openModal(record);
                            }}
                        >
                            编辑
                        </Button>
                    </Permission>
                    <Permission permissions={BasisPermissions.DataDictionary.Update}>
                        <Button
                            key="copy"
                            type="link"
                            icon={<CopyOutlined />}
                            disabled={record.isStatic}
                            onClick={() => {
                                const row = record as IDictionaryItemOutput;
                                row.id = undefined;
                                modalRef?.current?.openModal(record);
                            }}
                        >
                            复制
                        </Button>
                    </Permission>
                    <Permission permissions={BasisPermissions.DataDictionary.Delete}>
                        <Popconfirm
                            key="delete"
                            title="确定删除吗？"
                            description="删除后无法撤销"
                            disabled={record.isStatic}
                            onConfirm={() => {
                                deleteDictionaryItem(name, [record.id!]).then(() => {
                                    message.success('删除成功');
                                    tableRef.current?.reload();
                                });
                            }}
                        >
                            <Button type="link" danger icon={<DeleteOutlined />} disabled={record.isStatic}>
                                删除
                            </Button>
                        </Popconfirm>
                    </Permission>
                </Space>
            ),
        },
    ];
    const { name } = Route.useParams();

    return (
        <>
            <SmartTable
                columns={columns}
                rowKey="id"
                ref={tableRef}
                request={async (params) => {
                    const data = await getDictionaryItemList(name, { ...params });
                    return data;
                }}
                searchItems={[
                    <Form.Item label="关键字" name="keywords">
                        <Input placeholder="搜索字典项名称或者值" />
                    </Form.Item>,
                ]}
                toolbar={
                    <Space size="middle">
                        <Link to={`/admin/data-dictionaries`}>
                            <Button type="link" icon={<ArrowLeftOutlined />}>
                                返回
                            </Button>
                        </Link>
                        <Permission permissions={BasisPermissions.DataDictionary.Create}>
                            <Button
                                type="primary"
                                key="primary"
                                onClick={() => {
                                    modalRef?.current?.openModal();
                                }}
                            >
                                <PlusOutlined /> 新增
                            </Button>
                        </Permission>
                    </Space>
                }
            />
            {/* 新增/编辑字典数据弹窗 */}
            <ItemForm ref={modalRef} refresh={() => tableRef?.current?.reload()} />
        </>
    );
}

