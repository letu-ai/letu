import { Form, Input, Modal, Button, App } from "antd";
import { switchTenant } from "./-service";

interface ISwitchTenantModelProps {
    visible: boolean;
    onClose: () => void;
}

function SwitchTenantModel({ visible, onClose }: ISwitchTenantModelProps) {
    const [form] = Form.useForm();
    const { message } = App.useApp();

    const onOk = async () => {
        const tenantName = form.getFieldValue('tenantName');
        try {
            const result = await switchTenant(tenantName);
            if (result.success) {
                // 如果租户ID为空表示登录主站，则删除Cookie
                const cookieValue = result.tenantId ? `${result.cookieKey}=${result.tenantId}; Path=/; HttpOnly; Secure; SameSite=Lax; Max-Age=31536000` : `${result.cookieKey}=; Path=/; HttpOnly; Secure; SameSite=Lax; Max-Age=0`;
                document.cookie = cookieValue;
                onClose();
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
        <Modal open={visible} onCancel={onClose} onOk={onOk} footer={false} title="切换租户">
            <div>
                <Form form={form} layout="vertical" onFinish={onOk}>
                    <Form.Item label="租户" name="tenantName"
                        help="不输入名称将切换到主站"
                    >
                        <Input />
                    </Form.Item>
                    <div className="flex justify-center gap-2 pt-10">
                        <Button type="primary" onClick={onOk}>切换</Button>
                        <Button type="default" onClick={onClose}>取消</Button>
                    </div>
                </Form>
            </div>
        </Modal>
    )
}

export default SwitchTenantModel;