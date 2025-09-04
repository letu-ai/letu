import { useState } from 'react';
import { Card, Form, Input, Button, Progress, Alert, App } from 'antd';
import { LockOutlined, EyeInvisibleOutlined, EyeTwoTone } from '@ant-design/icons';
import { createFileRoute } from '@tanstack/react-router';
import { changePassword, type IChangePasswordInput } from './-service';
import { 
    calculatePasswordStrength, 
    generatePasswordRules, 
    getPasswordRequirements,
    type PasswordConfig,
    type PasswordStrengthResult 
} from '@/utils/passwordUtils';
import { useAppConfig } from '@/components/AppConfigProvider';

export const Route = createFileRoute('/my/password')({
    component: PasswordPage
});

function PasswordPage() {
    const [form] = Form.useForm();
    const { message } = App.useApp();
    const [submitting, setSubmitting] = useState(false);
    const [strengthResult, setStrengthResult] = useState<PasswordStrengthResult | null>(null);
    const appConfig = useAppConfig();
    
    // 获取密码配置
    const passwordConfig: PasswordConfig = {
        requiredLength: appConfig.getSettingInt('Letu.Identity.Password.RequiredLength') || 8,
        requiredUniqueChars: appConfig.getSettingInt('Letu.Identity.Password.RequiredUniqueChars') || 1,
        requireNonAlphanumeric: appConfig.getSettingBoolean('Letu.Identity.Password.RequireNonAlphanumeric') || false,
        requireLowercase: appConfig.getSettingBoolean('Letu.Identity.Password.RequireLowercase') || false,
        requireUppercase: appConfig.getSettingBoolean('Letu.Identity.Password.RequireUppercase') || false,
        requireDigit: appConfig.getSettingBoolean('Letu.Identity.Password.RequireDigit') || false,
    };

    const handlePasswordChange = (password: string) => {
        const result = calculatePasswordStrength(password, passwordConfig);
        setStrengthResult(result);
    };

    const onFinish = async (values: IChangePasswordInput) => {
        try {
            setSubmitting(true);
            await changePassword(values);
            message.success('密码修改成功，请重新登录');
            form.resetFields();
            setStrengthResult(null);
        } catch {
            message.error('密码修改失败，请检查原密码是否正确');
        } finally {
            setSubmitting(false);
        }
    };

    // 生成密码验证规则
    const passwordRules = generatePasswordRules(passwordConfig);
    
    // 获取密码要求描述
    const passwordRequirements = getPasswordRequirements(passwordConfig);

    return (
        <div className="max-w-4xl mx-auto">
            <Card title="修改密码">
                {/* 安全提示 */}
                <Alert
                    message="密码安全提示"
                    description={`为了账户安全，请确保密码符合以下要求。`}
                    type="info"
                    showIcon
                    className="mb-6"
                />

                <Form
                    form={form}
                    layout="vertical"
                    onFinish={onFinish}
                    className="max-w-md mx-auto"
                    autoComplete="off"
                >
                    <Form.Item
                        label="当前密码"
                        name="oldPassword"
                        rules={[
                            {
                                required: true,
                                message: '请输入当前密码',
                            },
                        ]}
                    >
                        <Input.Password
                            prefix={<LockOutlined />}
                            placeholder="请输入当前密码"
                            size="large"
                            iconRender={(visible) => (visible ? <EyeTwoTone /> : <EyeInvisibleOutlined />)}
                        />
                    </Form.Item>

                    <Form.Item
                        label="新密码"
                        name="newPassword"
                        rules={passwordRules}
                    >
                        <Input.Password
                            prefix={<LockOutlined />}
                            placeholder="请输入新密码"
                            size="large"
                            onChange={(e) => handlePasswordChange(e.target.value)}
                            iconRender={(visible) => (visible ? <EyeTwoTone /> : <EyeInvisibleOutlined />)}
                        />
                    </Form.Item>

                    {/* 密码强度指示器 */}
                    {strengthResult && strengthResult.score > 0 && (
                        <div className="mb-4">
                            <div className="flex justify-between items-center mb-2">
                                <span className="text-sm text-gray-600">密码强度：</span>
                                <span className="text-sm font-medium" style={{ color: strengthResult.color }}>
                                    {strengthResult.text}
                                </span>
                            </div>
                            <Progress
                                percent={strengthResult.score}
                                strokeColor={strengthResult.color}
                                showInfo={false}
                                size="small"
                            />
                            {/* 显示违规项 */}
                            {strengthResult.violations.length > 0 && (
                                <div className="mt-2">
                                    <div className="text-xs text-gray-500">
                                        需要改进：{strengthResult.violations.join('、')}
                                    </div>
                                </div>
                            )}
                        </div>
                    )}

                    <Form.Item
                        label="确认新密码"
                        name="confirmPassword"
                        dependencies={['newPassword']}
                        rules={[
                            {
                                required: true,
                                message: '请确认新密码',
                            },
                            ({ getFieldValue }) => ({
                                validator(_, value) {
                                    if (!value || getFieldValue('newPassword') === value) {
                                        return Promise.resolve();
                                    }
                                    return Promise.reject(new Error('两次输入的密码不一致'));
                                },
                            }),
                        ]}
                    >
                        <Input.Password
                            prefix={<LockOutlined />}
                            placeholder="请再次输入新密码"
                            size="large"
                            iconRender={(visible) => (visible ? <EyeTwoTone /> : <EyeInvisibleOutlined />)}
                        />
                    </Form.Item>

                    {/* 密码要求说明 */}
                    <div className="mb-6 p-3 bg-gray-50 rounded">
                        <div className="text-sm text-gray-600">
                            <div className="font-medium mb-2">密码要求：</div>
                            <ul className="space-y-1 text-xs">
                                {passwordRequirements.map((requirement, index) => (
                                    <li key={index}>{requirement}</li>
                                ))}
                            </ul>
                        </div>
                    </div>

                    <div className="flex justify-center space-x-3 mt-8">
                        <Button
                            type="primary"
                            htmlType="submit"
                            loading={submitting}
                            size="large"
                        >
                            {submitting ? '修改中...' : '修改'}
                        </Button>
                    </div>
                </Form>
            </Card>
        </div>
    );
}