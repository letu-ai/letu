import { Form, Input, InputNumber, Modal, TreeSelect } from 'antd';
import { forwardRef, useEffect, useImperativeHandle, useState } from 'react';
import {
    addPositionGroup,
    getPositionGroupList,
    type PositionGroupDto,
    type PositionGroupListDto,
    updatePositionGroup,
} from './service';
import useApp from 'antd/es/app/useApp';
import TextArea from 'antd/es/input/TextArea';

interface ModalProps {
    refresh?: () => void;
}

export interface ModalRef {
    openModal: (row?: PositionGroupDto) => void;
}

const RoleForm = forwardRef<ModalRef, ModalProps>((props, ref) => {
    const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
    const [form] = Form.useForm();
    const [row, setRow] = useState<PositionGroupDto | null>();
    const [treeData, setTreeData] = useState<PositionGroupListDto[]>([]);
    const { message } = useApp();

    useImperativeHandle(ref, () => ({
        openModal,
    }));

    useEffect(() => {
        if (isOpenModal) {
            fetchTreeData();
        }
    }, [isOpenModal]);

    const fetchTreeData = async (groupName?: string) => {
        const data = await getPositionGroupList({ groupName });
        setTreeData(data);
    };

    const openModal = (row?: PositionGroupDto) => {
        setIsOpenModal(true);
        if (row) {
            setRow(row);
            form.setFieldsValue(row);
        } else {
            setRow(null);
            form.resetFields();
        }
    };

    const onCancel = () => {
        form.resetFields();
        setIsOpenModal(false);
    };

    const onOk = () => {
        form.submit();
    };

    const handleSuccess = (successMessage: string) => {
        message.success(successMessage);
        setIsOpenModal(false);
        form.resetFields();
        props?.refresh?.();
    };

    const onFinish = async (values: PositionGroupDto) => {
        if (row?.id) {
            await updatePositionGroup(row.id!, values);
            handleSuccess('编辑成功');
        } else {
            await addPositionGroup(values);
            handleSuccess('新增成功');
        }
    };

    return (
        <Modal
            title={row?.id ? '编辑职位分组' : '新增职位分组'}
            open={isOpenModal}
            onCancel={onCancel}
            onOk={onOk}
            maskClosable={false}
        >
            <Form<PositionGroupDto>
                name="wrap"
                labelCol={{ flex: '90px' }}
                labelWrap
                form={form}
                wrapperCol={{ flex: 1 }}
                colon={false}
                onFinish={onFinish}
            >
                <Form.Item label="分组名称" name="groupName" rules={[{ required: true }, { max: 64 }]}>
                    <Input placeholder="请输入分组名称" />
                </Form.Item>
                <Form.Item label="上级分组" name="parentId">
                    <TreeSelect
                        showSearch
                        style={{ width: '100%' }}
                        styles={{
                            popup: {
                                root: { maxHeight: 400, overflow: 'auto' },
                            },
                        }}
                        placeholder="请选择上级分组"
                        allowClear
                        treeDefaultExpandAll
                        treeData={treeData}
                        fieldNames={{
                            label: 'groupName',
                            value: 'id',
                            children: 'children',
                        }}
                        filterTreeNode={false}
                        onSearch={async (value) => {
                            await fetchTreeData(value ? value : undefined);
                        }}
                    />
                </Form.Item>
                <Form.Item label="显示排序" name="sort">
                    <InputNumber min={1} max={999} placeholder="排序值" />
                </Form.Item>
                <Form.Item label="备注" name="remark" rules={[{ max: 500 }]}>
                    <TextArea placeholder="请输入备注" />
                </Form.Item>
            </Form>
        </Modal>
    );
});

export default RoleForm;
