import { Form, Input, Modal, Switch } from 'antd';
import { forwardRef, useImperativeHandle, useState } from 'react';
import { addScheduledTask, type ScheduledTaskDto, updateScheduledTask } from './service';
import useApp from 'antd/es/app/useApp';

interface ModalProps {
  refresh?: () => void;
}

export interface ModalRef {
  openModal: (row?: ScheduledTaskDto) => void;
}

const ScheduledTaskForm = forwardRef<ModalRef, ModalProps>((props, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [form] = Form.useForm();
  const [row, setRow] = useState<ScheduledTaskDto | null>();
  const { message } = useApp();

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  const openModal = (row?: ScheduledTaskDto) => {
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

  const onFinish = async (values: ScheduledTaskDto) => {
    if (row?.id) {
      await updateScheduledTask(row.id, values);
      handleSuccess('编辑成功');
    } else {
      await addScheduledTask(values);
      handleSuccess('新增成功');
    }
  };

  return (
    <Modal
      title={row?.id ? '编辑定时任务' : '新增定时任务'}
      open={isOpenModal}
      onCancel={onCancel}
      onOk={onOk}
      maskClosable={false}
      width="40%"
    >
      <Form<ScheduledTaskDto>
        name="wrap"
        labelCol={{ flex: '100px' }}
        labelWrap
        form={form}
        wrapperCol={{ flex: 1 }}
        colon={false}
        onFinish={onFinish}
      >
        <Form.Item label="任务KEY" name="taskKey" rules={[{ required: true }, { max: 100 }]}>
          <Input placeholder="请输入任务KEY，唯一" />
        </Form.Item>
        <Form.Item label="Cron表达式" name="cronExpression" rules={[{ required: true }, { max: 50 }]}>
          <Input placeholder="请输入Cron表达式" />
        </Form.Item>
        <Form.Item label="任务描述" name="description" rules={[{ max: 512 }]}>
          <Input placeholder="请输入任务描述" />
        </Form.Item>
        <Form.Item label="是否激活" name="isActive" rules={[{ required: true, message: '请选择任务状态' }]}>
          <Switch />
        </Form.Item>
      </Form>
    </Modal>
  );
});

export default ScheduledTaskForm;
