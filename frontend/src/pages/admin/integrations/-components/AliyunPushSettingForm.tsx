import { Form, Input, Button, Card, Row, Col, message } from "antd";
import { ExportOutlined, PlusOutlined, MinusCircleOutlined } from "@ant-design/icons";
import { useAsyncEffect } from "ahooks";

export interface IAliyunPushApp {
    appName: string;
    packageName: string;
    appKey: string;
    appSecret: string;
}

export interface IAliyunPushSettings {
    endpoint: string;
    regionId: string;
    accessKeyId: string;
    accessKeySecret: string;
    apps: IAliyunPushApp[];
}

interface IAliyunPushSettingsProps {
    loading: boolean;
    saving: boolean;
    isError: boolean;
    onRequest: () => Promise<IAliyunPushSettings | undefined>;
    onSave: (config: IAliyunPushSettings) => Promise<void>;
}

export default function AliyunPushSettingForm({
    loading,
    saving,
    isError,
    onRequest,
    onSave
}: IAliyunPushSettingsProps) {
    const [form] = Form.useForm<IAliyunPushSettings>();

    const handleSave = async () => {
        try {
            const values = await form.validateFields();

            // 验证至少有一个应用
            if (!values.apps || values.apps.length === 0) {
                message.error("至少需要配置一个应用");
                return;
            }

            await onSave(values);
        } catch (error) {
            console.error("表单验证失败:", error);
        }
    };

    useAsyncEffect(async () => {
        const data = await onRequest();
        if (data) {
            // 确保 apps 字段存在
            if (!data.apps) {
                data.apps = [];
            }
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
            {/* 阿里云账号配置 */}
            <Card title="阿里云账号配置" size="small" className="mb-4">
                <Form.Item
                    name="endpoint"
                    label="Endpoint（接入点）"
                    rules={[
                        { required: true, message: "请输入阿里云移动推送Endpoint" }
                    ]}
                    extra={
                        <a
                            title="阿里云移动推送服务接入点"
                            href="https://help.aliyun.com/document_detail/2249911.html"
                            target="_blank"
                            rel="noopener noreferrer"
                        >
                            查看阿里移动云推送文档 <ExportOutlined />
                        </a>
                    }
                >
                    <Input placeholder="例如：cloudpush.aliyuncs.com" />
                </Form.Item>

                <Form.Item
                    name="regionId"
                    label="地域ID"
                    rules={[{ required: true, message: "请输入Region ID" }]}
                >
                    <Input placeholder="例如：cn-hangzhou" />
                </Form.Item>

                <Form.Item
                    name="accessKeyId"
                    label="AccessKey ID"
                    rules={[{ required: true, message: "请输入AccessKey ID" }]}
                >
                    <Input.Password placeholder="请输入AccessKey ID" />
                </Form.Item>

                <Form.Item
                    name="accessKeySecret"
                    label="AccessKey Secret"
                    rules={[{ required: true, message: "请输入AccessKey Secret" }]}
                >
                    <Input.Password placeholder="请输入AccessKey Secret" />
                </Form.Item>
            </Card>

            {/* 应用配置列表 */}
            <Card
                title="应用配置"
                size="small"
                extra={
                    <a
                        title="阿里云移动推送应用配置"
                        href="https://emas.console.aliyun.com/projects"
                        target="_blank"
                        rel="noopener noreferrer"
                    >
                        阿里移动云推送项目管理 <ExportOutlined />
                    </a>
                }
            >
                <Form.List name="apps">
                    {(fields, { add, remove }) => (
                        <>
                            {fields.map(({ key, name, ...restField }) => (
                                <Card
                                    key={key}
                                    size="small"
                                    className="mb-4"
                                    title={`应用 ${name + 1}`}
                                    extra={
                                        <Button
                                            type="text"
                                            danger
                                            icon={<MinusCircleOutlined />}
                                            onClick={() => remove(name)}
                                        >
                                            删除
                                        </Button>
                                    }
                                >
                                    <Row gutter={16}>
                                        <Col span={12}>
                                            <Form.Item
                                                {...restField}
                                                name={[name, 'appName']}
                                                label="应用名称"
                                                rules={[{ required: true, message: "请输入应用名称" }]}
                                            >
                                                <Input placeholder="例如：乐土APP" />
                                            </Form.Item>
                                        </Col>
                                        <Col span={12}>
                                            <Form.Item
                                                {...restField}
                                                name={[name, 'packageName']}
                                                label="包名"
                                                rules={[{ required: true, message: "请输入包名" }]}
                                            >
                                                <Input placeholder="例如：com.letu.app" />
                                            </Form.Item>
                                        </Col>
                                    </Row>

                                    <Row gutter={16}>
                                        <Col span={12}>
                                            <Form.Item
                                                {...restField}
                                                name={[name, 'appKey']}
                                                label="AppKey"
                                                rules={[{ required: true, message: "请输入AppKey" }]}
                                            >
                                                <Input placeholder="请输入应用AppKey" />
                                            </Form.Item>
                                        </Col>
                                        <Col span={12}>
                                            <Form.Item
                                                {...restField}
                                                name={[name, 'appSecret']}
                                                label="AppSecret"
                                                rules={[{ required: true, message: "请输入AppSecret" }]}
                                            >
                                                <Input.Password placeholder="请输入应用AppSecret" />
                                            </Form.Item>
                                        </Col>
                                    </Row>
                                </Card>
                            ))}

                            <Button
                                type="dashed"
                                onClick={() => add()}
                                block
                                icon={<PlusOutlined />}
                            >
                                添加应用
                            </Button>
                        </>
                    )}
                </Form.List>
            </Card>

            {/* 保存按钮 */}
            <div className="flex justify-end pt-2">
                <Button
                    type="primary"
                    htmlType="submit"
                    loading={saving}
                    disabled={isError || loading}
                >
                    {saving ? "保存中..." : "保存配置"}
                </Button>
            </div>
        </Form>
    );
}
