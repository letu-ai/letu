import { Form, Input, Modal, Select } from 'antd';
import { forwardRef, useImperativeHandle, useState } from 'react';
import { assignRole, type AssignRoleDto, getUserRoleIds, type UserListDto } from '@/api/system/user.ts';
import { getRoleOptions } from '@/api/system/role.ts';
import type { AppOption } from '@/types/api';
import useApp from 'antd/es/app/useApp';

// eslint-disable-next-line @typescript-eslint/no-empty-object-type
interface ModalProps {}

export interface AssignRoleFormRef {
  openModal: (row: UserListDto) => void; // 定义 ref 的类型
}

const AssignRoleForm = forwardRef<AssignRoleFormRef, ModalProps>((_, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [form] = Form.useForm();
  const [roleOptions, setRoleOptions] = useState<AppOption[]>([]);
  const [currentRow, setCurrentRow] = useState<UserListDto>();
  const { message } = useApp();

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  const openModal = (row: UserListDto) => {
    setCurrentRow(row);
    form.setFieldValue('userName', row.userName);
    form.setFieldValue('nickName', row.nickName);
    getRoleOptions().then(async (roleRes) => {
      setRoleOptions(roleRes.data);
      const { data } = await getUserRoleIds(row.id);
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
    assignRole({ ...values, userId: currentRow!.id }).then(() => {
      message.success('指派成功');
      setIsOpenModal(false);
      form.resetFields();
    });
  };

  return (
    <Modal title="分配角色" open={isOpenModal} onCancel={onCancel} onOk={onOk} maskClosable={false} width="40%">
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
        <Form.Item label="账号" name="userName">
          <Input disabled />
        </Form.Item>
        <Form.Item label="昵称" name="nickName">
          <Input disabled />
        </Form.Item>
        <Form.Item label="角色" name="roleIds">
          <Select mode="multiple" style={{ width: '100%' }} options={roleOptions} />
        </Form.Item>
      </Form>
    </Modal>
  );
});

export default AssignRoleForm;
