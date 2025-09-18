import { createFileRoute } from '@tanstack/react-router';
import { Form, Button, Typography, Spin, App, Input } from 'antd';
import { fetchAmapSettings, updateAmapSettings, type IAmapSettings } from './-service';
import { useState } from 'react';
import { useAsyncEffect } from 'ahooks';
import { ExportOutlined } from '@ant-design/icons';

const { Title } = Typography;

export const Route = createFileRoute('/admin/settings/amap')({
    component: AmapSettings
});

function AmapSettings() {
    const [form] = Form.useForm();
    const [loading, setLoading] = useState(false);
    const [pageLoading, setPageLoading] = useState(true);
    const [settings, setSettings] = useState<IAmapSettings>();
    const { message } = App.useApp();

    useAsyncEffect(async () => {
        try {
            const settingsData = await fetchAmapSettings();
            setSettings(settingsData);

            form.setFieldsValue(settingsData);
        } catch {
            message.error('获取高德地图设置失败');
        } finally {
            setPageLoading(false);
        }
    }, [form, message]);

    const handleSubmit = async (values: IAmapSettings) => {
        setLoading(true);
        try {
            await updateAmapSettings(values);
            message.success('更新高德地图设置成功');
        } catch {
            message.error('更新高德地图设置失败');
        } finally {
            setLoading(false);
        }
    };

    return (
        <Spin spinning={pageLoading} tip="加载中...">
            <Title level={3} className="text-center mb-8">
                高德地图服务
            </Title>
            <Form
                form={form}
                layout="vertical"
                onFinish={handleSubmit}
                initialValues={{
                    apiKey: settings?.apiKey,
                    securityJsCode: settings?.securityJsCode
                }}

            >
                <Form.Item
                    name="apiKey"
                    label="API Key"
                    rules={[{ required: true, message: '请输入高德地图API密钥' }]}
                    help={<a href="https://lbs.amap.com/api/javascript-api/guide/abc/prepare" target="_blank">高德地图API密钥申请 <ExportOutlined /> </a>}
                >
                    <Input />
                </Form.Item>

                <Form.Item
                    name="securityJsCode"
                    label="安全密钥"
                    rules={[{ required: true, message: '请输入高德地图安全密钥' }]}
                >
                    <Input />
                </Form.Item>

                <div className="text-center mt-16">
                    <Button type="primary" htmlType="submit" loading={loading}>
                        保存
                    </Button>
                </div>
            </Form>
        </Spin>
    );
}