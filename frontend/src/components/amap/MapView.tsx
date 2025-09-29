import React, { useId, useRef, useState, useCallback, useEffect } from 'react';
import AMapLoader from '@amap/amap-jsapi-loader';
import "@amap/amap-jsapi-types";
import { Empty, Input, List, Card, Spin } from 'antd';
import { SearchOutlined, EnvironmentOutlined } from '@ant-design/icons';
import { useAsyncEffect, useDebounceFn } from 'ahooks';
import { searchAddress, getAddressByLocation, getAmapWebConfig, type IAmapPoi, type IAmapWebConfig } from './service';

export interface IMapLocation {
    lng: number;
    lat: number;
}

export interface IAddressInfo {
    address: string;
    adCode: string;
    province?: string;
    city?: string;
    district?: string;
    township?: string;
}

// MapView 组件属性接口
export interface IMapViewProps {
    defaultCenter?: IMapLocation; // 地图中心点 [经度, 纬度]
    height?: string | number;  // 地图高度
    className?: string;        // 额外样式类
    showSearch?: boolean;      // 是否显示搜索框
    searchCity?: string;       // 搜索限制城市
    onReady?: (map: AMap.Map) => void;
    onMove?: (center: IMapLocation) => void;
    onZoom?: (zoom: number) => void;
    onSelect?: (location: IMapLocation, address: IAddressInfo) => void; // 选择地点回调
}

const DEFAULT_CENTER = { lng: 116.397428, lat: 39.90923 }; // 默认北京天安门

