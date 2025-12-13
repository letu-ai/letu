import { createFileRoute } from "@tanstack/react-router";
import { Card, Form, Button, Space, App } from "antd";
import RegionSelect, { type IRegionSelectValue } from "@/components/RegionSelect";
import RegionSelectFormItem from "@/components/RegionSelectFormItem";
import { useState } from "react";

export const Route = createFileRoute("/home/demo/region-select")({
    component: TestPage
});

// 基础用法演示组件
function BasicUsageDemo() {
    const [selectedRegion, setSelectedRegion] = useState<IRegionSelectValue | undefined>();
    const { message } = App.useApp();

    const handleBasicChange = (value?: IRegionSelectValue) => {
        setSelectedRegion(value);
        if (value) {
            message.info(`选择的区域代码: ${value.code}, 街道: ${value.street || "未选择"}`);
        } else {
            message.info("已清空选择");
        }
    };

    return (
        <Card title="基础用法">
            <div className="mb-4">
                <p className="text-gray-600 mb-2">选择省、市、区县（不含街道）</p>
                <RegionSelect
                    value={selectedRegion}
                    onChange={handleBasicChange}
                    placeholder="请选择地区"
                    showStreet={false}
                />
            </div>
            {selectedRegion && (
                <div className="mt-4 p-3 bg-gray-50 rounded">
                    <span className="font-semibold">当前选中：</span>
                    <span className="ml-2 text-blue-600">代码: {selectedRegion.code}</span>
                </div>
            )}
        </Card>
    );
}

// 基础用法演示组件 包含街道选择
function BasicUsageDemoWithStreet() {
    const [selectedRegion, setSelectedRegion] = useState<IRegionSelectValue | undefined>();
    const { message } = App.useApp();

    const handleBasicChange = (value?: IRegionSelectValue) => {
        setSelectedRegion(value);
        if (value) {
            message.info(`选择的区域代码: ${value.code}, 街道: ${value.street || "未选择"}`);
        } else {
            message.info("已清空选择");
        }
    };

    return (
        <Card title="包含街道选择">
            <div className="mb-4">
                <p className="text-gray-600 mb-2">选择省、市、区县、街道四级行政区域</p>
                <RegionSelect
                    value={selectedRegion}
                    onChange={handleBasicChange}
                    placeholder="请选择地区"
                    showStreet={true}
                />
            </div>
            {selectedRegion && (
                <div className="mt-4 p-3 bg-gray-50 rounded">
                    <span className="font-semibold">当前选中：</span>
                    <span className="ml-2 text-blue-600">
                        代码: {selectedRegion.code}
                        {selectedRegion.street && `, 街道: ${selectedRegion.street}`}
                    </span>
                </div>
            )}
        </Card>
    );
}

// 表单集成演示组件
function FormIntegrationDemo() {
    const { message } = App.useApp();

    const handleFormSubmit = (values: any) => {
        console.log("表单数据:", values);
        console.log("地区对象:", values.region);

        if (!values.region?.code) {
            message.error("请选择所在地区");
            return;
        }

        message.success(
            `表单提交成功，区域代码: ${values.region.code}, 街道: ${values.region.street || "无"}`
        );
    };

    return (
        <Card title="表单集成（使用RegionSelectFormItem）">
            <Form
                layout="vertical"
                onFinish={handleFormSubmit}
                onValuesChange={(changedValues, allValues) => {
                    console.log("表单值变化:", changedValues, allValues);
                }}
            >
                <RegionSelectFormItem
                    name="region"
                    label="所在地区"
                    showStreet={true}
                    required
                />

                <Form.Item>
                    <Button type="primary" htmlType="submit">
                        提交表单
                    </Button>
                </Form.Item>
            </Form>
        </Card>
    );
}

// 数据回填演示组件
function DataBackfillDemo() {
    const [form] = Form.useForm();
    const { message } = App.useApp();

    const handleSimulateEdit = () => {
        const loufanData: IRegionSelectValue = {
            code: "152526",
            street: "巴拉嘎尔高勒镇"
        };
        form.setFieldsValue({
            editRegion: loufanData
        });
        message.info("已加载内蒙古自治区锡林郭勒盟镶黄旗巴拉嘎尔高勒镇的数据");
    };

    const handleFormSubmit = (values: any) => {
        console.log("编辑表单数据:", values);
        message.success("编辑表单提交成功");
    };

    return (
        <Card title="数据回填（编辑模式）">
            <div className="mb-4">
                <p className="text-gray-600 mb-4">模拟编辑场景，自动回填已保存的地区数据</p>
                <Space orientation="vertical" className="w-full">
                    <div>
                        <Button onClick={handleSimulateEdit} className="mb-3">
                            加载内蒙古自治区锡林郭勒盟镶黄旗数据
                        </Button>
                        <Form form={form} onFinish={handleFormSubmit}>
                            <RegionSelectFormItem
                                name="editRegion"
                                showStreet={true}
                                placeholder="编辑模式地区选择"
                            />
                            <Form.Item>
                                <Button type="primary" htmlType="submit">
                                    保存修改
                                </Button>
                            </Form.Item>
                        </Form>
                    </div>
                </Space>
            </div>
        </Card>
    );
}

