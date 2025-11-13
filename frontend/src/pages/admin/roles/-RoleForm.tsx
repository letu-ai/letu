import { Form, Input, Modal, Switch } from 'antd';
import { forwardRef, useImperativeHandle, useState } from 'react';
import { addRole, type RoleCreateOrUpDateInput, type RoleListOutput, updateRole } from './-service';
import { App } from 'antd';

interface ModalProps {
    refresh?: () => void;
}

export interface ModalRef {
    openModal: (row?: RoleListOutput) => void;
}

const RoleForm = forwardRef<ModalRef, ModalProps>((props, ref) => {
    const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
    const [form] = Form.useForm();
    const [row, setRow] = useState<RoleListOutput | null>();
    const { message } = App.useApp();

    useImperativeHandle(ref, () => ({
        openModal,
    }));

    const openModal = (row?: RoleListOutput) => {
        setIsOpenModal(true);
        if (row) {
            setRow(row);
            form.setFieldsValue(row);
        } else {
            setRow(null);
            form.resetFields();
            form.setFieldValue('isEnabled', true);
            form.setFieldValue('isDefault', false);
            form.setFieldValue('isPublic', true);
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

    const onFinish = async (values: RoleCreateOrUpDateInput) => {
        if (row?.id) {
            await updateRole(row.id, values);
            handleSuccess('编辑成功');
        } else {
            await addRole(values);
            handleSuccess('新增成功');
        }
    };

    return (
        <Modal
            title={row?.id ? '编辑角色' : '新增角色'}
            open={isOpenModal}
            onCancel={onCancel}
            onOk={onOk}
            maskClosable={false}
        >
            <Form<RoleCreateOrUpDateInput>
                name="wrap"
                labelCol={{ flex: '80px' }}
                labelWrap
                form={form}
                wrapperCol={{ flex: 1 }}
                colon={false}
                onFinish={onFinish}
            >
                <Form.Item label="角色名" name="name" rules={[{ required: true }, { max: 64 }]}>
                    <Input placeholder="请输入角色名" />
                </Form.Item>

                <Form.Item label="启用" name="isEnabled"
                    valuePropName="checked"
                >
                    <Switch />
                </Form.Item>

                <Form.Item label="默认角色" name="isDefault"
                    valuePropName="checked"
                    extra="新建用户默认分配的角色"
                >
                    <Switch />
                </Form.Item>

                <Form.Item label="公共角色" name="isPublic"
                    valuePropName="checked"
                    extra="会展示给用户看的角色"
                >
                    <Switch />
                </Form.Item>

                <Form.Item label="备注" name="remark" rules={[{ max: 512 }]}>
                    <Input allowClear />
                </Form.Item>
            </Form>
        </Modal>
    );
});

export default RoleForm;
