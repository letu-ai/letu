import { Modal, Form, Input, Switch, InputNumber, Select, TreeSelect, Space, Button, type TreeProps, type TreeSelectProps } from "antd";
import { forwardRef, useImperativeHandle, useState, useCallback } from "react";
import {
    createRegion,
    updateRegion,
    getRegionChildren,
    type IRegionCreateOrUpdateInput,
    type IRegionListOutput
} from "./-service";
import { App } from "antd";

export interface ModalRef {
    openModal: (record?: IRegionListOutput) => void;
    closeModal: () => void;
}

interface RegionFormProps {
    onSuccess: (action: "create" | "update", data: IRegionListOutput, parentId?: string) => Promise<void>;
    treeData: IRegionListOutput[];
}

const RegionForm = forwardRef<ModalRef, RegionFormProps>((props, ref) => {
    const { onSuccess, treeData } = props;
    const [form] = Form.useForm();
    const { message } = App.useApp();
    const [visible, setVisible] = useState(false);
    const [loading, setLoading] = useState(false);
    const [editData, setEditData] = useState<IRegionListOutput | null>(null);
    const [parentOptions, setParentOptions] = useState<any[]>([]);

    useImperativeHandle(ref, () => ({
        openModal: (record?: IRegionListOutput) => {
            setEditData(record || null);
            setVisible(true);
            if (record) {
                form.setFieldsValue({
                    code: record.code,
                    name: record.name,
                    parentId: record.parentId,
                    sort: record.sort,
                    isEnabled: record.isEnabled,
                });
            } else {
                form.resetFields();
                form.setFieldsValue({
                    sort: 0,
                    isEnabled: true,
                });
            }
            setParentOptions(buildParentOptions());
        },
        closeModal: () => {
            setVisible(false);
            form.resetFields();
            setEditData(null);
        }
    }));

    // 构建父级选项数据，使用主组件传入的treeData
    const buildParentOptions = useCallback(() => {
        // 构建级联选项
        const buildOptions = (regions: IRegionListOutput[]): any[] => {
            return regions.map(region => ({
                title: region.name,
                value: region.id,
                key: region.id,
                level: region.level,
                code: region.code,
                children: region.children ? buildOptions(region.children) : undefined,
                isLeaf: region.level >= 3, // 区县及以下不显示为可展开
            }));
        };

        return buildOptions(treeData);
    }, [treeData]);

    // 动态加载下级数据
    const loadChildrenData = async (node: any): Promise<TreeSelectProps['treeData']> => {
        try {
            const children = await getRegionChildren(node.key);
            return children.map(child => ({
                key: child.id,
                value: child.id,
                parentId: child.parentId,
                title: child.name,
                code: child.code,
                isLeaf: child.level >= 3,
            }));
        } catch {
            message.error("加载子级数据失败");
            return [];
        }
    };

    const handleSubmit = async () => {
        try {
            const values = await form.validateFields();
            setLoading(true);

            const data: IRegionCreateOrUpdateInput = {
                code: values.code,
                name: values.name,
                parentId: values.parentId || undefined,
                sort: values.sort,
                isEnabled: values.isEnabled,
            };

            let resultData: IRegionListOutput;

            if (editData) {
                resultData = await updateRegion(editData.id, data);
                message.success("更新成功");
            } else {
                resultData = await createRegion(data);
                message.success("创建成功");
            }

            setVisible(false);
            form.resetFields();

            // 调用父组件的成功回调
            await onSuccess(editData ? "update" : "create", resultData, data.parentId);
        } catch (error) {
            console.error("提交失败:", error);
        } finally {
            setLoading(false);
        }
    };

    const handleCancel = () => {
        setVisible(false);
        form.resetFields();
        setEditData(null);
    };

    return (
        <Modal
            title={editData ? "编辑行政区域" : "新增行政区域"}
            open={visible}
            onCancel={handleCancel}
            footer={
                <Space>
                    <Button onClick={handleCancel}>取消</Button>
                    <Button type="primary" loading={loading} onClick={handleSubmit}>
                        {editData ? "更新" : "创建"}
                    </Button>
                </Space>
            }
            width={600}
            destroyOnHidden
        >
            <Form
                form={form}
                layout="vertical"
                initialValues={{
                    sort: 0,
                    isEnabled: true,
                }}
            >
                <Form.Item
                    label="区域代码"
                    name="code"
                    rules={[
                        { required: true, message: "请输入区域代码" },
                        { max: 12, message: "区域代码不能超过12位" },
                        { pattern: /^[0-9]+$/, message: "区域代码只能包含数字" },
                    ]}
                >
                    <Input placeholder="请输入区域代码（如：110000）" />
                </Form.Item>

                <Form.Item
                    label="区域名称"
                    name="name"
                    rules={[
                        { required: true, message: "请输入区域名称" },
                        { max: 64, message: "区域名称不能超过64个字符" },
                    ]}
                >
                    <Input placeholder="请输入区域名称" />
                </Form.Item>

                <Form.Item
                    label="父级区域"
                    name="parentId"
                >
                    <TreeSelect
                        placeholder="请选择父级区域（不选择表示顶级）"
                        allowClear
                        treeData={parentOptions}
                        loadData={loadChildrenData}
                        treeDataSimpleMode={false}
                    />
                </Form.Item>

                <Form.Item
                    label="排序"
                    name="sort"
                    rules={[
                        { required: true, message: "请输入排序值" },
                    ]}
                >
                    <InputNumber
                        placeholder="请输入排序值"
                        style={{ width: "100%" }}
                        min={0}
                    />
                </Form.Item>

                <Form.Item
                    label="启用状态"
                    name="isEnabled"
                    valuePropName="checked"
                >
                    <Switch checkedChildren="启用" unCheckedChildren="禁用" />
                </Form.Item>
            </Form>
        </Modal>
    );
});

RegionForm.displayName = "RegionForm";

export default RegionForm;