// 特殊场景演示组件
function SpecialCasesDemo() {
    const [form] = Form.useForm();
    const { message } = App.useApp();

    const handleSimulateDirectCity = () => {
        const shanghaiData: IRegionSelectValue = {
            code: "310101",
            street: "外滩街道"
        };
        form.setFieldsValue({
            directCity: shanghaiData
        });
        message.info("已加载上海市黄浦区外滩街道数据");
    };

    const handleSimulateNoStreet = () => {
        // 模拟一个没有街道层级的区域 - 使用不同的区域代码以触发更新
        const noStreetData: IRegionSelectValue = {
            code: "440303",  // 深圳市罗湖区
            street: "" // 空字符串表示该区域无街道层级
        };
        form.setFieldsValue({
            directCity: noStreetData
        });
        message.info("已加载深圳市罗湖区（模拟无街道层级）的数据");
    };

    return (
        <Card title="特殊场景">
            <div className="mb-4">
                <p className="text-gray-600 mb-4">处理直辖市等特殊情况（某些市可能没有区县级）</p>
                <Space orientation="vertical" className="w-full">
                    <div>
                        <Space>
                            <Button onClick={handleSimulateDirectCity}>
                                加载直辖市数据
                            </Button>
                            <Button onClick={handleSimulateNoStreet}>
                                加载无街道层级数据
                            </Button>
                        </Space>
                        <Form form={form} className="mt-3">
                            <RegionSelectFormItem
                                name="directCity"
                                showStreet={true}
                                placeholder="直辖市地区选择"
                                required
                            />
                        </Form>
                    </div>
                </Space>
            </div>
        </Card>
    );
}

// 多个表单项演示
function MultipleFieldsDemo() {
    const [form] = Form.useForm();
    const { message } = App.useApp();

    const handleFormSubmit = (values: any) => {
        console.log("多地址表单数据:", values);
        message.success("多地址表单提交成功");
    };

    return (
        <Card title="多个地区字段">
            <Form
                form={form}
                layout="vertical"
                onFinish={handleFormSubmit}
                initialValues={{
                    homeAddress: { code: "110101", street: "东华门街道" },
                    workAddress: { code: "310101", street: "外滩街道" }
                }}
            >
                <RegionSelectFormItem
                    name="homeAddress"
                    label="家庭地址"
                    showStreet={true}
                    required
                />

                <RegionSelectFormItem
                    name="workAddress"
                    label="工作地址"
                    showStreet={true}
                    required
                />

                <RegionSelectFormItem
                    name="otherAddress"
                    label="其他地址"
                    showStreet={false}
                    required={false}
                />

                <Form.Item>
                    <Space>
                        <Button type="primary" htmlType="submit">
                            提交表单
                        </Button>
                        <Button onClick={() => {
                            const values = form.getFieldsValue();
                            console.log("当前表单值:", values);
                            message.info("请查看控制台");
                        }}>
                            查看表单值
                        </Button>
                    </Space>
                </Form.Item>
            </Form>
        </Card>
    );
}

// 禁用状态演示组件
function DisabledStateDemo() {
    return (
        <Card title="禁用状态">
            <div className="mb-4">
                <p className="text-gray-600 mb-2">组件的禁用状态展示</p>
                <RegionSelect
                    disabled
                    showStreet={true}
                    placeholder="已禁用的地区选择"
                />
            </div>
        </Card>
    );
}

// 主页面组件
function TestPage() {
    return (
        <div className="p-6">
            <h1 className="text-2xl font-bold mb-6">行政区域选择组件测试</h1>

            <Space orientation="vertical" size="large" className="w-full">
                <BasicUsageDemo />
                <BasicUsageDemoWithStreet />
                <FormIntegrationDemo />
                <DataBackfillDemo />
                <SpecialCasesDemo />
                <MultipleFieldsDemo />
                <DisabledStateDemo />
            </Space>
        </div>
    );
}