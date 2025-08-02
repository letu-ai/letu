import { Form, Input, Modal } from 'antd';
import { forwardRef, useImperativeHandle, useState } from 'react';
import { addConfig, type ConfigDto, updateConfig } from './service';
import useApp from 'antd/es/app/useApp';
import TextArea from 'antd/es/input/TextArea';

interface ModalProps {
  refresh?: () => void;
}

export interface ModalRef {
  openModal: (row?: ConfigDto) => void;
}

const ConfigForm = forwardRef<ModalRef, ModalProps>((props, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [form] = Form.useForm();
  const [row, setRow] = useState<ConfigDto | null>();
  const { message } = useApp();

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  const openModal = (row?: ConfigDto) => {
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

  const onFinish = async (values: ConfigDto) => {
    if (row?.id) {
      await updateConfig({ ...values, id: row.id });
      handleSuccess('编辑成功');
    } else {
      await addConfig(values);
      handleSuccess('新增成功');
    }
  };

  return (
    <Modal
      title={row?.id ? '编辑配置' : '新增配置'}
      open={isOpenModal}
      onCancel={onCancel}
      onOk={onOk}
      maskClosable={false}
    >
      <Form<ConfigDto>
        name="wrap"
        labelCol={{ flex: '90px' }}
        labelWrap
        form={form}
        wrapperCol={{ flex: 1 }}
        colon={false}
        onFinish={onFinish}
      >
        <Form.Item label="组别" name="groupKey">
          <Input placeholder="组别" />
        </Form.Item>
        <Form.Item label="配置名称" name="name" rules={[{ required: true }, { max: 256 }]}>
          <Input placeholder="请输入配置名称" />
        </Form.Item>
        <Form.Item label="配置键名" name="key" rules={[{ required: true }, { max: 128 }]}>
          <Input placeholder="请输入配置键名" />
        </Form.Item>
        <Form.Item label="配置值" name="value" rules={[{ required: true }, { max: 1024 }]}>
          <Input placeholder="请输入配置值" />
        </Form.Item>
        <Form.Item label="备注" name="remark" rules={[{ max: 64 }]}>
          <TextArea placeholder="请输入备注" />
        </Form.Item>
      </Form>
    </Modal>
  );
});

export default ConfigForm;
