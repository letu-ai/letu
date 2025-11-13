import { useRef, useState } from 'react';
import { createFileRoute } from '@tanstack/react-router';
import { Card, Button, Input, Slider, Typography, App } from 'antd';
import { MapView } from '@/components/amap';
import type {IMapLocation } from '@/components/amap';

const { Text } = Typography;

// 预设位置数据
const PRESET_LOCATIONS= [
    { name: '北京', lng: 116.397428, lat: 39.90923 },
    { name: '上海', lng: 121.473704, lat: 31.230416 },
    { name: '广州', lng: 113.264434, lat: 23.129162 },
    { name: '深圳', lng: 114.085947, lat: 22.547 },
    { name: '杭州', lng: 120.153576, lat: 30.287459 },
    { name: '成都', lng: 104.065735, lat: 30.659462 }
] as const;

export const Route = createFileRoute('/home/demo/map-view')({
    component: RouteComponent
})

function RouteComponent() {
    const [zoom, setZoom] = useState(10);
    const [center, setCenter] = useState<IMapLocation>({ lng: 0, lat: 0 });
    const [customCenter, setCustomCenter] = useState<IMapLocation>({ lng: 0, lat: 0 });
    const [selectedLocation, setSelectedLocation] = useState<{location: IMapLocation, address: any} | null>(null);
    const mapRef = useRef<AMap.Map | null>(null);
    const { message } = App.useApp();
    
    const changeCenter = (location: IMapLocation) => {
        mapRef.current?.setCenter([location.lng, location.lat]);
        setCustomCenter(location);
    };

    // 处理预设位置切换
    const handlePresetLocation = (location: IMapLocation) => {
        changeCenter(location);
    };

    // 处理自定义坐标
    const handleCustomLocation = () => {
        const lng = parseFloat(customCenter?.lng.toString() || '0');
        const lat = parseFloat(customCenter?.lat.toString() || '0');

        if (isNaN(lng) || isNaN(lat)) {
            message.error('请输入有效的经纬度坐标');
            return;
        }

        if (lng < -180 || lng > 180) {
            message.error('经度范围应在 -180 到 180 之间');
            return;
        }

        if (lat < -90 || lat > 90) {
            message.error('纬度范围应在 -90 到 90 之间');
            return;
        }

        changeCenter({ lng, lat });
        message.success('坐标已更新');
    };

    return (
        <div className="p-6 space-y-6">
            <Card title="地图组件示例" className="shadow-sm">
                {/* 控制面板 */}
                <div className="mb-6 space-y-4">
                    {/* 预设位置 */}
                    <div>
                        <Text strong>预设位置：</Text>
                        <div className="mt-2 flex flex-wrap gap-2">
                            {PRESET_LOCATIONS.map((location) => (
                                <Button
                                    key={location.name}
                                    size="small"
                                    onClick={() => handlePresetLocation(location)}
                                    type={customCenter?.lng === location.lng && customCenter?.lat === location.lat ? 'primary' : 'default'}
                                    disabled={customCenter?.lng === location.lng && customCenter?.lat === location.lat}
                                >
                                    {location.name}
                                </Button>
                            ))}
                        </div>
                    </div>

                    {/* 自定义坐标 */}
                    <div>
                        <Text strong>自定义坐标：</Text>
                        <div className="mt-2 flex items-center gap-2">
                            <Input
                                placeholder="经度"
                                value={customCenter.lng.toString() || 0}
                                onChange={(e) => setCustomCenter({ ...customCenter, lng: parseFloat(e.target.value) || 0 })}
                                style={{ width: 120 }}
                            />
                            <Input
                                placeholder="纬度"
                                value={customCenter.lat.toString() || 0}
                                onChange={(e) => setCustomCenter({ ...customCenter, lat: parseFloat(e.target.value) || 0 })}
                                style={{ width: 120 }}
                            />
                            <Button type="primary" onClick={handleCustomLocation}>
                                应用坐标
                            </Button>
                        </div>
                    </div>

                    {/* 缩放控制 */}
                    <div className="flex items-center gap-4">
                        <Text strong>缩放级别：</Text>
                        <Slider
                            className="w-48"
                            min={3}
                            max={20}
                            value={zoom}
                            onChange={(value) => {
                                mapRef.current?.setZoom(value);
                            }}
                        />
                        <Text className="min-w-[30px]">{zoom}</Text>
                    </div>
                </div>

                {/* 地图组件 */}
                <div className="mb-4">
                    <MapView
                        className="h-96 shadow-lg"
                        showSearch={true}
                        onReady={(map) => {
                            mapRef.current = map;
                        }}
                        onMove={(center) => {
                            setCenter(center);
                        }}
                        onZoom={(zoom) => {
                            setZoom(zoom);
                        }}
                        onSelect={(location, address) => {
                            setSelectedLocation({ location, address });
                            message.success(`已选择位置: ${address.address}`);
                        }}
                    />
                </div>

                {/* 当前状态显示 */}
                <div className="p-4 bg-gray-50 rounded">
                    <Text strong>当前状态：</Text>
                    <div className="mt-2 space-y-1">
                        <div>中心点：[{center?.lng}, {center?.lat}]</div>
                        <div>缩放级别：{zoom}</div>
                        {selectedLocation && (
                            <>
                                <div className="mt-2 pt-2 border-t">
                                    <Text strong>选中位置：</Text>
                                    <div>坐标：[{selectedLocation.location.lng}, {selectedLocation.location.lat}]</div>
                                    <div>地址：{selectedLocation.address.address}</div>
                                    {selectedLocation.address.province && <div>省份：{selectedLocation.address.province}</div>}
                                    {selectedLocation.address.city && <div>城市：{selectedLocation.address.city}</div>}
                                    {selectedLocation.address.district && <div>区县：{selectedLocation.address.district}</div>}
                                </div>
                            </>
                        )}
                    </div>
                </div>
            </Card>
        </div>
    );
}
