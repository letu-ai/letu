import { Form, Input, Modal } from 'antd';
import { forwardRef, useImperativeHandle, useState } from 'react';
import { resetPassword, type ResetPasswordInput, type UserListOutput } from './-service';
import useApp from 'antd/es/app/useApp';
import { useAppConfig } from '@/components/AppConfigProvider';
import { generatePasswordRules, type PasswordConfig } from '@/utils/passwordUtils';

// eslint-disable-next-line @typescript-eslint/no-empty-object-type
interface ModalProps {}

export interface ResetUserPwdFormRef {
  openModal: (row: UserListOutput) => void; // 定义 ref 的类型
}

const ResetUserPwdForm = forwardRef<ResetUserPwdFormRef, ModalProps>((_, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [form] = Form.useForm();
  const [currentRow, setCurrentRow] = useState<UserListOutput>();
  const { message } = useApp();
  const { getSettingInt, getSettingBoolean } = useAppConfig();
  
  // 获取密码配置
  const passwordConfig: PasswordConfig = {
    requiredLength: getSettingInt('Letu.Identity.Password.RequiredLength') || 8,
    requiredUniqueChars: getSettingInt('Letu.Identity.Password.RequiredUniqueChars') || 1,
    requireNonAlphanumeric: getSettingBoolean('Letu.Identity.Password.RequireNonAlphanumeric') || false,
    requireLowercase: getSettingBoolean('Letu.Identity.Password.RequireLowercase') || false,
    requireUppercase: getSettingBoolean('Letu.Identity.Password.RequireUppercase') || false,
    requireDigit: getSettingBoolean('Letu.Identity.Password.RequireDigit') || false,
  };

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  const openModal = (row: UserListOutput) => {
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

  const handleSuccess = (successMessage: string) => {
    message.success(successMessage);
    setIsOpenModal(false);
    form.resetFields();
  };

  const onFinish = async (values: ResetPasswordInput) => {
    await resetPassword({ ...values, userId: currentRow!.id });
    handleSuccess('重置成功');
  };
  
  // 生成密码验证规则
  const passwordRules = generatePasswordRules(passwordConfig);

  return (
    <Modal title="重置密码" open={isOpenModal} onCancel={onCancel} onOk={onOk} maskClosable={false} width="40%">
      <Form<ResetPasswordInput>
        name="resetUserPwdForm"
        labelCol={{ flex: '80px' }}
        labelWrap
        form={form}
        wrapperCol={{ flex: 1 }}
        colon={false}
        onFinish={onFinish}
      >
        <p className="mb-1">正在重置用户"{currentRow?.userName}"的密码：</p>
        <Form.Item name="password" rules={passwordRules}>
          <Input.Password placeholder="请输入用户密码" allowClear />
        </Form.Item>
      </Form>
    </Modal>
  );
});

export default ResetUserPwdForm;
