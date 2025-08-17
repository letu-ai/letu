import { Space, Form, Input, Button } from 'antd';
import { useRef, useState } from 'react';
import { PlusOutlined, ExclamationCircleFilled, EditOutlined, DeleteOutlined, SettingOutlined } from '@ant-design/icons';
import dayjs from 'dayjs';
import { deleteEdition, getEditionList, type EditionListOutput } from './service';
import EditionForm, { type ModalRef } from './_EditionForm';
import FeatureEditor from '@/pages/admin/components/FeatureEditor';
import SmartTable from '@/components/SmartTable';
import type { SmartTableColumnType, SmartTableRef } from '@/components/SmartTable/type.ts';
import useApp from 'antd/es/app/useApp';

const Edition = () => {
    const modalRef = useRef<ModalRef>(null);
    const tableRef = useRef<SmartTableRef>(null);
    const { message, modal } = useApp();
    const [featureEditorVisible, setFeatureEditorVisible] = useState(false);
    const [currentEditionId, setCurrentEditionId] = useState<string | null>(null);

    const columns: SmartTableColumnType[] = [
        {
            title: '版本名称',
            dataIndex: 'name',
            key: 'name',
        },
        {
            title: '描述',
            dataIndex: 'description',
            key: 'description',
            width: '40%',
            ellipsis: true,
        },
        {
            title: '租户数量',
            dataIndex: 'tenantCount',
            key: 'tenantCount',
        },
        {
            title: '创建时间',
            dataIndex: 'creationTime',
            key: 'creationTime',
            render: (creationTime: string) => {
                return dayjs(creationTime).format('YYYY-MM-DD');
            }
        },
        {
            title: '操作',
            key: 'action',
            width: 150,
            fixed: 'right',
            render: (_: any, record: EditionListOutput) => {
                return (
                    <Space>
                        <Button type="link" icon={<SettingOutlined />} onClick={() => rowSetFeature(record.id)}>
                            功能
                        </Button>
                        <Button type="link" icon={<EditOutlined />} onClick={() => rowEdit(record)}>
                            编辑
                        </Button>
                        <Button type="link" icon={<DeleteOutlined />} danger onClick={() => rowDelete(record.id)}>
                            删除
                        </Button>

                    </Space>
                );
            },
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
            content: '删除版本可能会影响关联的租户，确认删除？',
            onOk() {
                deleteEdition(id).then(() => {
                    message.success('删除成功');
                    tableRef?.current?.reload();
                });
            },
        });
    };

    const rowEdit = (record: EditionListOutput) => {
        modalRef.current?.openModal(record);
    };

    const rowSetFeature = (editionId: string) => {
        setCurrentEditionId(editionId);
        setFeatureEditorVisible(true);
    };

    return (
        <>
            <SmartTable
                ref={tableRef}
                rowKey="id"
                columns={columns}
                request={async (params) => {
                    const data = await getEditionList(params);
                    return data;
                }}
                searchItems={
                    <>
                        <Form.Item label="版本名称" name="name">
                            <Input placeholder="请输入版本名称" />
                        </Form.Item>
                    </>
                }
                toolbar={
                    <Button color="primary" variant="solid" icon={<PlusOutlined />} onClick={() => handleOpenModal()}>
                        新增
                    </Button>
                }
            />
            {/* 版本新增/编辑弹窗 */}
            <EditionForm ref={modalRef} refresh={() => tableRef?.current?.reload()} />
            
            {/* 功能编辑器 */}
            {featureEditorVisible && currentEditionId && (
                <FeatureEditor
                    providerName="E"
                    providerKey={currentEditionId}
                    onClose={() => {
                        setFeatureEditorVisible(false);
                        setCurrentEditionId(null);
                    }}
                />
            )}
        </>
    );
};

export default Edition; 