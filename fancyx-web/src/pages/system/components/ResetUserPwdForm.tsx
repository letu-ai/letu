import { Form, Input, Modal } from 'antd';
import { forwardRef, useImperativeHandle, useState } from 'react';
import { resetUserPwd, type ResetUserPwdDto, type UserListDto } from '@/api/system/user.ts';
import { Patterns } from '@/utils/globalValue.ts';
import useApp from 'antd/es/app/useApp';

// eslint-disable-next-line @typescript-eslint/no-empty-object-type
interface ModalProps {}

export interface ResetUserPwdFormRef {
  openModal: (row: UserListDto) => void; // 定义 ref 的类型
}

const ResetUserPwdForm = forwardRef<ResetUserPwdFormRef, ModalProps>((_, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [form] = Form.useForm();
  const [currentRow, setCurrentRow] = useState<UserListDto>();
  const { message } = useApp();

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  const openModal = (row: UserListDto) => {
    setCurrentRow(row);
    setIsOpenModal(true);
  };

  const onCancel = () => {
    form.resetFields();
    setIsOpenModal(false);
  };

  const onOk = () => {
    form.submit();
  };

  const onFinish = (values: ResetUserPwdDto) => {
    resetUserPwd({ ...values, userId: currentRow!.id }).then(() => {
      message.success('指派成功');
      setIsOpenModal(false);
      form.resetFields();
    });
  };
  const pwdPatternValidateItem = {
    pattern: Patterns.LoginPassword,
    message: '密码至少有一个字母和数字，长度6-16位，特殊字符 "~`!@#$%^&*()_-+={[}]|\\:;\\"\'<,>.?/',
  };

  return (
    <Modal title="重置密码" open={isOpenModal} onCancel={onCancel} onOk={onOk} maskClosable={false} width="40%">
      <Form<ResetUserPwdDto>
        name="wrap"
        labelCol={{ flex: '80px' }}
        labelWrap
        form={form}
        wrapperCol={{ flex: 1 }}
        colon={false}
        style={{ maxWidth: 600 }}
        onFinish={onFinish}
      >
        <p className="mb-1">正在重置用户"{currentRow?.userName}"的密码：</p>
        <Form.Item name="password" rules={[{ required: true, message: '用户密码不能为空' }, pwdPatternValidateItem]}>
          <Input.Password placeholder="请输入用户密码" allowClear />
        </Form.Item>
      </Form>
    </Modal>
  );
});

export default ResetUserPwdForm;
