import { Modal, Button, Space, Alert, Typography, Input, Progress, Switch, Divider } from "antd";
import { ImportOutlined, ExclamationCircleOutlined } from "@ant-design/icons";
import { forwardRef, useImperativeHandle, useState } from "react";
import { importFromAmap, getImportProgress, type IRegionImportProgress } from "./-service";
import useApp from "antd/es/app/useApp";

const { Text } = Typography;

export interface ImportModalRef {
    openModal: () => void;
    closeModal: () => void;
}

interface RegionImportProps {
    refresh: () => void;
}

const RegionImport = forwardRef<ImportModalRef, RegionImportProps>((props, ref) => {
    const { refresh } = props;
    const { message } = useApp();
    const [visible, setVisible] = useState(false);
    const [loading, setLoading] = useState(false);
    const [confirmText, setConfirmText] = useState("");
    const [progress, setProgress] = useState(0);
    const [currentProvince, setCurrentProvince] = useState("");
    const [current, setCurrent] = useState(0);
    const [total, setTotal] = useState(0);
    const [includeStreets, setIncludeStreets] = useState(false);

    useImperativeHandle(ref, () => ({
        openModal: () => {
            setVisible(true);
            resetState();
        },
        closeModal: () => {
            setVisible(false);
            resetState();
        }
    }));

    const resetState = () => {
        setConfirmText("");
        setProgress(0);
        setCurrentProvince("");
        setCurrent(0);
        setTotal(0);
        setLoading(false);
        setIncludeStreets(false);
    };

    const handleImport = async () => {
        const requiredText = "已知道会清除现有行政区域";
        if (confirmText !== requiredText) {
            message.error("请输入正确的确认文字");
            return;
        }

        setLoading(true);
        
        // 启动进度轮询
        const progressTimer = setInterval(async () => {
            try {
                const progressData: IRegionImportProgress = await getImportProgress();
                if (progressData.isImporting) {
                    setProgress(progressData.percentage);
                    setCurrentProvince(progressData.currentProvince);
                    setCurrent(progressData.current);
                    setTotal(progressData.total);
                }
            } catch (error) {
                // 忽略进度获取错误
                console.error("获取进度失败:", error);
            }
        }, 1000);

        try {
            const result = await importFromAmap(includeStreets);
            if (result.success) {
                message.success(`导入成功！共导入 ${result.totalCount} 条行政区域数据`);
                message.info(`省份: ${result.provincesCount} 个, 城市: ${result.citiesCount} 个, 区县: ${result.districtsCount} 个`);
                setVisible(false);
                refresh();
            } else {
                message.error(`导入失败：${result.errorMessage || "未知错误"}`);
            }
        } catch (error) {
            message.error(`导入失败：${(error as Error).message}`);
        } finally {
            clearInterval(progressTimer);
            setLoading(false);
            resetState();
        }
    };

    const handleCancel = () => {
        if (loading) {
            message.warning("正在导入中，请勿关闭");
            return;
        }
        setVisible(false);
        resetState();
    };

    return (
        <Modal
            title="从高德地图导入行政区域"
            open={visible}
            onCancel={handleCancel}
            width={600}
            footer={
                <Space>
                    <Button onClick={handleCancel} disabled={loading}>
                        取消
                    </Button>
                    <Button 
                        type="primary" 
                        onClick={handleImport}
                        loading={loading}
                        disabled={confirmText !== "已知道会清除现有行政区域" || loading}
                        icon={<ImportOutlined />}
                    >
                        {loading ? "正在导入..." : "确认导入"}
                    </Button>
                </Space>
            }
            maskClosable={false}
            destroyOnClose
        >
            <Space direction="vertical" style={{ width: "100%" }} size="large">
                {/* 警告信息 */}
                <Alert
                    message="重要提示"
                    description={
                        <div>
                            <p>⚠️ 此操作将<strong>清空所有现有行政区域数据</strong></p>
                            <p>📍 数据将从高德地图API获取最新的全国行政区域</p>
                            <p>⏱️ 导入过程需要几分钟，请勿关闭页面</p>
                        </div>
                    }
                    type="warning"
                    icon={<ExclamationCircleOutlined />}
                    showIcon
                />

                {/* 导入选项区域 */}
                {!loading && (
                    <div>
                        <div style={{ marginBottom: 16 }}>
                            <Space direction="vertical" className="w-full">
                                <div className="flex justify-between items-center">
                                    <div>
                                        <Text strong>导入街道数据</Text>
                                        <div>
                                            <Text type="secondary" className="text-sm">
                                                包含街道/乡镇级别的详细数据，数据量非常大
                                            </Text>
                                        </div>
                                    </div>
                                    <Switch
                                        checked={includeStreets}
                                        onChange={setIncludeStreets}
                                        disabled={loading}
                                    />
                                </div>

                                {/* 街道数据警告 */}
                                {includeStreets && (
                                    <Alert
                                        description="⏱️ 包含街道数据，预计需要数小时才能完成导入"
                                        type="warning"
                                        closable={false}
                                    />
                                )}
                            </Space>
                        </div>
                    </div>
                )}

                {/* 确认输入区域 */}
                {!loading && (
                    <div>
                        <Text>请复制下方文字并粘贴到输入框中以确认操作：</Text>
                        <div style={{ 
                            background: "#f5f5f5", 
                            padding: "10px 12px", 
                            borderRadius: 4,
                            marginTop: 8,
                            marginBottom: 12,
                            userSelect: "all",
                            cursor: "text",
                            fontFamily: "monospace"
                        }}>
                            <Text code copyable>已知道会清除现有行政区域</Text>
                        </div>
                        
                        <Input
                            placeholder="请粘贴确认文字"
                            value={confirmText}
                            onChange={(e) => setConfirmText(e.target.value)}
                            size="large"
                            disabled={loading}
                        />
                    </div>
                )}

                {/* 导入进度 */}
                {loading && (
                    <div>
                        <Progress 
                            percent={progress} 
                            status="active"
                            strokeColor={{
                                "0%": "#108ee9",
                                "100%": "#87d068",
                            }}
                        />
                        <div style={{ marginTop: 12, textAlign: "center" }}>
                            {currentProvince && (
                                <Text type="secondary">
                                    正在导入：<Text strong>{currentProvince}</Text>
                                    {total > 0 && ` (${current}/${total})`}
                                </Text>
                            )}
                            {!currentProvince && (
                                <Text type="secondary">正在准备导入...</Text>
                            )}
                        </div>
                    </div>
                )}
            </Space>
        </Modal>
    );
});

RegionImport.displayName = "RegionImport";

export default RegionImport;