function MapView({
    defaultCenter = DEFAULT_CENTER,
    height = 400,
    className = '',
    showSearch = false,
    searchCity = '',
    onReady,
    onMove,
    onZoom,
    onSelect
}: IMapViewProps) {

    const mapRef = useRef<AMap.Map | null>(null);
    const markerRef = useRef<AMap.Marker | null>(null);
    const id = useId();
    const [keyInvalid, setKeyInvalid] = useState(false);
    const [searchKeyword, setSearchKeyword] = useState('');
    const [searchResults, setSearchResults] = useState<IAmapPoi[]>([]);
    const [searching, setSearching] = useState(false);
    const [showResults, setShowResults] = useState(false);
    const [loading, setLoading] = useState(true);
    const [configLoaded, setConfigLoaded] = useState(false);
    const apiConfigRef = useRef<IAmapWebConfig | null>(null);

    // 处理地图移动结束事件
    const handleMapMoveEnd = useCallback(() => {
        if (mapRef.current && onMove) {
            const center = mapRef.current.getCenter();
            onMove({ lng: center.lng, lat: center.lat });
        }
    }, [onMove]);

    // 处理地图缩放结束事件
    const handleMapZoomEnd = useCallback(() => {
        if (mapRef.current && onZoom) {
            const zoom = mapRef.current.getZoom();
            onZoom(zoom);
        }
    }, [onZoom]);

    // 处理地图点击
    const handleMapClick = useCallback(async (e: any) => {
        if (!onSelect) return;

        const location = { lng: e.lnglat.getLng(), lat: e.lnglat.getLat() };

        // 添加或移动标记
        if (markerRef.current)
            markerRef.current.setPosition([location.lng, location.lat]);

        // 逆地理编码获取地址信息
        try {
            const geoResult = await getAddressByLocation(`${location.lng},${location.lat}`);
            if (geoResult) {
                const { addressComponent, formattedAddress, pois } = geoResult;

                // 如果点击位置附近有POI，使用最近的POI信息
                let finalAddress = formattedAddress;

                if (pois && pois.length > 0) {
                    // 使用第一个POI（通常是最近的）
                    const nearestPoi = pois[0];
                    // 如果POI有详细地址，使用POI的地址，否则使用POI名称+格式化地址
                    finalAddress = nearestPoi.address || `${nearestPoi.name} (${formattedAddress})`;
                }

                onSelect(location, {
                    address: finalAddress,
                    adCode: addressComponent.adcode,
                    province: addressComponent.province,
                    city: addressComponent.city,
                    district: addressComponent.district,
                    township: addressComponent.township
                });
            }
        } catch (error) {
            console.error('逆地理编码失败:', error);
        }
    }, [onSelect]);

    // 搜索地址
    const searchAddressCore = useCallback(async (keyword: string) => {
        if (!keyword.trim()) {
            // 关键词为空时不清除结果，只隐藏
            setShowResults(false);
            return;
        }

        setSearching(true);
        try {
            const results = await searchAddress(keyword, searchCity);
            setSearchResults(results || []);
            setShowResults(true);
        } catch (error) {
            console.error('搜索失败:', error);
            setSearchResults([]);
        } finally {
            setSearching(false);
        }
    }, [searchCity]);

    // 防抖搜索
    const { run: debouncedSearch } = useDebounceFn(
        searchAddressCore,
        { wait: 300 }
    );

    // 处理搜索输入变化
    const handleSearchChange = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
        const value = e.target.value;
        setSearchKeyword(value);
        debouncedSearch(value);
    }, [debouncedSearch]);

    // 处理输入框聚焦
    const handleSearchFocus = useCallback(() => {
        // 如果有搜索结果，重新显示
        if (searchResults.length > 0) {
            setShowResults(true);
        }
    }, [searchResults]);

    // 处理输入框失焦
    const handleSearchBlur = useCallback(() => {
        // 延迟隐藏，以便能点击搜索结果
        setTimeout(() => {
            setShowResults(false);
        }, 200);
    }, []);

    // 选择搜索结果
    const handleSelectResult = useCallback((poi: IAmapPoi) => {
        const [lng, lat] = poi.location.split(',').map(Number);
        const location = { lng, lat };

        // 设置地图中心和标记
        if (mapRef.current)
            mapRef.current.setZoomAndCenter(16, [lng, lat]);

        // 移动标记
        if (markerRef.current)
            markerRef.current.setPosition([lng, lat]);

        // 只隐藏搜索结果，不清除
        setShowResults(false);
        setSearchKeyword(poi.name);

        // 触发选择回调
        onSelect?.(location, {
            address: poi.address || poi.name,
            adCode: poi.adCode,
            province: poi.provinceName,
            city: poi.cityName,
            district: poi.districtName,
            township: ''
        });
    }, [onSelect]);

    // 加载配置 - 第一步
    useAsyncEffect(async () => {
        if (apiConfigRef.current) {
            return;
        }

        setLoading(true);
        try {
            const config = await getAmapWebConfig();
            if (config.apiKey && config.securityJsCode) {
                apiConfigRef.current = config;
                // 设置安全配置
                (window as any)._AMapSecurityConfig = {
                    securityJsCode: config.securityJsCode,
                };
                setConfigLoaded(true);
            }
            else {
                setKeyInvalid(true);
            }
        } catch (err) {
            console.error('获取地图配置失败:', err);
            setKeyInvalid(true);
        }
        finally {
            setLoading(false);
        }
    }, []);

    // 初始化地图 - 配置加载成功后才执行
    useEffect(() => {
        if (!configLoaded || !apiConfigRef.current) return;

        const config = apiConfigRef.current;
        if (!config.apiKey)
            return;

        AMapLoader.load({
            key: config.apiKey, // 申请好的Web端开发者Key，首次调用 load 时必填
            version: "2.0", // 指定要加载的 JSAPI 的版本，缺省时默认为 1.4.15
            plugins: ["AMap.Scale", "AMap.Marker"], //需要使用的的插件列表，如比例尺'AMap.Scale'，支持添加多个如：['...','...']
        })
            .then((AMap) => {
                const map = new AMap.Map(id, {
                    // 设置地图容器id
                    viewMode: "3D", // 是否为3D地图模式
                    zoom: 11, // 初始化地图级别
                    center: [defaultCenter.lng, defaultCenter.lat], // 初始化地图中心点位置
                }) as AMap.Map;

                const marker = new AMap.Marker({
                    position: [defaultCenter.lng, defaultCenter.lat],
                    map
                });
                map.add(marker);

                mapRef.current = map;
                markerRef.current = marker;

                //绑定地图移动与缩放事件
                map.on('moveend', handleMapMoveEnd);
                map.on('zoomend', handleMapZoomEnd);
                map.on('click', handleMapClick);
                onReady?.(map);
            })
            .catch((e) => {
                console.log('地图加载失败:', e);
                setKeyInvalid(true);
            });

        return () => {
            if (markerRef.current) {
                markerRef.current.setMap(null);
                markerRef.current = null;
            }
            mapRef.current?.destroy();
            mapRef.current = null;
        };
    }, [configLoaded, id]);

    return (
        <div className="relative">
            {showSearch && (
                <div className="absolute top-2 left-2 right-2 z-10 max-w-[400px]">
                    <Card className="shadow-md" styles={{ body: { padding: 0 } }}>
                        <Input
                            prefix={<SearchOutlined />}
                            placeholder={searchCity ? `在${searchCity}内搜索地址` : "搜索地址"}
                            value={searchKeyword}
                            onChange={handleSearchChange}
                            onFocus={handleSearchFocus}
                            onBlur={handleSearchBlur}
                            suffix={searching && <Spin size="small" />}
                            className="border-0"
                        />
                        {showResults && searchResults.length > 0 && (
                            <List
                                className="max-h-80 overflow-auto border-t"
                                size="small"
                                dataSource={searchResults}
                                renderItem={(item) => (
                                    <List.Item
                                        className="cursor-pointer hover:bg-gray-50"
                                        onClick={() => handleSelectResult(item)}
                                    >
                                        <div className="w-full px-2">
                                            <div className="flex items-center">
                                                <EnvironmentOutlined className="mr-2 text-gray-400" />
                                                <div className="flex-1">
                                                    <div className="font-medium">{item.name}</div>
                                                    <div className="text-xs text-gray-500">{item.address}</div>
                                                </div>
                                            </div>
                                        </div>
                                    </List.Item>
                                )}
                            />
                        )}
                    </Card>
                </div>
            )}
            {/* 地图容器 - 只在配置加载成功后渲染 */}
            {loading ? (
                <div className={`flex items-center justify-center ${className}`} style={{ height: `${height}px` }}>
                    <Spin size="large" />
                </div>
            ) : keyInvalid ? (
                <div className={`flex items-center justify-center ${className}`} style={{ height: `${height}px` }}>
                    <Empty description="地图配置无效，请检查API密钥设置" />
                </div>
            ) : (
                <div
                    id={id}
                    className={className}
                    style={{ height: `${height}px` }}
                />
            )}
        </div>
    );
}

MapView.displayName = 'MapView';

export default MapView;