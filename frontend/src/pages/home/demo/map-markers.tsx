import { useState, useRef } from 'react';
import { createFileRoute } from '@tanstack/react-router';
import { Card, Button, Switch, Slider, Typography, Space, Row, Col, Input, App, List } from 'antd';
import { PlusOutlined, DeleteOutlined, EnvironmentOutlined, AimOutlined } from '@ant-design/icons';
import { MapView } from '@/components/amap';
import type { IMapLocation, IMapMarker } from '@/components/amap';

const { Text, Title } = Typography;
const { TextArea } = Input;

// 预设的景点标记数据
const PRESET_MARKERS: IMapMarker[] = [
    { id: '1', location: { lng: 116.397428, lat: 39.90923 }, title: '天安门', content: '北京市东城区天安门广场' },
    { id: '2', location: { lng: 116.404269, lat: 39.916042 }, title: '故宫博物院', content: '北京市东城区景山前街4号' },
    { id: '3', location: { lng: 116.383331, lat: 39.916342 }, title: '中南海', content: '北京市西城区西长安街' },
    { id: '4', location: { lng: 116.387271, lat: 39.983706 }, title: '鸟巢', content: '北京市朝阳区国家体育场南路1号' },
    { id: '5', location: { lng: 116.38356, lat: 39.989816 }, title: '水立方', content: '北京市朝阳区天辰东路11号' },
    { id: '6', location: { lng: 116.273364, lat: 39.913818 }, title: '颐和园', content: '北京市海淀区新建宫门路19号' },
    { id: '7', location: { lng: 116.220768, lat: 40.000532 }, title: '圆明园', content: '北京市海淀区清华西路28号' },
    { id: '8', location: { lng: 116.233689, lat: 40.074927 }, title: '十三陵', content: '北京市昌平区十三陵镇' },
    { id: '9', location: { lng: 116.353653, lat: 39.966156 }, title: '北海公园', content: '北京市西城区文津街1号' },
    { id: '10', location: { lng: 116.412834, lat: 39.963374 }, title: '雍和宫', content: '北京市东城区雍和宫大街12号' },
];

// 生成随机标记点（用于测试大量标记的聚合效果）
const generateRandomMarkers = (count: number, center: IMapLocation, radius: number = 0.1): IMapMarker[] => {
    const markers: IMapMarker[] = [];
    for (let i = 0; i < count; i++) {
        const angle = Math.random() * Math.PI * 2;
        const r = Math.random() * radius;
        const lng = center.lng + r * Math.cos(angle);
        const lat = center.lat + r * Math.sin(angle);

        markers.push({
            id: `random-${i}`,
            location: { lng, lat },
            title: `标记点 ${i + 1}`,
            content: `随机生成的标记点 ${i + 1}\n坐标：[${lng.toFixed(6)}, ${lat.toFixed(6)}]`
        });
    }
    return markers;
};

export const Route = createFileRoute('/home/demo/map-markers')({
    component: RouteComponent
})

