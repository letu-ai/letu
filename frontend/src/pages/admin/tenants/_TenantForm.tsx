import { Form, Input, Modal } from 'antd';
import { forwardRef, useImperativeHandle, useState } from 'react';
import { addTenant, type TenantDto, updateTenant } from './service';
import useApp from 'antd/es/app/useApp';

interface ModalProps {
  refresh?: () => void;
}

export interface ModalRef {
  openModal: (row?: TenantDto) => void;
}

const TenantForm = forwardRef<ModalRef, ModalProps>((props, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [form] = Form.useForm();
  const [row, setRow] = useState<TenantDto | null>();
  const { message } = useApp();

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  const openModal = (row?: TenantDto) => {
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

  const onFinish = async (values: TenantDto) => {
    if (row?.id) {
      await updateTenant(row.id, values);
      handleSuccess('编辑成功');
    } else {
      await addTenant(values);
      handleSuccess('新增成功');
    }
  };

  return (
    <Modal
      title={row?.id ? '编辑租户' : '新增租户'}
      open={isOpenModal}
      onCancel={onCancel}
      onOk={onOk}
      maskClosable={false}
    >
      <Form<TenantDto>
        name="wrap"
        labelCol={{ flex: '90px' }}
        labelWrap
        form={form}
        wrapperCol={{ flex: 1 }}
        colon={false}
        onFinish={onFinish}
      >
        <Form.Item label="租户名称" name="name" rules={[{ required: true }, { max: 64 }]}>
          <Input placeholder="请输入租户名称" />
        </Form.Item>
        <Form.Item label="租户标识" name="tenantId" rules={[{ required: true }, { max: 18 }]}>
          <Input placeholder="请输入租户标识" />
        </Form.Item>
        <Form.Item label="绑定域名" name="domain" rules={[{ max: 256 }]}>
          <Input placeholder="请输入绑定域名" />
        </Form.Item>
        <Form.Item label="备注" name="remark" rules={[{ max: 512 }]}>
          <Input placeholder="请输入备注" />
        </Form.Item>
      </Form>
    </Modal>
  );
});

export default TenantForm;
