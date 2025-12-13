import { Form, Input, Modal, ColorPicker } from 'antd';
import { forwardRef, useImperativeHandle, useState } from 'react';
import { createUserTag, updateUserTag, type UserTagListOutput } from './-service';
import useApp from 'antd/es/app/useApp';
import type { Color } from 'antd/es/color-picker';

interface ModalProps {
    refresh?: () => void;
}

export interface ModalRef {
    openModal: (row?: UserTagListOutput) => void;
}

const UserTagModal = forwardRef<ModalRef, ModalProps>((props, ref) => {
    const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
    const [form] = Form.useForm();
    const { message } = useApp();
    const [row, setRow] = useState<UserTagListOutput | null>();

    const openModal = (row?: UserTagListOutput) => {
        setIsOpenModal(true);
        if (row) {
            setRow(row);
            form.setFieldsValue({
                name: row.name,
                color: row.color || '#1890ff',
            });
        } else {
            setRow(null);
            form.resetFields();
            form.setFieldsValue({ color: '#1890ff' });
        }
    };

    useImperativeHandle(ref, () => ({
        openModal,
    }));

    const onCancel = () => {
        form.resetFields();
        setIsOpenModal(false);
    };

    const onOk = () => {
        form.submit();
    };

    const onFinish = async (values: { name: string; color: Color | string }) => {
        const isEdit = !!row?.id;

        // 处理颜色值
        const colorValue = typeof values.color === 'string'
            ? values.color
            : values.color?.toHexString?.() || '#1890ff';

        try {
            if (isEdit && row?.id) {
                await updateUserTag(row.id, {
                    name: values.name,
                    color: colorValue,
                });
                message.success('编辑成功');
            } else {
                await createUserTag({
                    name: values.name,
                    color: colorValue,
                });
                message.success('新增成功');
            }
            setIsOpenModal(false);
            form.resetFields();
            props?.refresh?.();
        } catch (error) {
            console.error('操作失败:', error);
        }
    };

    const isEdit = !!row?.id;

    return (
        <Modal
            title={isEdit ? `编辑标签 ${row?.name}` : "新增标签"}
            open={isOpenModal}
            onCancel={onCancel}
            onOk={onOk}
            maskClosable={false}
        >
            <Form
                name="userTagModal"
                labelWrap
                form={form}
                colon={false}
                onFinish={onFinish}
                initialValues={{ color: '#1890ff' }}
            >
                <Form.Item label="名称" name="name"
                    rules={[
                        { required: true, message: '请输入名称' },
                        { max: 32, message: '名称最长32个字符' }
                    ]}>
                    <Input />
                </Form.Item>
                <Form.Item label="颜色" name="color"
                    rules={[
                        { required: true, message: '请选择颜色' },
                    ]}>
                    <ColorPicker
                        showText
                        presets={[
                            {
                                label: '推荐',
                                colors: [
                                    '#1890ff',
                                    '#52c41a',
                                    '#faad14',
                                    '#f5222d',
                                    '#722ed1',
                                    '#13c2c2',
                                    '#eb2f96',
                                    '#fa8c16',
                                ],
                            },
                        ]}
                    />
                </Form.Item>
            </Form>
        </Modal>
    );
});

export default UserTagModal;