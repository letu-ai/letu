import React, { useState, useEffect, useCallback, useRef } from "react";
import { Row, Col, Divider, Card, Typography, Input } from "antd";
import RegionSelect, { type IRegionSelectValue } from "@/components/RegionSelect";
import MapView, { type IAddressInfo } from "@/components/amap/MapView";
import type { IMapLocation } from "@/components/amap/service";
import { parseLocationString, formatLocationString } from "@/components/amap/service";
import { getRegionByCode } from "@/pages/admin/regions/-service";

const { Text } = Typography;

export interface IDeviceAddressValue {
    code: string;       // 行政区划代码
    street: string;     // 街道
    address: string;    // 详细地址
    location: string;   // 经纬度，格式："lng,lat"
}

interface IDeviceAddressInputProps {
    value?: IDeviceAddressValue;
    onChange?: (value: IDeviceAddressValue | undefined) => void;
    disabled?: boolean;
    height?: number;    // 地图高度
    showStreet?: boolean; // 是否显示街道选择
}

function MapAddressInput({
    value ,
    onChange,
    disabled = false,
    height = 300,
    showStreet = true
}: IDeviceAddressInputProps) {
    const [regionValue, setRegionValue] = useState<IRegionSelectValue>();
    const [addressText, setAddressText] = useState<string>("");
    const [mapCenter, setMapCenter] = useState<IMapLocation>();
    const [cityLimit, setCityLimit] = useState<string>("");
    const [selectedLocation, setSelectedLocation] = useState<string>("");
    const mapRef = useRef<AMap.Map | null>(null);

    // 处理value变化（数据回填）
    useEffect(() => {
        if (value) {
            // 设置区域值
            setRegionValue({
                code: value.code,
                street: value.street
            });

            // 设置地址文本
            setAddressText(value.address);

            // 设置地图中心
            if (value.location) {
                const location = parseLocationString(value.location);
                setMapCenter(location);
                setSelectedLocation(value.location);
            }
        } else {
            setRegionValue(undefined);
            setAddressText("");
            setMapCenter(undefined);
            setSelectedLocation("");
        }
    }, [value]);

    // 处理区域选择每一步的变化 - 仅更新地图中心
    const handleRegionStepChange = useCallback(async (step: {
        level: 'province' | 'city' | 'district' | 'street';
        code?: string;
        name?: string;
    }) => {
        if (step.code) {
            try {
                const regionInfo = await getRegionByCode(step.code);
                if (regionInfo) {
                    // 更新城市限制
                    if (step.level === 'city' || step.level === 'province') {
                        const cityName = regionInfo.cityName || regionInfo.name;
                        setCityLimit(cityName);
                    }

                    // 更新地图中心和缩放级别
                    if (regionInfo.center) {
                        const center = parseLocationString(regionInfo.center);
                        setMapCenter(center);

                        // 根据级别设置不同的缩放级别
                        const zoomLevel = {
                            'province': 8,
                            'city': 11,
                            'district': 13,
                            'street': 15
                        }[step.level];
                        mapRef.current?.setZoomAndCenter(zoomLevel, [center.lng, center.lat]);
                    }
                }
            } catch (error) {
                console.error("获取区域信息失败:", error);
            }
        }
    }, []);

    // 处理行政区划最终选择变化
    const handleRegionChange = useCallback(async (regionVal: IRegionSelectValue | undefined) => {
        setRegionValue(regionVal);

        if (regionVal?.code) {
            // 如果有完整的区域信息且有地址，触发onChange
            if (addressText && selectedLocation) {
                onChange?.({
                    code: regionVal.code,
                    street: regionVal.street || "",
                    address: addressText,
                    location: selectedLocation
                });
            }
        } else {
            // 清空选择
            setCityLimit("");
            setMapCenter(undefined);
            onChange?.(undefined);
        }
    }, [onChange, addressText, selectedLocation]);

    // 处理地址文本输入变化
    const handleAddressTextChange = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
        const text = e.target.value;
        setAddressText(text);

        // 如果有完整信息，触发onChange
        if (regionValue?.code && text && selectedLocation) {
            onChange?.({
                code: regionValue.code,
                street: regionValue.street || "",
                address: text,
                location: selectedLocation
            });
        }
    }, [regionValue, selectedLocation, onChange]);

    // 处理地图选择（点击搜索结果或地图点击）
    const handleMapSelect = useCallback((location: IMapLocation, addressInfo: IAddressInfo) => {
        // 更新行政区划
        console.log("handleMapSelect", addressInfo);

        if (addressInfo.adCode) {
            setRegionValue({
                code: addressInfo.adCode,
                street: addressInfo.township || ""
            });
        }

        // 如果地址文本为空，使用地图返回的地址；否则保持用户输入的地址
        const finalAddress = addressText || addressInfo.address;
        if (!addressText) {
            setAddressText(addressInfo.address);
        }

        // 更新选中位置
        const locationStr = formatLocationString(location);
        setSelectedLocation(locationStr);

        // 触发onChange
        if (addressInfo.adCode) {
            onChange?.({
                code: addressInfo.adCode,
                street: addressInfo.township || "",
                address: finalAddress,
                location: locationStr
            });
        }
    }, [onChange, addressText]);


    return (
        <Card className="device-address-input">
            <Row gutter={16}>
                <Col span={24}>
                    <div className="mb-4">
                        <Text strong className="block mb-2">1. 选择行政区划</Text>
                        <RegionSelect
                            value={regionValue}
                            onChange={handleRegionChange}
                            onStepChange={handleRegionStepChange}
                            disabled={disabled}
                            showStreet={showStreet}
                            placeholder="请选择行政区划"
                        />
                    </div>
                </Col>

                <Col span={24}>
                    <div className="mb-4">
                        <Text strong className="block mb-2">2. 输入详细地址</Text>
                        <Input
                            value={addressText}
                            onChange={handleAddressTextChange}
                            disabled={disabled}
                            placeholder="请输入详细地址"
                        />
                    </div>
                </Col>

                <Col span={24}>
                    <div className="mb-4">
                        <Text strong className="block mb-2">3. 地图定位（可搜索或点击选择位置）</Text>
                        <MapView
                            defaultCenter={mapCenter}
                            height={height}
                            showSearch={true}
                            searchCity={cityLimit}
                            onSelect={handleMapSelect}
                            className="border border-gray-200 rounded"
                            onReady={(map) => {
                                mapRef.current = map;
                            }}
                        />
                    </div>
                </Col>

                <Col span={24}>
                    <Divider className="my-4" />
                    <div className="bg-gray-50 p-4 rounded">
                        <Text strong className="block mb-2">当前选择信息：</Text>
                        <div className="space-y-1 text-sm">
                            <div>
                                <Text type="secondary">行政区划：</Text>
                                <Text className="ml-2">
                                    {regionValue?.code || "未选择"}
                                    {regionValue?.street && ` - ${regionValue.street}`}
                                </Text>
                            </div>
                            <div>
                                <Text type="secondary">详细地址：</Text>
                                <Text className="ml-2">{addressText || "未输入"}</Text>
                            </div>
                            <div>
                                <Text type="secondary">经纬度：</Text>
                                <Text className="ml-2 font-mono text-xs">
                                    {selectedLocation || "未定位"}
                                </Text>
                            </div>
                        </div>
                    </div>
                </Col>
            </Row>
        </Card>
    );
};

export default MapAddressInput;