import { createFileRoute } from '@tanstack/react-router'
import { Form, Button, Typography, Spin, App, Input, ColorPicker, Space } from 'antd';
import { useState, useRef } from 'react';
import { useAsyncEffect } from 'ahooks';
import { fetchSiteSettings, type ISiteSettings, updateSiteSettings } from './-service';
import useThemeStore from '@/application/themeStore';
import type { Color } from 'antd/es/color-picker';

const { Title } = Typography;

export const Route = createFileRoute('/admin/settings/site')({
    component: SiteSettings
})

function SiteSettings() {
    const [form] = Form.useForm();
    const [loading, setLoading] = useState(false);
    const [pageLoading, setPageLoading] = useState(true);
    const [settings, setSettings] = useState<ISiteSettings | null>(null);
    const originalColor = useRef<string>('');
    const [isPreviewing, setIsPreviewing] = useState(false);
    const { message } = App.useApp();
    const { setThemeColor } = useThemeStore();

    useAsyncEffect(async () => {
        try {
            const settingsData = await fetchSiteSettings();
            setSettings(settingsData);
            originalColor.current = settingsData.primaryColor || '';
            form.setFieldsValue(settingsData);
        } catch {
            message.error('获取站点设置失败');
        } finally {
            setPageLoading(false);
        }
    }, [form, message]);

    const handleSubmit = async (values: ISiteSettings) => {
        setLoading(true);
        try {
            // 确保primaryColor是字符串格式
            const submitData = {
                ...values,
                primaryColor: typeof values.primaryColor === 'string'
                    ? values.primaryColor
                    : (values.primaryColor as Color)?.toHexString() || ''
            };
            await updateSiteSettings(submitData);
            message.success('更新站点设置成功');
            // 更新原始颜色，取消预览状态
            originalColor.current = submitData.primaryColor;
            setIsPreviewing(false);
        } catch {
            message.error('更新站点设置失败');
        } finally {
            setLoading(false);
        }
    };


    const handleFormValuesChange = (changedValues: any) => {
        if (changedValues.primaryColor) {
            const color = changedValues.primaryColor;
            const hexColor = typeof color === 'string' ? color : color.toHexString();
            setThemeColor(hexColor);
            setIsPreviewing(true);
        }
    };

    const handleColorReset = () => {
        if (originalColor.current) {
            setThemeColor(originalColor.current);
            form.setFieldValue('primaryColor', originalColor.current);
            setIsPreviewing(false);
        }
    };

    return (
        <Spin spinning={pageLoading} tip="加载中...">
            <Title level={3} className="text-center mb-8">
                站点设置
            </Title>
            <Form
                form={form}
                layout="vertical"
                onFinish={handleSubmit}
                initialValues={settings || {}}
                onValuesChange={handleFormValuesChange}
            >
                <Form.Item
                    name="siteUrl"
                    label="网站URL"
                    rules={[
                        { type: 'url', message: '请输入正确的URL' },
                    ]}
                    extra="用于生成对外分享链接时使用，例如：https://www.example.com"
                >
                    <Input />
                </Form.Item>

                <Form.Item
                    name="title"
                    label="网站标题"
                    rules={[{ required: true, message: '请输入站点标题' }]}
                >
                    <Input />
                </Form.Item>

                <Form.Item
                    name="favicon"
                    label="网站图标"
                    extra="在浏览器标签页显示的图标"
                >
                    <Input />
                </Form.Item>

                <Form.Item
                    name="logo"
                    label="网站Logo"
                    extra="在网页中显示的Logo"
                >
                    <Input />
                </Form.Item>

                <Form.Item
                    name="logoText"
                    label="网站Logo文本"
                    extra="网页中显示Logo右边的标题"
                >
                    <Input />
                </Form.Item>

                <Form.Item
                    name="copyright"
                    label="网站版权"
                    rules={[{ required: true, message: '请输入网站版权' }]}
                    extra="支持%YEAR%占位符，表示当前年份"
                >
                    <Input />
                </Form.Item>

                <Form.Item
                    name="icp"
                    label="ICP备案号"
                >
                    <Input placeholder="例如：粤ICP备2025000000号" />
                </Form.Item>

                <Form.Item
                    name="description"
                    label="网站描述"
                >
                    <Input.TextArea />
                </Form.Item>

                <Form.Item
                    name="keywords"
                    label="网站关键词"
                >
                    <Input.TextArea />
                </Form.Item>

                <Form.Item
                    name="primaryColor"
                    label="网站主色调"
                    rules={[{ required: true, message: '请选择网站主色调' }]}
                >
                    <Space>
                        <Form.Item name="primaryColor" noStyle>
                            <ColorPicker size="large" showText />
                        </Form.Item>
                        {isPreviewing && (
                            <Button size="small" type="text" onClick={handleColorReset}>
                                还原
                            </Button>
                        )}
                    </Space>
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
