import { Modal, Menu, Input, Switch, Button, Select, message, Form, Spin } from "antd";
import { useEffect, useMemo, useState } from "react";
import { type IFeature, type IFeatureGroup, fetchFeatureGroups, updateFeature, deleteFeature } from "./service";
import { StringValueTypes } from "@/application/string-values";

const { Option } = Select;

interface IFeatureEditorProps {
    providerName: string
    providerKey?: string
    onClose: () => void
}

function FeatureEditor({ providerName, providerKey, onClose }: IFeatureEditorProps) {
    const [groups, setGroups] = useState<IFeatureGroup[]>([]);
    const [selectedGroup, setSelectedGroup] = useState<string | undefined>();
    const [form] = Form.useForm();
    const [saving, setSaving] = useState(false); // 保存按钮的loading状态
    const [loading, setLoading] = useState(true); // 整体窗口的加载状态

    const handleGroupSelect = (e: any) => {
        setSelectedGroup(e.key);
    }

    // 获取feature groups数据
    const fetchData = async () => {
        setLoading(true);
        try {
            const result = await fetchFeatureGroups(providerName, providerKey);
            setGroups(result.groups);
            if (result.groups.length > 0) {
                setSelectedGroup(result.groups[0].name);
            }
        } catch (error) {
            message.error("获取功能设置失败");
        } finally {
            setLoading(false);
        }
    }

    // 初始化数据
    useEffect(() => {
        fetchData();
    }, [providerName, providerKey]);

    const groupItems = useMemo(() => {
        if (groups === undefined) {
            return [];
        }

        return groups.map((group) => ({
            key: group.name,
            label: group.displayName
        }));
    }, [groups]);



    const selectedFeatures = useMemo(() => {
        if (selectedGroup === undefined) {
            return [];
        }

        return groups.find((g) => g.name === selectedGroup)?.features ?? [];

    }, [selectedGroup, groups]);

    const handleSubmit = async (values: any) => {
        setSaving(true);
        try {
            const features = Object.entries(values).map(([key, value]) => ({
                name: key,
                value: value?.toString() || ''
            }));

            await updateFeature(providerName, providerKey, { features });
            message.success("保存成功");
            onClose();
        } catch (error) {
            message.error("保存失败");
        } finally {
            setSaving(false);
        }
    }

    const handleReset = () => {
        Modal.confirm({
            title: "重置为默认值",
            content: "将重置所有功能设置为默认值，确定要重置吗？",
            onOk: async () => {
                try {
                    await deleteFeature(providerName, providerKey);
                    message.success("重置成功");
                    onClose();
                } catch (error) {
                    message.error("重置失败");
                }
            }
        });
    }

    // 初始化表单值
    const initialValues = useMemo(() => {
        const values: any = {};
        groups.forEach(group => {
            group.features.forEach(feature => {
                values[feature.name] = feature.valueType.name === StringValueTypes.Toggle
                    ? feature.value === "true"
                    : feature.value;
            });
        });
        return values;
    }, [groups]);

    useEffect(() => {
        form.setFieldsValue(initialValues);
    }, [form, initialValues]);

    return (
        <Modal
            title="功能设置"
            open
            onCancel={onClose}
            width={1000}
            footer={
                <div className="flex justify-between">
                    <Button onClick={handleReset}>重置为默认值</Button>
                    <div>
                        <Button style={{ marginRight: 8 }} onClick={onClose}>
                            取消
                        </Button>
                        <Button type="primary" onClick={() => form.submit()} loading={saving}>
                            保存
                        </Button>
                    </div>
                </div>
            }
            maskClosable={false}
            closable={true}
        >
            <Spin spinning={loading} tip="加载中...">
                <div style={{ display: 'flex', minHeight: 500, maxHeight: '60vh', overflow: 'hidden' }}>
                    {/* 左侧设置菜单 */}
                    <div style={{ width: 240, borderRight: '1px solid #f0f0f0', paddingRight: 16 }}>
                        <Menu
                            mode="vertical"
                            selectedKeys={[selectedGroup || '']}
                            onClick={handleGroupSelect}
                            items={groupItems}
                            style={{ height: '100%' }}
                        />
                    </div>

                    {/* 右侧内容区 */}
                    <div style={{ flex: 1, paddingLeft: 24, overflow: 'auto' }}>
                        <Form
                            form={form}
                            layout="vertical"
                            onFinish={handleSubmit}
                            initialValues={initialValues}
                        >
                            <div style={{ paddingBottom: 24 }}>
                                {selectedFeatures.map((feature) => (
                                    <FeatureEditorFormItem key={feature.name} feature={feature} />
                                ))}
                            </div>
                        </Form>
                    </div>
                </div>
            </Spin>
        </Modal>
    );
}

FeatureEditor.displayName = "FeatureEditor";

export default FeatureEditor;

interface IFeatureEditorFormItemProps {
    feature: IFeature
    className?: string
}

function FeatureEditorFormItem({ feature }: IFeatureEditorFormItemProps) {
    if (feature.valueType.name === StringValueTypes.FreeText) {
        let type = "text"
        let max = undefined
        let min = undefined
        if (feature.valueType.validator.name === "NUMERIC") {
            max = feature.valueType.validator.properties.MaxValue
            min = feature.valueType.validator.properties.MinValue
            type = "number"
        }

        return (
            <Form.Item
                name={feature.name}
                label={feature.displayName}
                help={feature.description}
                style={{ paddingLeft: feature.depth * 32 }}
            >
                <Input type={type} max={max} min={min} />
            </Form.Item>
        )
    }

    if (feature.valueType.name === StringValueTypes.Selection) {
        return (
            <Form.Item
                name={feature.name}
                label={feature.displayName}
                help={feature.description}
                style={{ paddingLeft: feature.depth * 32 }}
            >
                <Select>
                    {feature.valueType.itemSource?.items.map(item => (
                        <Option key={item.value} value={item.value}>
                            {item.displayText.name}
                        </Option>
                    ))}
                </Select>
            </Form.Item>
        )
    }

    if (feature.valueType.name === StringValueTypes.Toggle) {
        return (
            <Form.Item
                name={feature.name}
                label={feature.displayName}
                help={feature.description}
                valuePropName="checked"
                style={{ paddingLeft: feature.depth * 32 }}
            >
                <Switch />
            </Form.Item>
        )
    }

    return (
        <Form.Item name={feature.name} style={{ display: 'none' }}>
            <Input type="hidden" />
        </Form.Item>
    );
}

