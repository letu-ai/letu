import { Form, Input, Modal, Switch, App } from 'antd';
import { forwardRef, useImperativeHandle, useState } from 'react';
import { addDictionary, type IDictionaryOutput, updateDictionary } from './-service';

interface ModalProps {
    refresh?: () => void;
}

export interface ModalRef {
    openModal: (row?: IDictionaryOutput) => void;
}

const DictTypeForm = forwardRef<ModalRef, ModalProps>((props, ref) => {
    const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
    const [form] = Form.useForm();
    const [row, setRow] = useState<IDictionaryOutput | null>();
    const { message } = App.useApp();

    useImperativeHandle(ref, () => ({
        openModal,
    }));

    const openModal = (row?: IDictionaryOutput) => {
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

    const onFinish = async (values: IDictionaryOutput) => {
        if (row?.id) {
            await updateDictionary(row.id, values);
            handleSuccess('编辑成功');
        } else {
            await addDictionary(values);
            handleSuccess('新增成功');
        }
    };

    return (
        <Modal
            title={row?.id ? '编辑字典' : '新增字典'}
            open={isOpenModal}
            onCancel={onCancel}
            onOk={onOk}
            maskClosable={false}
        >
            <Form<IDictionaryOutput>
                name="wrap"
                labelCol={{ flex: '90px' }}
                labelWrap
                form={form}
                wrapperCol={{ flex: 1 }}
                colon={false}
                onFinish={onFinish}
            >
                <Form.Item label="显示名称" name="displayName"
                    rules={[{ required: true }, { max: 128 }]}
                >
                    <Input />
                </Form.Item>
                <Form.Item label="名称" name="name"
                    required
                    rules={[
                        { required: true },
                        { max: 128 },
                        { pattern: /^[a-zA-Z0-9]+$/, message: '只能包含字母和数字' },
                    ]}
                    help="只能包含字母和数字"
                >
                    <Input />
                </Form.Item>
                <Form.Item label="启用" name="isEnabled" valuePropName="checked">
                    <Switch />
                </Form.Item>
                <Form.Item label="备注" name="remark" rules={[{ max: 512 }]}>
                    <Input />
                </Form.Item>
            </Form>
        </Modal>
    );
});

export default DictTypeForm;
