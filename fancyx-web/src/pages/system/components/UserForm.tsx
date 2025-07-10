import { Form, Input, Modal, Radio } from 'antd';
import { forwardRef, useImperativeHandle, useState } from 'react';
import { addUser, type UserDto } from '@/api/system/user.ts';
import { Patterns } from '@/utils/globalValue.ts';
import useApp from 'antd/es/app/useApp';

interface ModalProps {
  refresh?: () => void; // 定义 props 的类型
}

export interface ModalRef {
  openModal: () => void; // 定义 ref 的类型
}

const UserModal = forwardRef<ModalRef, ModalProps>((props, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [form] = Form.useForm();
  const { message } = useApp();

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  const openModal = () => {
    setIsOpenModal(true);
  };

  const onCancel = () => {
    form.resetFields();
    setIsOpenModal(false);
  };

  const onOk = () => {
    form.submit();
  };

  const onFinish = (values: UserDto) => {
    addUser(values).then(() => {
      message.success('新增成功');
      setIsOpenModal(false);
      form.resetFields();
      props?.refresh?.();
    });
  };
  const pwdPatternValidateItem = {
    pattern: Patterns.LoginPassword,
    message: '密码至少有一个字母和数字，长度6-16位，特殊字符 "~`!@#$%^&*()_-+={[}]|\\:;\\"\'<,>.?/',
  };

  return (
    <Modal title="新增用户" open={isOpenModal} onCancel={onCancel} onOk={onOk} maskClosable={false}>
      <Form<UserDto>
        name="wrap"
        labelCol={{ flex: '80px' }}
        labelWrap
        form={form}
        wrapperCol={{ flex: 1 }}
        colon={false}
        onFinish={onFinish}
      >
        <Form.Item label="账号" name="userName" rules={[{ required: true }]}>
          <Input placeholder="请输入账号" />
        </Form.Item>
        <Form.Item label="昵称" name="nickName" rules={[{ required: true }]}>
          <Input placeholder="请输入昵称" />
        </Form.Item>
        <Form.Item label="性别" name="sex" rules={[{ required: true }]} initialValue={1}>
          <Radio.Group>
            <Radio value={1}> 男 </Radio>
            <Radio value={2}> 女 </Radio>
          </Radio.Group>
        </Form.Item>

        <Form.Item<UserDto> label="密码" name="password" rules={[{ required: true }, pwdPatternValidateItem]}>
          <Input.Password placeholder="请输入密码" />
        </Form.Item>
      </Form>
    </Modal>
  );
});

export default UserModal;
