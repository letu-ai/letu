import { Card, Form, Input, Button, Checkbox, Tabs, message, Divider } from 'antd';
import { UserOutlined, LockOutlined, MobileOutlined, MailOutlined } from '@ant-design/icons';
import './style/login.scss';
import { sendLoginSmsCode, loginByPassword, loginBySms, type IPasswordLoginInput, type ISmsLoginInput } from './-service';
import { useState, useEffect, useMemo } from 'react';
import { setToken, setRememberMe, getRememberMe, getSavedUserName } from '@/utils/authUtils';
import { createFileRoute, useNavigate } from '@tanstack/react-router';
import { useAppConfig } from '@/components/AppConfigProvider';
import { getLoginSettings } from './-service';
import SwitchTenantModel from './-SwitchTenantModel';

export const Route = createFileRoute('/account/login')({
    component: LoginPage,
    validateSearch: (search) => {
        return {
            returnUrl: search.returnUrl as string || '/',
        };
    },
    loader: async () => {
        const loginSettings = await getLoginSettings();
        return loginSettings;
    }
});

function LoginPage() {
    const [loading, setLoading] = useState(false);
    const [activeTab, setActiveTab] = useState('password');
    const [countdown, setCountdown] = useState(0);
    const { returnUrl } = Route.useSearch();
    const [form] = Form.useForm();
    const { getSettingBoolean, getSetting } = useAppConfig();
    const navigate = useNavigate();
    const copyright = getSetting("Letu.Application.Site.Copyright");
    const icp = getSetting("Letu.Application.Site.Icp");
    const logoText = getSetting("Letu.Application.Site.LogoText");
    const description = getSetting("Letu.Application.Site.Description");
    const loginSettings = Route.useLoaderData();
    const [switchTenantModelVisible, setSwitchTenantModelVisible] = useState(false);
    const [tenantName, setTenantName] = useState(loginSettings.tenantName);

    // 初始化表单值
    useEffect(() => {
        const rememberMe = getRememberMe();
        const savedUserName = getSavedUserName();
        if (rememberMe && savedUserName) {
            form.setFieldsValue({
                userName: savedUserName,
                remember: rememberMe,
            });
        }
    }, [form]);

    const handleSwitchTenant = () => {
        setSwitchTenantModelVisible(true);
    }

    const handleSwitchTenantClose = () => {
        setSwitchTenantModelVisible(false);
    }

    const handleSwitchTenantOk = (tenantName: string) => {
        setTenantName(tenantName);
    }

    const onFinish = async (values: any) => {
        setLoading(true);
        try {
            let result;
            switch (activeTab) {
                case 'password':
                    result = await loginByPassword(values as IPasswordLoginInput);
                    // 处理记住密码
                    setRememberMe(values.remember, values.userName);
                    break;

                default:
                    result = await loginBySms(values as ISmsLoginInput);
                    break;
            }

            // 保存token到identityStore
            if (result) {
                // 根据记住我选项保存token
                const rememberMe = activeTab === 'password' ? values.remember : false;
                setToken(result, rememberMe);
            }

            // 登录成功后跳转到返回URL或首页
            navigate({ to: returnUrl }); //使用重新加载页面，确保正确获取配置
        } catch {
            // 登录失败处理已在service中处理
        } finally {
            setLoading(false);
        }
    };

    const handleSendCode = (phone: string) => {
        if (!phone) {
            message.warning('请输入手机号码');
            return;
        }

        sendLoginSmsCode!(phone).then((data) => {
            message.success(`【测试】您的验证码是：${data}，5分钟内有效`, 3);
            let seconds = 60;
            setCountdown(seconds);
            const timer = setInterval(() => {
                seconds -= 1;
                setCountdown(seconds);
                if (seconds <= 0) {
                    clearInterval(timer);
                }
            }, 1000);
        });
    };

    const loginMethods = useMemo(() => {
        const methods = [{ key: 'password', label: '账号密码登录' }];
        if (getSettingBoolean('Letu.Account.EnablePhoneNumberLogin')) {
            methods.push({ key: 'sms', label: '短信验证码登录' });
        }
        return methods;
    }, [getSettingBoolean]);

    return (
        <div className="login-container">
            <div className="login-container-main">
                <Card className="login-card" variant="borderless">
                    <div className="login-layout">
                        {/* 左侧背景图 */}
                        <div className="login-bg-side" style={{ backgroundImage: `url("/images/login-bg.png")` }}>
                            <div className="bg-overlay bg-primary/70">
                                <h2>欢迎使用{logoText}</h2>
                                <p>{description}</p>
                            </div>
                        </div>

                        {/* 右侧登录表单 */}
                        <div className="login-form-side">
                            <div className="form-container">
                                <h3 className="form-title text-primary">用户登录</h3>
                                {loginSettings.multiTenancyEnabled && (
                                    <>
                                        <div className="flex flex-col">
                                            <h3 className="text-sm font-normal text-text-muted">租户</h3>
                                            <div className="flex items-center justify-between">
                                                <span className="text-base font-medium">{tenantName ?? '主站'}</span>
                                                <Button type="link" onClick={handleSwitchTenant}>切换</Button>
                                            </div>
                                        </div>
                                        <Divider />
                                        <SwitchTenantModel
                                            visible={switchTenantModelVisible}
                                            onOk={handleSwitchTenantOk}
                                            onClose={handleSwitchTenantClose}
                                        />
                                    </>
                                )}

                                <Tabs
                                    activeKey={activeTab}
                                    onChange={setActiveTab}
                                    centered
                                    items={loginMethods}
                                />

                                <Form<IPasswordLoginInput | ISmsLoginInput>
                                    layout="vertical"
                                    name="login_form"
                                    initialValues={{
                                        remember: false,
                                    }}
                                    onFinish={onFinish}
                                    form={form}
                                    size="large"
                                >
                                    {activeTab === 'password' ? (
                                        <>
                                            <Form.Item name="userName" rules={[{ required: true, message: '请输入账号' }]}>
                                                <Input prefix={<UserOutlined />} placeholder="账号" />
                                            </Form.Item>

                                            <Form.Item name="password" rules={[{ required: true, message: '请输入密码' }]}>
                                                <Input.Password prefix={<LockOutlined />} placeholder="密码" />
                                            </Form.Item>
                                        </>
                                    ) : (
                                        <>
                                            <Form.Item
                                                name="phone"
                                                rules={[
                                                    { required: true, message: '请输入手机号' },
                                                    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号' },
                                                ]}
                                            >
                                                <Input prefix={<MobileOutlined />} placeholder="手机号" />
                                            </Form.Item>

                                            <Form.Item name="code" rules={[{ required: true, message: '请输入验证码' }, { max: 6 }]}>
                                                <div style={{ display: 'flex', gap: '8px' }}>
                                                    <Input prefix={<MailOutlined />} placeholder="验证码" maxLength={6} />
                                                    <Button
                                                        onClick={() => {
                                                            const phone = form.getFieldValue('phone');
                                                            handleSendCode(phone);
                                                        }}
                                                        disabled={countdown > 0}
                                                        className="btn-send"
                                                    >
                                                        {countdown > 0 ? `${countdown}秒后重试` : '获取验证码'}
                                                    </Button>
                                                </div>
                                            </Form.Item>
                                        </>
                                    )}

                                    {activeTab === 'password' && (
                                        <Form.Item>
                                            <Form.Item name="remember" valuePropName="checked" noStyle>
                                                <Checkbox>记住密码</Checkbox>
                                            </Form.Item>
                                        </Form.Item>
                                    )}

                                    <Form.Item>
                                        <Button type="primary" htmlType="submit" block loading={loading}>
                                            登 录
                                        </Button>
                                    </Form.Item>
                                </Form>
                            </div>
                        </div>
                    </div>
                </Card>

                <div className="login-footer">
                    {copyright?.replace("%YEAR%", new Date().getFullYear().toString())} |
                    <a href="http://beian.miit.gov.cn" target="_blank" rel="noopener noreferrer" style={{ marginLeft: '8px' }}>
                        {icp}
                    </a>
                </div>
            </div>
        </div>
    );
}
