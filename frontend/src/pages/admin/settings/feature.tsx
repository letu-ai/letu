import { Button } from "antd";
import { SettingOutlined } from "@ant-design/icons";
import FeatureEditor from "@/pages/admin/components/FeatureEditor";
import { useState } from "react";

function Feature() {
    const [open, setOpen] = useState(false);

    const handleClose = () => {
        setOpen(false);
    }

    const handleSetFeature = async () => {
        setOpen(true)
    }

return (
    <div>
        <p style={{ marginBottom: 16 }}>点击管理主站功能参数</p>
        <Button 
            type="primary" 
            icon={<SettingOutlined />} 
            onClick={handleSetFeature}
        >
            设置主站功能
        </Button>

        <p style={{ fontSize: 12, color: '#666', marginTop: 8 }}>要设置租户功能参数，请在租户列表中操作。</p>

        {open && <FeatureEditor providerName="T"  onClose={handleClose} />}

    </div>
)
}

export default Feature;