function RouteComponent() {
    const [markers, setMarkers] = useState<IMapMarker[]>(PRESET_MARKERS);
    const [enableCluster, setEnableCluster] = useState(true);
    const [clusterGridSize, setClusterGridSize] = useState(60);
    const [selectedMarker, setSelectedMarker] = useState<IMapMarker | null>(null);
    const [newMarkerMode, setNewMarkerMode] = useState(false);
    const mapRef = useRef<AMap.Map | null>(null);
    const { message } = App.useApp();

    const [newMarker, setNewMarker] = useState<{
        title: string;
        content: string;
    }>({ title: '', content: '' });

    // 加载预设标记
    const loadPresetMarkers = () => {
        setMarkers(PRESET_MARKERS);
        message.success(`已加载 ${PRESET_MARKERS.length} 个预设景点标记`);
    };

    // 生成随机标记
    const addRandomMarkers = (count: number) => {
        const center = mapRef.current?.getCenter();
        if (!center) {
            message.error('地图未初始化');
            return;
        }
        const randomMarkers = generateRandomMarkers(count, { lng: center.lng, lat: center.lat });
        setMarkers(prev => [...prev, ...randomMarkers]);
        message.success(`已添加 ${count} 个随机标记点`);
    };

    // 清除所有标记
    const clearAllMarkers = () => {
        setMarkers([]);
        setSelectedMarker(null);
        message.success('已清除所有标记');
    };

    // 删除单个标记
    const deleteMarker = (id: string) => {
        setMarkers(prev => prev.filter(m => m.id !== id));
        if (selectedMarker?.id === id) {
            setSelectedMarker(null);
        }
        message.success('已删除标记');
    };

    // 处理地图点击添加标记
    const handleMapSelect = (location: IMapLocation, address: any) => {
        if (newMarkerMode) {
            if (!newMarker.title) {
                message.warning('请输入标记名称');
                return;
            }

            const marker: IMapMarker = {
                id: `custom-${Date.now()}`,
                location,
                title: newMarker.title,
                content: newMarker.content || address.address
            };

            setMarkers(prev => [...prev, marker]);
            message.success('已添加新标记');
            setNewMarkerMode(false);
            setNewMarker({ title: '', content: '' });
        }
    };

    // 处理标记点击
    const handleMarkerClick = (marker: IMapMarker) => {
        setSelectedMarker(marker);
    };

    // 定位到标记
    const focusOnMarker = (marker: IMapMarker) => {
        if (mapRef.current) {
            mapRef.current.setZoomAndCenter(16, [marker.location.lng, marker.location.lat]);
        }
    };

    return (
        <div className="p-6">
            <Title level={3}>地图标记与聚合示例</Title>

            <Row gutter={[16, 16]}>
                {/* 左侧控制面板 */}
                <Col xs={24} lg={8}>
                    <Space direction="vertical" className="w-full" size="middle">
                        {/* 标记管理 */}
                        <Card title="标记管理" size="small">
                            <Space direction="vertical" className="w-full">
                                <Button
                                    type="primary"
                                    icon={<EnvironmentOutlined />}
                                    onClick={loadPresetMarkers}
                                    block
                                >
                                    加载预设景点 ({PRESET_MARKERS.length}个)
                                </Button>

                                <Space.Compact className="w-full">
                                    <Button onClick={() => addRandomMarkers(10)} className="flex-1">
                                        +10个随机点
                                    </Button>
                                    <Button onClick={() => addRandomMarkers(50)} className="flex-1">
                                        +50个随机点
                                    </Button>
                                    <Button onClick={() => addRandomMarkers(100)} className="flex-1">
                                        +100个随机点
                                    </Button>
                                </Space.Compact>

                                <Button
                                    danger
                                    icon={<DeleteOutlined />}
                                    onClick={clearAllMarkers}
                                    block
                                >
                                    清除所有标记
                                </Button>

                                <div className="bg-gray-50 p-2 rounded">
                                    <Text>当前标记数量：<Text strong>{markers.length}</Text></Text>
                                </div>
                            </Space>
                        </Card>

                        {/* 聚合设置 */}
                        <Card title="聚合设置" size="small">
                            <Space direction="vertical" className="w-full">
                                <div className="flex justify-between items-center">
                                    <Text>启用聚合</Text>
                                    <Switch
                                        checked={enableCluster}
                                        onChange={setEnableCluster}
                                    />
                                </div>

                                {enableCluster && (
                                    <div>
                                        <Text>聚合网格大小：{clusterGridSize}px</Text>
                                        <Slider
                                            min={20}
                                            max={100}
                                            value={clusterGridSize}
                                            onChange={setClusterGridSize}
                                            disabled={!enableCluster}
                                        />
                                    </div>
                                )}

                                <Text type="secondary" className="text-xs">
                                    缩小地图查看聚合效果，放大地图查看具体标记点
                                </Text>
                            </Space>
                        </Card>

                        {/* 添加新标记 */}
                        <Card title="添加新标记" size="small">
                            <Space direction="vertical" className="w-full">
                                <Input
                                    placeholder="标记名称"
                                    value={newMarker.title}
                                    onChange={e => setNewMarker({ ...newMarker, title: e.target.value })}
                                />
                                <TextArea
                                    placeholder="标记描述（可选）"
                                    rows={2}
                                    value={newMarker.content}
                                    onChange={e => setNewMarker({ ...newMarker, content: e.target.value })}
                                />
                                <Button
                                    type={newMarkerMode ? "default" : "primary"}
                                    icon={<PlusOutlined />}
                                    onClick={() => setNewMarkerMode(!newMarkerMode)}
                                    block
                                >
                                    {newMarkerMode ? '取消添加' : '点击地图添加标记'}
                                </Button>
                                {newMarkerMode && (
                                    <Text type="warning" className="text-xs">
                                        请在地图上点击要添加标记的位置
                                    </Text>
                                )}
                            </Space>
                        </Card>

                        {/* 选中的标记信息 */}
                        {selectedMarker && (
                            <Card
                                title="选中的标记"
                                size="small"
                                extra={
                                    <Button
                                        type="text"
                                        danger
                                        size="small"
                                        icon={<DeleteOutlined />}
                                        onClick={() => deleteMarker(selectedMarker.id!)}
                                    />
                                }
                            >
                                <Space direction="vertical" className="w-full">
                                    <div>
                                        <Text strong>{selectedMarker.title}</Text>
                                    </div>
                                    <div>
                                        <Text type="secondary">{selectedMarker.content}</Text>
                                    </div>
                                    <div>
                                        <Text type="secondary" className="text-xs">
                                            坐标：[{selectedMarker.location.lng.toFixed(6)}, {selectedMarker.location.lat.toFixed(6)}]
                                        </Text>
                                    </div>
                                </Space>
                            </Card>
                        )}
                    </Space>
                </Col>

                {/* 右侧地图和标记列表 */}
                <Col xs={24} lg={16}>
                    <Card title="地图展示" className="mb-4">
                        <MapView
                            className="h-[500px]"
                            markers={markers}
                            enableCluster={enableCluster}
                            clusterOptions={{
                                gridSize: clusterGridSize,
                                maxZoom: 15,
                                averageCenter: true,
                                minClusterSize: 2
                            }}
                            showSearch={true}
                            onReady={(map) => {
                                mapRef.current = map;
                            }}
                            onSelect={handleMapSelect}
                            onMarkerClick={handleMarkerClick}
                        />
                    </Card>

                    {/* 标记列表 */}
                    <Card title="标记列表" size="small">
                        <List
                            size="small"
                            className="max-h-64 overflow-auto"
                            dataSource={markers}
                            renderItem={(item) => (
                                <List.Item
                                    className="cursor-pointer hover:bg-gray-50"
                                    onClick={() => focusOnMarker(item)}
                                    actions={[
                                        <Button
                                            type="text"
                                            size="small"
                                            icon={<AimOutlined />}
                                            onClick={(e) => {
                                                e.stopPropagation();
                                                focusOnMarker(item);
                                            }}
                                        />,
                                        <Button
                                            type="text"
                                            danger
                                            size="small"
                                            icon={<DeleteOutlined />}
                                            onClick={(e) => {
                                                e.stopPropagation();
                                                deleteMarker(item.id!);
                                            }}
                                        />
                                    ]}
                                >
                                    <List.Item.Meta
                                        title={item.title}
                                        description={
                                            <Text type="secondary" className="text-xs">
                                                {item.content?.substring(0, 30)}...
                                            </Text>
                                        }
                                    />
                                </List.Item>
                            )}
                        />
                    </Card>
                </Col>
            </Row>
        </div>
    );
}