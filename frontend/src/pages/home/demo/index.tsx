import { createFileRoute } from '@tanstack/react-router';
import { Card, Form, Button, Space, message } from 'antd';
import RegionSelect from '@/components/RegionSelect';
import { useState } from 'react';

export const Route = createFileRoute('/home/demo/')({
    component: TestPage
});

function TestPage() {
    const [form] = Form.useForm();
    const [selectedRegion, setSelectedRegion] = useState<string | undefined>("");
    const [editRegion, setEditRegion] = useState<string>("");

    const handleBasicChange = (code?: string) => {
        setSelectedRegion(code);
        message.info(`选择的区域代码: ${code}`);
    };

    const handleFormSubmit = (values: any) => {
        console.log("表单数据:", values);
        console.log("区域字段值:", values.region);
        console.log("区域字段类型:", typeof values.region);
        
        if (!values.region) {
            message.error("请选择所在地区");
            return;
        }
        
        message.success(`表单提交成功，区域代码: ${values.region}`);
    };

    const handleSimulateEdit = () => {
        const beijingDongchengStreet = "140123"; // 娄烦县
        setEditRegion(beijingDongchengStreet);
        form.setFieldsValue({ editRegion: beijingDongchengStreet });
        message.info("已加载山西省娄烦县的数据");
    };

    const handleSimulateDirectCity = () => {
        // 模拟直辖市场景（如果有的话）
        const shanghaiStreet = "310101"; // 直辖市
        setEditRegion(shanghaiStreet);
        form.setFieldsValue({ directCity: shanghaiStreet });
        message.info("已加载上海市黄浦区街道数据");
    };

    return (
        <div className="p-6">
            <h1 className="text-2xl font-bold mb-6">行政区域选择组件测试</h1>
            
            <Space direction="vertical" size="large" className="w-full">
                {/* 基础用法 */}
                <Card title="基础用法">
                    <div className="mb-4">
                        <p className="text-gray-600 mb-2">选择省、市、区县、街道四级行政区域</p>
                        <RegionSelect 
                            value={selectedRegion}
                            onChange={handleBasicChange}
                            placeholder="请选择地区"
                        />
                    </div>
                    {selectedRegion && (
                        <div className="mt-4 p-3 bg-gray-50 rounded">
                            <span className="font-semibold">当前选中：</span>
                            <span className="ml-2 text-blue-600">{selectedRegion}</span>
                        </div>
                    )}
                </Card>

                {/* 表单集成 */}
                <Card title="表单集成">
                    <Form
                        layout="vertical"
                        onFinish={handleFormSubmit}
                        onValuesChange={(changedValues, allValues) => {
                            console.log("表单值变化:", changedValues, allValues);
                            if (changedValues.region === undefined) {
                                console.log("地区选择已清空，表单验证应该失败");
                            }
                        }}
                    >
                        <Form.Item
                            label="所在地区"
                            name="region"
                            rules={[{ required: true, message: "请选择所在地区" }]}
                        >
                            <RegionSelect placeholder="请选择所在地区" />
                        </Form.Item>
                        
                        <Form.Item>
                            <Button type="primary" htmlType="submit">
                                提交表单
                            </Button>
                        </Form.Item>
                    </Form>
                </Card>

                {/* 数据回填 */}
                <Card title="数据回填（编辑模式）">
                    <div className="mb-4">
                        <p className="text-gray-600 mb-4">模拟编辑场景，自动回填已保存的地区数据</p>
                        <Space direction="vertical" className="w-full">
                            <div>
                                <Button onClick={handleSimulateEdit} className="mb-3">
                                    加载山西省娄烦县数据
                                </Button>
                                <Form form={form}>
                                    <Form.Item name="editRegion">
                                        <RegionSelect 
                                            placeholder="编辑模式地区选择"
                                        />
                                    </Form.Item>
                                </Form>
                            </div>
                        </Space>
                    </div>
                </Card>

                {/* 特殊场景 */}
                <Card title="特殊场景">
                    <div className="mb-4">
                        <p className="text-gray-600 mb-4">处理直辖市等特殊情况（某些市可能没有区县级）</p>
                        <Space direction="vertical" className="w-full">
                            <div>
                                <Button onClick={handleSimulateDirectCity} className="mb-3">
                                    加载直辖市数据
                                </Button>
                                <Form form={form}>
                                    <Form.Item name="directCity">
                                        <RegionSelect 
                                            placeholder="直辖市地区选择"
                                        />
                                    </Form.Item>
                                </Form>
                            </div>
                        </Space>
                    </div>
                </Card>

                {/* 禁用状态 */}
                <Card title="禁用状态">
                    <div className="mb-4">
                        <p className="text-gray-600 mb-2">组件的禁用状态展示</p>
                        <RegionSelect 
                            disabled
                            placeholder="已禁用的地区选择"
                        />
                    </div>
                </Card>
            </Space>
        </div>
    );
}
