import { Form, Checkbox, Button, Typography, message, Spin, InputNumber, Divider } from 'antd';
import { fetchAccountSettings, type IAccountSettings, updateAccountSettings } from './service';
import { useState, useEffect } from 'react';

const { Title } = Typography;

function AccountSettings() {
    const [form] = Form.useForm();
    const [loading, setLoading] = useState(false);
    const [pageLoading, setPageLoading] = useState(true);
    const [settings, setSettings] = useState<IAccountSettings | null>(null);

    useEffect(() => {
        const fetchSettings = async () => {
            try {
                const data = await fetchAccountSettings();
                setSettings(data);
                form.setFieldsValue(data);
            } catch (error) {
                message.error('获取账户设置失败');
            } finally {
                setPageLoading(false);
            }
        };
        fetchSettings();
    }, [form]);

    const handleSubmit = async (values: IAccountSettings) => {
        setLoading(true);
        try {
            await updateAccountSettings(values);
            message.success('更新账户设置成功');
        } catch (error) {
            message.error('更新账户设置失败');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div style={{ maxWidth: 800 }}>
            <Spin spinning={pageLoading} tip="加载中...">
                <Title level={3} style={{ textAlign: 'center', marginBottom: 32 }}>
                    账户设置
                </Title>

                <Form
                    form={form}
                    layout="vertical"
                    onFinish={handleSubmit}
                    initialValues={settings || {}}
                >
                    <div style={{ marginBottom: 24 }}>
                        <Title level={4}>账号</Title>
                        <Form.Item
                            name="isSelfRegistrationEnabled"
                            valuePropName="checked"
                        >
                            <Checkbox>允许用户自行注册</Checkbox>
                        </Form.Item>

                        <Form.Item
                            name="enableLocalLogin"
                            valuePropName="checked"
                            help="禁用后就只能使用第三方登录"
                        >
                            <Checkbox>允许使用用户名和密码登录</Checkbox>
                        </Form.Item>

                        <Form.Item
                            name="allowPasswordRecovery"
                            valuePropName="checked"
                            help="通过邮件、手机短信等方式找回密码"
                        >
                            <Checkbox>允许用户找回遗忘的密码</Checkbox>
                        </Form.Item>

                        <Form.Item
                            name="signInAllowMultipleLogin"
                            valuePropName="checked"
                            help="允许用户在多个设备上同时登录"
                        >
                            <Checkbox>允许多个会话</Checkbox>
                        </Form.Item>

                    </div>
                    <Divider />

                    <div style={{ marginBottom: 24 }}>
                        <Title level={4}>密码设置</Title>
                        <Form.Item
                            name="passwordRequiredLength"
                            label="密码最小长度"
                            rules={[
                                { required: true, message: '请输入密码最小长度' },
                                { type: 'number', min: 3, max: 64, message: '密码最小长度必须在3-64之间' }
                            ]}
                        >
                            <InputNumber />
                        </Form.Item>
                        <Form.Item
                            name="passwordRequiredUniqueChars"
                            label="唯一字符数量"
                            help="密码中不重复的字符数量"
                            rules={[
                                { required: true, message: '请输入唯一字符数量' },
                                { type: 'number', min: 1, max: 10, message: '唯一字符数量必须在1-10之间' }
                            ]}
                        >
                            <InputNumber />
                        </Form.Item>
                        <Form.Item
                            name="passwordRequireNonAlphanumeric"
                            valuePropName="checked"
                        >
                            <Checkbox>必须包含特殊字符（例如：@#$%^...等符号）</Checkbox>
                        </Form.Item>
                        <Form.Item
                            name="passwordRequireLowercase"
                            valuePropName="checked"
                        >
                            <Checkbox>必须包含小写字母</Checkbox>
                        </Form.Item>
                        <Form.Item
                            name="passwordRequireUppercase"
                            valuePropName="checked"
                        >
                            <Checkbox>必须包含大写字母</Checkbox>
                        </Form.Item>
                        <Form.Item
                            name="passwordRequireDigit"
                            valuePropName="checked"
                        >
                            <Checkbox>必须包含数字</Checkbox>
                        </Form.Item>
                    </div>

                    <Divider />

                    <div style={{ marginBottom: 24 }}>
                        <Title level={4}>密码更新设置</Title>
                        <Form.Item
                            name="forceUsersToPeriodicallyChangePassword"
                            valuePropName="checked"
                        >
                            <Checkbox>强制定期更改密码</Checkbox>
                        </Form.Item>
                        <Form.Item
                            name="passwordChangePeriodDays"
                            label="用户需要更改密码的天数间隔"
                            rules={[
                                { required: true, message: '请输入用户需要更改密码的天数间隔' },
                                { type: 'number', min: 0, max: 365, message: '用户需要更改密码的天数间隔必须在0-365之间' }
                            ]}
                        >
                            <InputNumber />
                        </Form.Item>
                    </div>

                    <Divider />

                    <div style={{ marginBottom: 24 }}>
                        <Title level={4}>锁定设置</Title>
                        <Form.Item
                            name="allowedForNewUsers"
                            valuePropName="checked"
                        >
                            <Checkbox>为新用户启用锁定功能(推荐启用)</Checkbox>
                        </Form.Item>
                        <Form.Item
                            name="maxFailedAccessAttempts"
                            label="密码错误尝试次数"
                            help="超过此次数后，账户将被锁定"
                            rules={[
                                { required: true, message: '请输入密码错误尝试次数' },
                                { type: 'number', min: 1, max: 999, message: '密码错误尝试次数必须在1-999之间' }
                            ]}
                        >
                            <InputNumber />
                        </Form.Item>
                        <Form.Item
                            name="lockoutDuration"
                            label="锁定时长（秒）"
                            rules={[
                                { required: true, message: '请输入锁定时长' },
                                { type: 'number', min: 1, message: '锁定时长必须在1秒以上' }
                            ]}
                        >
                            <InputNumber />
                        </Form.Item>
                    </div>

                    <Divider />

                    <div style={{ marginBottom: 24 }}>
                        <Title level={4}>登录设置</Title>
                        <Form.Item
                            name="signInRequireConfirmedEmail"
                            valuePropName="checked"
                            help={<p>邮箱没有通过验证的用户将无法登录，包括<strong style={{ color: 'black' }}>管理员</strong></p>}
                        >
                            <Checkbox>要求验证邮箱</Checkbox>
                        </Form.Item>
                        <Form.Item
                            name="signInRequireConfirmedPhoneNumber"
                            valuePropName="checked"
                            help={<p>手机号没有通过验证的用户将无法登录，包括<strong style={{ color: 'black' }}>管理员</strong></p>}
                        >
                            <Checkbox>要求验证手机号</Checkbox>
                        </Form.Item>
                        <Form.Item
                            name="signInEnablePhoneNumberConfirmation"
                            valuePropName="checked"
                            help="在个人信息管理页面启用验证码确认手机号功能"
                        >
                            <Checkbox>允许用户确认他的电话号码</Checkbox>
                        </Form.Item>
                    </div>

                    <Divider />

                    <div style={{ marginBottom: 24 }}>
                        <Title level={4}>用户设置</Title>
                        <Form.Item
                            name="isUserNameUpdateEnabled"
                            valuePropName="checked"
                        >
                            <Checkbox>允许用户自行修改用户名</Checkbox>
                        </Form.Item>
                        <Form.Item
                            name="isEmailUpdateEnabled"
                            valuePropName="checked"
                        >
                            <Checkbox>允许用户自行修改邮箱</Checkbox>
                        </Form.Item>
                    </div>

                    <div style={{ textAlign: 'center', marginTop: 24 }}>
                        <Button type="primary" htmlType="submit" loading={loading}>
                            保存
                        </Button>
                    </div>
                </Form>
            </Spin>
        </div>
    );
}

export default AccountSettings;
