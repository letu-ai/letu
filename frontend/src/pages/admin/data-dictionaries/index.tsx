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
import { useRef } from 'react';
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
    const columns: SmartTableColumnType<IDictionaryListOutput>[] = [
        {
            title: '字典',
            dataIndex: 'displayName',
            width: 200,
        },
        {
            title: '名称',
            dataIndex: 'name',
            width: 200,
            render: (text: string) => {
                return <Paragraph copyable={{ text }}><Tag>{text}</Tag></Paragraph>
            },
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
                            onConfirm={() => {
                                deleteDictionary(record.id).then(() => {
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

    const batchDelete = () => {
        const ids = tableRef?.current?.getSelectedKeys();
        if (!ids || !ids.length) {
            message.warning('请选择一条数据进行操作');
            return;
        }
        modal.confirm({
            title: `确认删除选中的${ids!.length}条数据？`,
            icon: <ExclamationCircleFilled />,
            onOk() {
                deleteDictionaries(ids as string[]).then(() => {
                    message.success('删除成功');
                    tableRef?.current?.reload();
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
