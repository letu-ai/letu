import { Form, Input, InputNumber, Modal, Switch } from 'antd';
import { forwardRef, useImperativeHandle, useState } from 'react';
import { addDictionaryItem, type IDictionaryItemCreateOrUpdateInput, type IDictionaryItemOutput, updateDictionaryItem } from './-service';
import { useParams } from '@tanstack/react-router';
import useApp from 'antd/es/app/useApp';
import TextArea from 'antd/es/input/TextArea';

interface ModalProps {
    refresh?: () => void;
}

export interface ModalRef {
    openModal: (row?: IDictionaryItemOutput) => void;
}

const ItemForm = forwardRef<ModalRef, ModalProps>((props, ref) => {
    const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
    const [form] = Form.useForm();
    const [row, setRow] = useState<IDictionaryItemOutput | null>();
    const { name } = useParams({ strict: false });
    const { message } = useApp();

    useImperativeHandle(ref, () => ({
        openModal,
    }));

    const openModal = (row?: IDictionaryItemOutput) => {
        setIsOpenModal(true);
        if (row) {
            setRow(row);
            form.setFieldsValue(row);
        } else {
            setRow(null);
            form.resetFields();
            form.setFieldValue('isEnabled', true);
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

    const onFinish = async (values: IDictionaryItemCreateOrUpdateInput) => {
        if (!name) {
            message.error('字典项名称不能为空');
            return;
        }

        values.dictionaryName = name;

        if (row?.id) {
            await updateDictionaryItem(name, row.id, values);
            handleSuccess('编辑成功');
        } else {
            await addDictionaryItem(name, values);
            handleSuccess('新增成功');
        }
    };

    return (
        <Modal
            title={row?.id ? '编辑字典项' : '新增字典项'}
            open={isOpenModal}
            onCancel={onCancel}
            onOk={onOk}
            maskClosable={false}
        >
            <Form<IDictionaryItemCreateOrUpdateInput>
                name="wrap"
                labelCol={{ flex: '90px' }}
                labelWrap
                form={form}
                wrapperCol={{ flex: 1 }}
                colon={false}
                onFinish={onFinish}
            >
                <Form.Item label="显示名称" name="label" rules={[{ required: true }, { max: 128 }]}>
                    <Input />
                </Form.Item>
                <Form.Item label="值" name="value" rules={[{ required: true }, { max: 256 }]}>
                    <Input />
                </Form.Item>
                <Form.Item label="启用" name="isEnabled">
                    <Switch />
                </Form.Item>
                <Form.Item label="显示排序" name="sort" rules={[{ required: true }]}>
                    <InputNumber min={1} max={999} />
                </Form.Item>
                <Form.Item label="备注" name="remark" rules={[{ max: 512 }]}>
                    <TextArea />
                </Form.Item>
            </Form>
        </Modal>
    );
});

export default ItemForm;
