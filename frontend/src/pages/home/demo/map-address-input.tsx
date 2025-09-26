import { useState } from "react";
import { createFileRoute } from '@tanstack/react-router'
import { Card, Form, Button, Space, Typography, Divider, App, Row, Col } from "antd";
import MapAddressInput, { type IDeviceAddressValue } from "@/components/amap/MapAddressInput";

const { Title, Text, Paragraph } = Typography;

export const Route = createFileRoute('/home/demo/map-address-input')({
    component: RouteComponent
})

function RouteComponent() {
    const [form] = Form.useForm();
    const [selectedValue, setSelectedValue] = useState<IDeviceAddressValue>();
    const { message } = App.useApp();
    const handleSubmit = () => {
        form.validateFields().then((values) => {
            console.log("表单数据:", values);
            if (values.deviceAddress) {
                message.success("提交成功，请查看控制台");
            } else {
                message.warning("请完整填写地图地址信息");
            }
        });
    };

    const handleReset = () => {
        form.resetFields();
        setSelectedValue(undefined);
        message.info("已重置表单");
    };

    const handleLoadTestData = () => {
        const testData: IDeviceAddressValue = {
            code: "110105",
            street: "东华门街道",
            address: "北京市朝阳区望京SOHO T3",
            location: "116.481499,39.996572"
        };
        form.setFieldsValue({
            deviceAddress: testData
        });
        setSelectedValue(testData);
        message.success("已加载测试数据");
    };

    const handleValueChange = (value: IDeviceAddressValue | undefined) => {
        setSelectedValue(value);
        console.log("设备地址变化:", value);
    };

    return (
        <div className="p-6">
            <Title level={2} className="mb-6">地图地址输入组件</Title>

            <Row gutter={24}>
                <Col span={14}>
                    <Card title="地图地址录入" className="mb-6">
                        <Form
                            form={form}
                            layout="vertical"
                            onFinish={handleSubmit}
                        >
                            <Form.Item
                                name="deviceAddress"
                                label="地图地址"
                                rules={[
                                    {
                                        required: true,
                                        validator: (_, value) => {
                                            if (!value || !value.code || !value.address || !value.location) {
                                                return Promise.reject("请完整填写地图地址信息");
                                            }
                                            return Promise.resolve();
                                        }
                                    }
                                ]}
                            >
                                <MapAddressInput
                                    showStreet={true}
                                    height={400}
                                    onChange={handleValueChange}
                                />
                            </Form.Item>

                            <Form.Item>
                                <Space>
                                    <Button type="primary" htmlType="submit">
                                        提交
                                    </Button>
                                    <Button onClick={handleReset}>
                                        重置
                                    </Button>
                                    <Button onClick={handleLoadTestData}>
                                        加载测试数据
                                    </Button>
                                </Space>
                            </Form.Item>
                        </Form>
                    </Card>
                </Col>

                <Col span={10}>
                    <Card title="当前数据" className="mb-6">
                        {selectedValue ? (
                            <div className="space-y-3">
                                <div>
                                    <Text strong>行政区划代码：</Text>
                                    <Text className="ml-2">{selectedValue.code}</Text>
                                </div>
                                <div>
                                    <Text strong>街道/乡镇：</Text>
                                    <Text className="ml-2">{selectedValue.street || "无"}</Text>
                                </div>
                                <div>
                                    <Text strong>详细地址：</Text>
                                    <Paragraph className="ml-2 mb-0">{selectedValue.address}</Paragraph>
                                </div>
                                <div>
                                    <Text strong>坐标位置：</Text>
                                    <Text className="ml-2 font-mono text-xs">{selectedValue.location}</Text>
                                </div>

                                <Divider />

                                <div>
                                    <Text strong>JSON数据：</Text>
                                    <pre className="mt-2 p-3 bg-gray-100 rounded text-xs overflow-auto">
                                        {JSON.stringify(selectedValue, null, 2)}
                                    </pre>
                                </div>
                            </div>
                        ) : (
                            <div className="text-gray-400 text-center py-8">
                                暂无数据，请在左侧输入设备地址
                            </div>
                        )}
                    </Card>

                    <Card title="使用说明" className="mb-6">
                        <div className="space-y-2 text-sm">
                            <Paragraph>
                                <Text strong>组件功能：</Text>
                            </Paragraph>
                            <ul className="list-disc pl-5 space-y-1">
                                <li>整合行政区划选择、地址搜索和地图定位</li>
                                <li>三种输入方式相互联动，自动同步</li>
                                <li>支持数据回填，适用于编辑场景</li>
                                <li>提供完整的地址信息和精确坐标</li>
                            </ul>

                            <Paragraph className="mt-4">
                                <Text strong>操作方式：</Text>
                            </Paragraph>
                            <ol className="list-decimal pl-5 space-y-1">
                                <li>选择行政区划：限定搜索范围，地图自动定位到区域中心</li>
                                <li>搜索详细地址：在限定城市内搜索，选择后地图自动定位</li>
                                <li>拖动地图：直接在地图上选择位置，自动获取地址信息</li>
                            </ol>

                            <Paragraph className="mt-4">
                                <Text strong>提交数据格式：</Text>
                            </Paragraph>
                            <pre className="p-2 bg-gray-100 rounded text-xs">
{`{
  code: string;     // 行政区划代码
  street: string;   // 街道
  address: string;  // 详细地址
  location: string; // 经纬度
}`}
                            </pre>
                        </div>
                    </Card>
                </Col>
            </Row>

            <Card title="组件特性" className="mb-6">
                <Row gutter={16}>
                    <Col span={8}>
                        <div className="text-sm space-y-2">
                            <Text strong className="text-blue-600">🎯 精确定位</Text>
                            <ul className="list-disc pl-5 space-y-1 text-gray-600">
                                <li>支持地图拖拽选点</li>
                                <li>自动逆地理编码</li>
                                <li>经纬度精确到小数点后6位</li>
                            </ul>
                        </div>
                    </Col>
                    <Col span={8}>
                        <div className="text-sm space-y-2">
                            <Text strong className="text-green-600">🔄 智能联动</Text>
                            <ul className="list-disc pl-5 space-y-1 text-gray-600">
                                <li>行政区划限定搜索范围</li>
                                <li>地址选择自动更新地图</li>
                                <li>地图拖动自动识别地址</li>
                            </ul>
                        </div>
                    </Col>
                    <Col span={8}>
                        <div className="text-sm space-y-2">
                            <Text strong className="text-orange-600">📝 数据完整</Text>
                            <ul className="list-disc pl-5 space-y-1 text-gray-600">
                                <li>行政区划代码</li>
                                <li>街道信息</li>
                                <li>详细地址和坐标</li>
                            </ul>
                        </div>
                    </Col>
                </Row>
            </Card>
        </div>
    );
}