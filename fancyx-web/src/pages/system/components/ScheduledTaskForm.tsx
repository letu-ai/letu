import { Form, Input, Modal, Switch } from 'antd';
import { forwardRef, useImperativeHandle, useState } from 'react';
import type { AppResponse } from '@/types/api';
import { addScheduledTask, type ScheduledTaskDto, updateScheduledTask } from '@/api/system/scheduledTask';
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

  const execute = (
    values: ScheduledTaskDto,
    apiAction: (params: ScheduledTaskDto) => Promise<AppResponse<boolean>>,
    successMsg: string,
  ) => {
    apiAction({ ...values, id: row?.id }).then(() => {
      message.success(successMsg);
      setIsOpenModal(false);
      form.resetFields();
      props?.refresh?.();
    });
  };
  const onFinish = (values: ScheduledTaskDto) => {
    const isEdit = !!row?.id;

    execute(values, isEdit ? updateScheduledTask : addScheduledTask, isEdit ? '编辑成功' : '新增成功');
  };

  return (
    <Modal
      title={row?.id ? '编辑定时任务' : '新增定时任务'}
      open={isOpenModal}
      onCancel={onCancel}
      onOk={onOk}
      maskClosable={false}
    >
      <Form<ScheduledTaskDto>
        name="wrap"
        labelCol={{ flex: '110px' }}
        labelWrap
        form={form}
        wrapperCol={{ flex: 1 }}
        colon={false}
        onFinish={onFinish}
      >
        <Form.Item label="任务KEY" name="taskKey" rules={[{ required: true }]}>
          <Input placeholder="请输入任务KEY，唯一" />
        </Form.Item>
        <Form.Item label="任务描述" name="description" rules={[{ required: true }]}>
          <Input placeholder="请输入任务描述" />
        </Form.Item>
        <Form.Item label="Cron表达式" name="cronExpression" rules={[{ required: true }]}>
          <Input placeholder="请输入Cron表达式" />
        </Form.Item>
        <Form.Item label="任务描述" name="description">
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
