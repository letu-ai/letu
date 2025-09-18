import { useState } from "react";
import { Form, Button, Card, Space, Input, Row, Col, App } from "antd";
import { createFileRoute } from '@tanstack/react-router'
import AddressPicker from "@/components/amap/AddressPicker";
import type { IAddressPickerValue } from "@/components/amap/service";

export const Route = createFileRoute('/home/demo/address-picker')({
    component: RouteComponent,
})

function RouteComponent() {
    const [form] = Form.useForm();
    const [cityForm] = Form.useForm();
    const [selectedAddress, setSelectedAddress] = useState<IAddressPickerValue>();
    const [cityLimit, setCityLimit] = useState<string>("");
    const { message } = App.useApp();

    const handleSubmit = () => {
        form.validateFields().then((values) => {
            console.log("表单数据:", values);
            message.success("提交成功，请查看控制台");
        });
    };

    const handleAddressChange = (value: IAddressPickerValue | undefined) => {
        setSelectedAddress(value);
        console.log("选择的地址:", value);
    };

    const handleCitySubmit = () => {
        cityForm.validateFields().then((values) => {
            setCityLimit(values.city || "");
            message.success(values.city ? `已限制搜索范围为：${values.city}` : "已取消城市限制");
        });
    };

    const handleLoadTestData = () => {
        form.setFieldsValue({
            address: {
                name: "北京市朝阳区望京SOHO",
                address: "北京市朝阳区望京街道望京SOHO",
                location: "116.480983,39.996385",
                province: "北京市",
                city: "北京市",
                district: "朝阳区",
                adCode: "110105"
            }
        });
        message.success("已加载测试数据");
    };

    return (
        <div className="p-6">
            <Card title="地址选择器组件示例" className="max-w-6xl mx-auto">
                <Row gutter={16}>
                    <Col span={12}>
                        <Card title="基础功能演示" size="small" className="mb-4">
                            <Form
                                form={form}
                                layout="vertical"
                                initialValues={{
                                    address: null
                                }}
                            >
                                <Form.Item
                                    label="选择地址"
                                    name="address"
                                    rules={[{ required: true, message: "请选择地址" }]}
                                >
                                    <AddressPicker
                                        placeholder="请输入地址关键字搜索"
                                        onChange={handleAddressChange}
                                        city={cityLimit}
                                    />
                                </Form.Item>

                                <Space className="mt-4">
                                    <Button type="primary" onClick={handleSubmit}>
                                        提交
                                    </Button>
                                    <Button onClick={() => form.resetFields()}>
                                        重置
                                    </Button>
                                    <Button onClick={handleLoadTestData}>
                                        加载测试数据
                                    </Button>
                                </Space>
                            </Form>
                        </Card>

                        <Card title="城市范围限制" size="small" className="mb-4">
                            <Form
                                form={cityForm}
                                layout="vertical"
                                onFinish={handleCitySubmit}
                            >
                                <Form.Item
                                    label="限制城市"
                                    name="city"
                                    tooltip="输入城市名称可以限制搜索范围，例如：北京、上海"
                                >
                                    <Input
                                        placeholder="输入城市名称，如：北京、上海"
                                        onPressEnter={handleCitySubmit}
                                    />
                                </Form.Item>
                                <Space>
                                    <Button type="primary" htmlType="submit">
                                        设置城市限制
                                    </Button>
                                    <Button onClick={() => {
                                        cityForm.resetFields();
                                        setCityLimit("");
                                        message.success("已取消城市限制");
                                    }}>
                                        取消限制
                                    </Button>
                                </Space>
                                {cityLimit && (
                                    <div className="mt-2 text-sm text-blue-600">
                                        当前限制搜索范围：{cityLimit}
                                    </div>
                                )}
                            </Form>
                        </Card>
                    </Col>

                    <Col span={12}>
                        {selectedAddress && (
                            <Card title="当前选择的地址信息" className="mb-4" size="small" type="inner">
                                <div className="space-y-2 text-sm">
                                    <div className="flex">
                                        <span className="font-medium w-24">名称：</span>
                                        <span className="flex-1">{selectedAddress.name || "-"}</span>
                                    </div>
                                    <div className="flex">
                                        <span className="font-medium w-24">详细地址：</span>
                                        <span className="flex-1">{selectedAddress.address}</span>
                                    </div>
                                    <div className="flex">
                                        <span className="font-medium w-24">经纬度：</span>
                                        <span className="flex-1 font-mono text-xs">{selectedAddress.location}</span>
                                    </div>
                                    <div className="flex">
                                        <span className="font-medium w-24">省份：</span>
                                        <span className="flex-1">{selectedAddress.province || "-"}</span>
                                    </div>
                                    <div className="flex">
                                        <span className="font-medium w-24">城市：</span>
                                        <span className="flex-1">{selectedAddress.city || "-"}</span>
                                    </div>
                                    <div className="flex">
                                        <span className="font-medium w-24">区县：</span>
                                        <span className="flex-1">{selectedAddress.district || "-"}</span>
                                    </div>
                                    <div className="flex">
                                        <span className="font-medium w-24">行政区代码：</span>
                                        <span className="flex-1">{selectedAddress.adCode || "-"}</span>
                                    </div>
                                </div>
                            </Card>
                        )}

                        <Card title="JSON数据" size="small" type="inner">
                            <pre className="bg-gray-100 p-3 rounded text-xs overflow-x-auto max-h-64 overflow-y-auto">
                                {JSON.stringify(selectedAddress || null, null, 2)}
                            </pre>
                        </Card>
                    </Col>
                </Row>

                <Card title="组件功能说明" className="mt-4" size="small" type="inner">
                    <div className="grid grid-cols-2 gap-4 text-sm">
                        <div className="space-y-2">
                            <h4 className="font-medium mb-2">核心功能：</h4>
                            <p>✅ <strong>关键字搜索</strong>：输入地址关键字，自动搜索并显示匹配结果</p>
                            <p>✅ <strong>防抖优化</strong>：输入停止500ms后才触发搜索，避免频繁请求</p>
                            <p>✅ <strong>详细信息</strong>：搜索结果包含完整的地址信息和行政区域代码</p>
                            <p>✅ <strong>数据回填</strong>：支持服务端数据回填，不触发额外搜索</p>
                        </div>
                        <div className="space-y-2">
                            <h4 className="font-medium mb-2">特色功能：</h4>
                            <p>✅ <strong>城市限制</strong>：可设置城市名称限制搜索范围</p>
                            <p>✅ <strong>清除功能</strong>：点击清除按钮快速清空选择</p>
                            <p>✅ <strong>加载状态</strong>：搜索时显示加载提示</p>
                            <p>✅ <strong>空状态</strong>：无搜索结果时友好提示</p>
                        </div>
                    </div>
                </Card>

                <Card title="使用示例代码" className="mt-4" size="small" type="inner">
                    <pre className="bg-gray-100 p-3 rounded text-xs overflow-x-auto">
                        {`import AddressPicker from "@/components/amap/AddressPicker";

// 基础使用
<AddressPicker
    value={addressValue}
    onChange={handleAddressChange}
    placeholder="请输入地址搜索"
/>

// 在表单中使用
<Form.Item name="address" label="地址">
    <AddressPicker />
</Form.Item>

// 限制城市范围
<AddressPicker
    city="北京"
    placeholder="搜索北京市内的地址"
/>

// 数据结构
interface IAddressPickerValue {
    name?: string;       // POI名称
    address: string;     // 详细地址
    location: string;    // "lng,lat"
    province?: string;   // 省份
    city?: string;      // 城市
    district?: string;  // 区县
    adCode?: string;    // 行政区代码
}`}
                    </pre>
                </Card>

                <Card title="注意事项" className="mt-4" size="small" type="inner">
                    <div className="space-y-2 text-sm text-orange-600">
                        <p>⚠️ 后端需要配置高德地图API密钥才能正常使用搜索功能</p>
                        <p>⚠️ 最少输入2个字符才会触发搜索</p>
                        <p>⚠️ 搜索使用了500ms的防抖，避免频繁请求</p>
                        <p>⚠️ 城市限制功能依赖高德地图API的城市参数支持</p>
                    </div>
                </Card>
            </Card>
        </div>
    );
}