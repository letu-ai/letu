import { createFileRoute } from '@tanstack/react-router';
import Permission from '@/components/Permission';
import { BasisPermissions } from '@/application/permissions';
import {
    deleteDictionary,
    getDictionaryList,
    type IDictionaryOutput,
    type IDictionaryListOutput,
    deleteDictionaries,
} from './-service';
import { DeleteOutlined, EditOutlined, ExclamationCircleFilled, PlusOutlined } from '@ant-design/icons';
import { Button, Form, Input, Popconfirm, Space, Tag, Typography } from 'antd';
import { useRef, useState } from 'react';
import { Link } from '@tanstack/react-router';
import type { SmartTableRef, SmartTableColumnType } from '@/components/SmartTable/type.ts';
import SmartTable from '@/components/SmartTable';
import DictTypeForm, { type ModalRef } from './-DictionaryForm';
import ProIcon from '@/components/ProIcon';
import useApp from 'antd/es/app/useApp';
const { Paragraph } = Typography;

export const Route = createFileRoute('/admin/data-dictionaries/')({
    component: DictList
});

function DictList() {
    const tableRef = useRef<SmartTableRef>(null);
    const modalRef = useRef<ModalRef>(null);
    const { message, modal } = useApp();
    const [currentPageData, setCurrentPageData] = useState<IDictionaryListOutput[]>([]);
    const columns: SmartTableColumnType<IDictionaryListOutput>[] = [
        {
            title: '字典',
            dataIndex: 'name',
            width: 240,
            render: (text: string) => {
                return <Paragraph copyable={{ text }}><span className="font-bold">{text}</span></Paragraph>
            },
        },
        {
            title: '名称',
            dataIndex: 'displayName',
            width: 200,
        },
        {
            title: '启用',
            dataIndex: 'isEnabled',
            width: 100,
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
            title: '备注',
            dataIndex: 'remark',
        },
        {
            title: '操作',
            width: 210,
            fixed: 'right',
            render: (_: any, record: IDictionaryListOutput) => (
                <Space>
                    <Permission permissions={BasisPermissions.DataDictionary.Update}>
                        <Button
                            type="link"
                            icon={<EditOutlined />}
                            key="edit"
                            disabled={record.isStatic}
                            onClick={() => {
                                modalRef?.current?.openModal(record as IDictionaryOutput);
                            }}
                        >
                            编辑
                        </Button>
                    </Permission>
                    <Permission permissions={BasisPermissions.DataDictionary.Default}>
                        <Link to={`/admin/data-dictionaries/$name`} params={{ name: record.name }}>
                            <Button
                                type="link"
                                icon={<ProIcon icon="iconify:mi:database" />}
                                key="data"
                            >
                                数据
                            </Button>
                        </Link>
                    </Permission>
                    <Permission permissions={BasisPermissions.DataDictionary.Delete}>
                        <Popconfirm
                            key="delete"
                            title="确定删除吗？"
                            description="删除后无法撤销"
                            disabled={record.isStatic}
                            onConfirm={() => {
                                deleteDictionary(record.id).then(() => {
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

    const batchDelete = () => {
        const ids = tableRef?.current?.getSelectedKeys();
        if (!ids || !ids.length) {
            message.warning('请选择一条数据进行操作');
            return;
        }
        const selectedRows = currentPageData.filter(row => ids.includes(row.id));
        const staticRows = selectedRows.filter(row => row.isStatic);
        if (staticRows.length > 0) {
            message.warning(`选中的数据中包含${staticRows.length}条系统初始化的静态数据，不允许删除`);
            return;
        }
        modal.confirm({
            title: `确认删除选中的${ids!.length}条数据？`,
            icon: <ExclamationCircleFilled />,
            onOk() {
                deleteDictionaries(ids as string[]).then(() => {
                    message.success('删除成功');
                    tableRef?.current?.reload();
                }).catch((error) => {
                    // 后端也会验证，如果包含静态数据会返回错误
                });
            },
        });
    };

    return (
        <>
            <SmartTable
                columns={columns}
                ref={tableRef}
                rowKey="id"
                selection
                request={async (params) => {
                    const data = await getDictionaryList(params);
                    setCurrentPageData(data.items);
                    return data;
                }}
                searchItems={[
                    <Form.Item label="关键字" name="keywords">
                        <Input placeholder="请输入字典名称或者显示名称" />
                    </Form.Item>,
                ]}
                toolbar={
                    <Space size="middle">
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
                        <Permission permissions={BasisPermissions.DataDictionary.Delete}>
                            <Button color="danger" variant="solid" icon={<DeleteOutlined />} onClick={batchDelete}>
                                删除
                            </Button>
                        </Permission>
                    </Space>
                }
            />
            {/** 新增/编辑字典类型弹窗 */}
            <DictTypeForm ref={modalRef} refresh={() => tableRef?.current?.reload()} />
        </>
    );
};
