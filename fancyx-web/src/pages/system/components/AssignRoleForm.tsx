import { Form, message, Modal, Select } from 'antd';
import { forwardRef, useImperativeHandle, useState } from 'react';
import { assignRole, type AssignRoleDto, getUserRoleIds } from '@/api/system/user.ts';
import { getRoleOptions } from '@/api/system/role.ts';
import type { AppOption } from '@/types/api';

// eslint-disable-next-line @typescript-eslint/no-empty-object-type
interface ModalProps {}

export interface AssignRoleFormRef {
  openModal: (id: string) => void; // 定义 ref 的类型
}

const AssignRoleForm = forwardRef<AssignRoleFormRef, ModalProps>((_, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [form] = Form.useForm();
  const [roleOptions, setRoleOptions] = useState<AppOption[]>([]);
  const [userId, setUserId] = useState<string>();

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  const openModal = (id: string) => {
    setUserId(id);
    getRoleOptions().then(async (roleRes) => {
      setRoleOptions(roleRes.data);
      const { data } = await getUserRoleIds(id);
      form.setFieldsValue({
        roleIds: data,
      });
    });

    setIsOpenModal(true);
  };

  const onCancel = () => {
    form.resetFields();
    setIsOpenModal(false);
  };

  const onOk = () => {
    form.submit();
  };

  const onFinish = (values: AssignRoleDto) => {
    assignRole({ ...values, userId: userId! }).then(() => {
      message.success('指派成功');
      setIsOpenModal(false);
      form.resetFields();
    });
  };

  return (
    <Modal title="指派角色" open={isOpenModal} onCancel={onCancel} onOk={onOk} maskClosable={false}>
      <Form<AssignRoleDto>
        name="wrap"
        labelCol={{ flex: '80px' }}
        labelWrap
        form={form}
        wrapperCol={{ flex: 1 }}
        colon={false}
        style={{ maxWidth: 600 }}
        onFinish={onFinish}
      >
        <Form.Item label="角色" name="roleIds">
          <Select mode="multiple" style={{ width: '100%' }} options={roleOptions} />
        </Form.Item>
      </Form>
    </Modal>
  );
});

export default AssignRoleForm;
