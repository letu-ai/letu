import { Form, Input, Modal, Button, App } from "antd";
import { switchTenant } from "./-service";
import { setTenantId } from "@/utils/authUtils";

interface ISwitchTenantModelProps {
    visible: boolean;
    onOk: (tenantName: string) => void;
    onClose: () => void;
}

function SwitchTenantModel({ visible, onOk, onClose }: ISwitchTenantModelProps) {
    const [form] = Form.useForm();
    const { message } = App.useApp();

    const handleSubmit = async () => {
        const tenantName = form.getFieldValue('tenantName');
        try {
            const result = await switchTenant(tenantName);
            if (result.success) {
                setTenantId(result.tenantId ?? null, result.cookieKey);
                onOk(tenantName);
            }
            else {
                message.error("租户不存在");
                return;
            }
        } catch (error) {
            message.error('切换租户失败');
            return;
        }
        onClose();
    }

    return (
        <Modal open={visible} onCancel={onClose} footer={false} title="切换租户">
            <div>
                <Form form={form} layout="vertical" onFinish={handleSubmit}>
                    <Form.Item label="租户" name="tenantName"
                        help="不输入名称将切换到主站"
                    >
                        <Input />
                    </Form.Item>
                    <div className="flex justify-center gap-2 pt-10">
                        <Button type="primary" htmlType="submit">切换</Button>
                        <Button type="default" onClick={onClose}>取消</Button>
                    </div>
                </Form>
            </div>
        </Modal>
    )
}

export default SwitchTenantModel;