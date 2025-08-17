import { Form, Input, Checkbox, Button, Typography, Modal, message, InputNumber, Spin } from 'antd';
import { useState, useEffect } from 'react';
import { fetchEmailSettings, type IEmailSettings, sendTestEmail, updateEmailSettings } from './service';

const { Title } = Typography;


function EmailSettings() {
    const [form] = Form.useForm();
    const [testEmailForm] = Form.useForm();
    const [loading, setLoading] = useState(false);
    const [pageLoading, setPageLoading] = useState(true);
    const [settings, setSettings] = useState<IEmailSettings | null>(null);
    const [showTestEmailDialog, setShowTestEmailDialog] = useState(false);
    const [testEmailLoading, setTestEmailLoading] = useState(false);

    const useDefaultCredentials = Form.useWatch('smtpUseDefaultCredentials', form);

    useEffect(() => {
        const fetchSettings = async () => {
            try {
                const data = await fetchEmailSettings();
                setSettings(data);
                form.setFieldsValue(data);
                testEmailForm.setFieldsValue({
                    senderEmailAddress: data.defaultFromAddress,
                    targetEmailAddress: "",
                    subject: "邮件测试",
                    body: "收到这封邮件，说明邮件设置正确。"
                });
            } catch (error) {
                message.error('获取邮件设置失败');
            } finally {
                setPageLoading(false);
            }
        };
        fetchSettings();
    }, [form, testEmailForm]);

    const handleSubmit = async (values: IEmailSettings) => {
        setLoading(true);
        try {
            await updateEmailSettings(values);
            message.success('更新邮件设置成功');
        } catch (error) {
            message.error('更新邮件设置失败');
        } finally {
            setLoading(false);
        }
    };

    const handleSendTestEmail = async () => {
        try {
            const values = await testEmailForm.validateFields();
            setTestEmailLoading(true);
            await sendTestEmail(values);
            message.success("测试邮件发送成功");
            setShowTestEmailDialog(false);
        } finally {
            setTestEmailLoading(false);
        }
    };

    return (
        <div style={{ maxWidth: 800 }}>
            <Spin spinning={pageLoading} tip="加载中...">
            <Title level={3} style={{ textAlign: 'center', marginBottom: 32 }}>
                邮件服务器设置
            </Title>
            <Form
                form={form}
                layout="vertical"
                onFinish={handleSubmit}
                initialValues={settings || {}}
            >
                <Form.Item
                    name="defaultFromAddress"
                    label="发件人地址"
                    help="系统发送邮件时使用的发件人地址"
                    rules={[
                        { required: true, message: '发件人地址不能为空' },
                        { type: 'email', message: '发件人地址必须是有效的邮箱地址' }
                    ]}
                >
                    <Input placeholder="例如: noreply@example.com" />
                </Form.Item>
                
                <Form.Item
                    name="defaultFromDisplayName"
                    label="发件人显示名称"
                    help="系统发送邮件时显示的发件人名称"
                    rules={[{ required: true, message: '发件人显示名称不能为空' }]}
                >
                    <Input placeholder="例如: 系统管理员" />
                </Form.Item>
                
                <Form.Item
                    name="smtpHost"
                    label="SMTP主机"
                    help="SMTP服务器的地址"
                    rules={[{ required: true, message: 'SMTP主机不能为空' }]}
                >
                    <Input placeholder="例如: smtp.gmail.com" />
                </Form.Item>
                
                <Form.Item
                    name="smtpPort"
                    label="SMTP端口"
                    help="例如: 587"
                    rules={[
                        { required: true, message: 'SMTP端口不能为空' },
                        { type: 'number', min: 1, max: 65535, message: 'SMTP端口必须在1-65535之间' }
                    ]}
                >
                    <InputNumber />
                </Form.Item>
                
                <Form.Item
                    name="smtpEnableSsl"
                    valuePropName="checked"
                >
                    <Checkbox>启用SSL</Checkbox>
                </Form.Item>
                
                <Form.Item
                    name="smtpUseDefaultCredentials"
                    valuePropName="checked"
                    help="使用系统设置的SMTP账号发送邮件"
                >
                    <Checkbox>使用默认凭据</Checkbox>
                </Form.Item>
                
                {!useDefaultCredentials && (
                    <>
                        <Form.Item
                            name="smtpUserName"
                            label="SMTP用户名"
                            help="用于身份验证的用户名"
                            rules={[{ required: true, message: '当不使用默认凭据时，SMTP用户名不能为空' }]}
                        >
                            <Input placeholder="请输入SMTP用户名" />
                        </Form.Item>
                        
                        <Form.Item
                            name="smtpPassword"
                            label="SMTP密码"
                            help="用于身份验证的密码"
                            rules={[{ required: true, message: '当不使用默认凭据时，SMTP密码不能为空' }]}
                        >
                            <Input.Password placeholder="请输入SMTP密码" />
                        </Form.Item>
                        
                        <Form.Item
                            name="smtpDomain"
                            label="SMTP域名"
                            help="SMTP服务器的域名（可选）"
                        >
                            <Input placeholder="请输入SMTP域名" />
                        </Form.Item>
                    </>
                )}

                <div style={{ textAlign: 'center', marginTop: 24 }}>
                        <Button 
                            style={{ marginRight: 8 }} 
                            onClick={() => setShowTestEmailDialog(true)}
                        >
                            发送测试邮件
                        </Button>
                    <Button type="primary" htmlType="submit" loading={loading}>
                        保存
                    </Button>
                </div>
            </Form>

            <Modal
                title="发送测试邮件"
                open={showTestEmailDialog}
                onCancel={() => setShowTestEmailDialog(false)}
                footer={null}
            >
                <Form
                    form={testEmailForm}
                    layout="vertical"
                    style={{ marginTop: 16 }}
                >
                    <Form.Item
                        name="senderEmailAddress"
                        label="发件人地址"
                        rules={[
                            { required: true, message: '发件人地址不能为空' },
                            { type: 'email', message: '发件人地址必须是有效的邮箱地址' }
                        ]}
                    >
                        <Input placeholder="请输入发件人邮箱地址" />
                    </Form.Item>
                    
                    <Form.Item
                        name="targetEmailAddress"
                        label="收件人地址"
                        rules={[
                            { required: true, message: '收件人地址不能为空' },
                            { type: 'email', message: '收件人地址必须是有效的邮箱地址' }
                        ]}
                    >
                        <Input placeholder="请输入收件人邮箱地址" />
                    </Form.Item>
                    
                    <Form.Item
                        name="subject"
                        label="邮件主题"
                        rules={[{ required: true, message: '邮件主题不能为空' }]}
                    >
                        <Input placeholder="请输入邮件主题" />
                    </Form.Item>
                    
                    <Form.Item
                        name="body"
                        label="邮件内容"
                    >
                        <Input.TextArea 
                            placeholder="请输入邮件内容（可选）" 
                            rows={4}
                        />
                    </Form.Item>
                    
                    <div style={{ textAlign: 'right' }}>
                        <Button 
                            style={{ marginRight: 8 }} 
                            onClick={() => setShowTestEmailDialog(false)}
                        >
                            取消
                        </Button>
                        <Button 
                            type="primary" 
                            loading={testEmailLoading}
                            onClick={handleSendTestEmail}
                        >
                            发送
                        </Button>
                    </div>
                </Form>
            </Modal>
            </Spin>
        </div>
    );
}

export default EmailSettings;
