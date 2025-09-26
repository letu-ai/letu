

import { Form, Input, Button } from 'antd';
import { useAsyncEffect } from 'ahooks';

export interface IFastgptSettings {
    baseUrl: string;
    apiKey: string;
}

interface IFastgptSettingsProps {
    loading: boolean;
    saving: boolean;
    isError: boolean;
    onRequest: () => Promise<IFastgptSettings | undefined>;
    onSave: (config: IFastgptSettings) => Promise<void>;
}

export default function AmapSettings({ loading, saving, isError, onRequest, onSave }: IFastgptSettingsProps) {
    const [form] = Form.useForm<IFastgptSettings>();

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
                name="baseUrl"
                label="Base URL"
                rules={[{ required: true, message: '请输入FastGPT Base URL' }]}
            >
                <Input />
            </Form.Item>

            <Form.Item
                name="apiKey"
                label="API Key"
                rules={[{ required: true, message: '请输入FastGPT API密钥' }]}
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