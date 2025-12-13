

import { Form, Input, Button } from 'antd';
import { ExportOutlined } from '@ant-design/icons';
import { useAsyncEffect } from 'ahooks';

export interface IAmapSettings {
    isEnabled: boolean;
    apiKey: string;
    securityJsCode: string;
}

interface IAmapSettingsProps {
    loading: boolean;
    saving: boolean;
    isError: boolean;
    onRequest: () => Promise<IAmapSettings | undefined>;
    onSave: (config: IAmapSettings) => Promise<void>;
}

export default function AmapSettings({ loading, saving, isError, onRequest, onSave }: IAmapSettingsProps) {
    const [form] = Form.useForm<IAmapSettings>();

    // 保存配置
    const handleSave = async () => {
        const values = await form.validateFields();
        await onSave(values);
    };

    useAsyncEffect(async () => {
        const data = await onRequest();
        if (data) {
            form.setFieldsValue(data);
        }
    }, []);


    return (
        <Form
            form={form}
            layout="vertical"
            className="space-y-4"
            onFinish={handleSave}
        >
            <Form.Item
                name="apiKey"
                label="API Key"
                rules={[{ required: true, message: '请输入高德地图API密钥' }]}
                extra={<a title="高德地图API密钥申请" href="https://lbs.amap.com/api/javascript-api/guide/abc/prepare" target="_blank" rel="noopener noreferrer">高德地图API密钥申请 <ExportOutlined /> </a>}
            >
                <Input.Password />
            </Form.Item>

            <Form.Item
                name="securityJsCode"
                label="安全密钥"
                rules={[{ required: true, message: '请输入高德地图安全密钥' }]}
            >
                <Input.Password />
            </Form.Item>

            <div className="flex justify-end pt-2">
                <Button
                    type="primary"
                    htmlType='submit'
                    loading={saving}
                    disabled={isError || loading}
                >
                    {saving ? '保存中...' : '保存配置'}
                </Button>
            </div>
        </Form>
    );
}