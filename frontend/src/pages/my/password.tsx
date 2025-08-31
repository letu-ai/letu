import { useState } from 'react';
import { Card, Form, Input, Button, Progress, Alert, App } from 'antd';
import { LockOutlined, EyeInvisibleOutlined, EyeTwoTone } from '@ant-design/icons';
import { createFileRoute } from '@tanstack/react-router';
import { changePassword, type ChangePasswordDto } from './-service';

export const Route = createFileRoute('/my/password')({
    component: PasswordPage
});

function PasswordPage() {
    const [form] = Form.useForm();
    const { message } = App.useApp();
    const [submitting, setSubmitting] = useState(false);
    const [passwordStrength, setPasswordStrength] = useState(0);
    const [strengthColor, setStrengthColor] = useState('#f5222d');
    const [strengthText, setStrengthText] = useState('');

    const calculatePasswordStrength = (password: string) => {
        let score = 0;
        const rules = [
            { regex: /.{8,}/, point: 25 }, // 至少8位
            { regex: /[A-Z]/, point: 25 }, // 包含大写字母
            { regex: /[a-z]/, point: 25 }, // 包含小写字母
            { regex: /[0-9]/, point: 25 }, // 包含数字
            { regex: /[^A-Za-z0-9]/, point: 25 }, // 包含特殊字符
        ];

        rules.forEach(rule => {
            if (rule.regex.test(password)) {
                score += rule.point;
            }
        });

        // 限制最大分数为100
        score = Math.min(score, 100);
        
        setPasswordStrength(score);

        // 设置强度颜色和文字
        if (score <= 25) {
            setStrengthColor('#f5222d');
            setStrengthText('弱');
        } else if (score <= 50) {
            setStrengthColor('#fa8c16');
            setStrengthText('一般');
        } else if (score <= 75) {
            setStrengthColor('#fadb14');
            setStrengthText('良好');
        } else {
            setStrengthColor('#52c41a');
            setStrengthText('强');
        }
    };

    const onFinish = async (values: ChangePasswordDto) => {
        try {
            setSubmitting(true);
            await changePassword(values);
            message.success('密码修改成功，请重新登录');
            form.resetFields();
            setPasswordStrength(0);
            setStrengthText('');
        } catch {
            message.error('密码修改失败，请检查原密码是否正确');
        } finally {
            setSubmitting(false);
        }
    };

    const passwordRules = [
        {
            required: true,
            message: '请输入新密码',
        },
        {
            min: 8,
            message: '密码长度至少8位',
        },
        {
            pattern: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$/,
            message: '密码必须包含大小写字母和数字',
        },
    ];

    return (
        <div className="max-w-2xl">
            <Card title="修改密码">
                {/* 安全提示 */}
                <Alert
                    message="密码安全提示"
                    description="为了账户安全，建议使用包含大小写字母、数字和特殊字符的强密码，长度至少8位。"
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
                            onChange={(e) => calculatePasswordStrength(e.target.value)}
                            iconRender={(visible) => (visible ? <EyeTwoTone /> : <EyeInvisibleOutlined />)}
                        />
                    </Form.Item>

                    {/* 密码强度指示器 */}
                    {passwordStrength > 0 && (
                        <div className="mb-4">
                            <div className="flex justify-between items-center mb-2">
                                <span className="text-sm text-gray-600">密码强度：</span>
                                <span className="text-sm font-medium" style={{ color: strengthColor }}>
                                    {strengthText}
                                </span>
                            </div>
                            <Progress
                                percent={passwordStrength}
                                strokeColor={strengthColor}
                                showInfo={false}
                                size="small"
                            />
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
                                <li>• 长度至少8位字符</li>
                                <li>• 至少包含一个大写字母</li>
                                <li>• 至少包含一个小写字母</li>
                                <li>• 至少包含一个数字</li>
                                <li>• 建议包含特殊字符(!@#$%^&*)</li>
                            </ul>
                        </div>
                    </div>

                    <Form.Item>
                        <div className="flex space-x-3">
                            <Button
                                size="large"
                                onClick={() => {
                                    form.resetFields();
                                    setPasswordStrength(0);
                                    setStrengthText('');
                                }}
                            >
                                重置
                            </Button>
                            <Button
                                type="primary"
                                htmlType="submit"
                                loading={submitting}
                                size="large"
                                className="flex-1"
                            >
                                {submitting ? '修改中...' : '确认修改'}
                            </Button>
                        </div>
                    </Form.Item>
                </Form>
            </Card>
        </div>
    );
}