import { Form, Input, Modal } from 'antd';
import { forwardRef, useImperativeHandle, useState } from 'react';
import { addUser, updateUser, type ICreateUserInput, type IUpdateUserInput, type UserListOutput } from './-service';
import useApp from 'antd/es/app/useApp';
import DepartmentSelect from '@/components/DepartmentSelect';
import PositionSelect from '@/components/PositionSelect';
import EmployeeSelect from '@/components/EmployeeSelect';
import { useAppConfig } from '@/components/AppConfigProvider';
import { generatePasswordRules, type PasswordConfig } from '@/utils/passwordUtils';
import { Patterns } from '@/utils/globalValue';

interface ModalProps {
    refresh?: () => void; // 定义 props 的类型
}

export interface ModalRef {
    openModal: (row?: UserListOutput) => void; // 定义 ref 的类型
}

const UserModal = forwardRef<ModalRef, ModalProps>((props, ref) => {
    const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
    const [form] = Form.useForm();
    const { message } = useApp();
    const [row, setRow] = useState<UserListOutput | null>();
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

    const openModal = (row?: UserListOutput) => {
        setIsOpenModal(true);
        if (row) {
            setRow(row);
            form.setFieldsValue(row);
        } else {
            setRow(null);
            form.resetFields();
        }
        // 数据加载由公共组件自己处理
    };


    const onCancel = () => {
        form.resetFields();
        setIsOpenModal(false);
    };

    const onOk = () => {
        form.submit();
    };

    // 表单字段类型定义
    interface FormFields {
        userName?: string;
        password?: string;
        avatar?: string | null;
        nickName?: string | null;
        phone?: string;
        email?: string | null;
        departmentId?: string | null;
        positionId?: string | null;
        employeeId?: string | null;
    }

    const onFinish = async (values: FormFields) => {
        const isEdit = !!row?.id;
        
        try {
            if (isEdit && row?.id) {
                // 编辑模式
                const updateData: IUpdateUserInput = {
                    avatar: values.avatar,
                    nickName: values.nickName,
                    phone: values.phone,
                    email: values.email,
                    departmentId: values.departmentId,
                    positionId: values.positionId,
                    employeeId: values.employeeId,
                };
                await updateUser(row.id, updateData);
                message.success('编辑成功');
            } else {
                // 创建模式
                if (!values.userName || !values.password) {
                    message.error('用户名和密码必填');
                    return;
                }
                const createData: ICreateUserInput = {
                    ...values,
                    userName: values.userName,
                    password: values.password,
                } as ICreateUserInput;
                await addUser(createData);
                message.success('新增成功');
            }
            setIsOpenModal(false);
            form.resetFields();
            props?.refresh?.();
        } catch (error) {
            console.error('操作失败:', error);
        }
    };

    // 生成密码验证规则
    const passwordRules = generatePasswordRules(passwordConfig);
    const isEdit = !!row?.id;

    return (
        <Modal 
            title={isEdit ? `编辑用户 ${row?.nickName}` : "新增用户"} 
            open={isOpenModal} 
            onCancel={onCancel} 
            onOk={onOk} 
            maskClosable={false}
        >
            <Form<ICreateUserInput>
                name="wrap"
                labelCol={{ flex: '80px' }}
                labelWrap
                form={form}
                wrapperCol={{ flex: 1 }}
                colon={false}
                onFinish={onFinish}
            >
                {!isEdit && (
                    <Form.Item label="账号" name="userName" rules={[{ required: true }, { max: 32 }]}>
                        <Input placeholder="请输入账号" />
                    </Form.Item>
                )}
                {!isEdit && (
                    <Form.Item label="密码" name="password" rules={passwordRules}>
                        <Input.Password placeholder="请输入密码" />
                    </Form.Item>
                )}
                <Form.Item label="昵称" name="nickName" rules={[{ required: true }, { max: 64 }]}>
                    <Input placeholder="请输入昵称" />
                </Form.Item>
                <Form.Item
                    label="手机号"
                    name="phone"
                    rules={[
                        {
                            pattern: Patterns.Phone,
                            message: '请输入正确的手机号格式',
                        },
                    ]}
                >
                    <Input placeholder="请输入手机号" />
                </Form.Item>
                <Form.Item
                    label="邮箱"
                    name="email"
                    rules={[
                        {
                            type: 'email',
                            message: '请输入正确的邮箱格式',
                        },
                    ]}
                >
                    <Input placeholder="请输入邮箱" />
                </Form.Item>
                <Form.Item label="部门" name="departmentId">
                    <DepartmentSelect initialLabel={row?.departmentName} />
                </Form.Item>
                <Form.Item label="职位" name="positionId">
                    <PositionSelect initialLabel={row?.positionName} />
                </Form.Item>
                <Form.Item label="关联员工" name="employeeId">
                    <EmployeeSelect placeholder="请选择关联员工（可选）" />
                </Form.Item>
            </Form>
        </Modal>
    );
});

export default UserModal;
