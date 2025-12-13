import React, { useId, useRef, useState, useCallback, useEffect } from 'react';
import AMapLoader from '@amap/amap-jsapi-loader';
import "@amap/amap-jsapi-types";
import { Empty, Input, List, Card, Spin } from 'antd';
import { SearchOutlined, EnvironmentOutlined } from '@ant-design/icons';
import { useAsyncEffect, useDebounceFn } from 'ahooks';
import { searchAddress, getAddressByLocation, getAmapWebConfig, type IAmapPoi, type IAmapWebConfig, type IMapMarker, type IClusterOptions } from './service';
import { cn } from '@/lib/utils';

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
    className?: string;        // 额外样式类
    showSearch?: boolean;      // 是否显示搜索框
    searchCity?: string;       // 搜索限制城市
    markers?: IMapMarker[];    // 标记点数组
    enableCluster?: boolean;   // 是否启用聚合
    clusterOptions?: IClusterOptions; // 聚合配置
    onReady?: (map: AMap.Map) => void;
    onMove?: (center: IMapLocation) => void;
    onZoom?: (zoom: number) => void;
    onSelect?: (location: IMapLocation, address: IAddressInfo) => void; // 选择地点回调
    onMarkerClick?: (marker: IMapMarker) => void; // 标记点击回调
}

const DEFAULT_CENTER = { lng: 116.397428, lat: 39.90923 }; // 默认北京天安门

function MapView({
    defaultCenter = DEFAULT_CENTER,
    className = '',
    showSearch = false,
    searchCity = '',
    markers = [],
    enableCluster = false,
    clusterOptions = {},
    onReady,
    onMove,
    onZoom,
    onSelect,
    onMarkerClick
}: IMapViewProps) {

    const mapRef = useRef<AMap.Map | null>(null);
    const markerRef = useRef<AMap.Marker | null>(null);
    const markersRef = useRef<AMap.Marker[]>([]);
    const clusterRef = useRef<any>(null);
    const infoWindowRef = useRef<AMap.InfoWindow | null>(null);
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

    // 添加标记到地图
    const addMarkers = useCallback((AMap: any, map: AMap.Map, markerData: IMapMarker[]) => {
        if (!map) return;
        // 清除旧的标记
        if (markersRef.current.length > 0) {
            markersRef.current.forEach(m => m.setMap(null));
            markersRef.current = [];
        }

        // 清除旧的聚合
        if (clusterRef.current) {
            clusterRef.current.setMap(null);
            clusterRef.current = null;
        }

        if (!markerData || markerData.length === 0) return;

        // 创建标记点
        const markerInstances = markerData.map(item => {
            // 创建与聚合模式相同的标记样式
            const content = document.createElement('div');
            content.innerHTML = `
                <div style="
                    background-color: #ff4d4f;
                    width: 28px;
                    height: 28px;
                    border-radius: 50%;
                    border: 3px solid white;
                    box-shadow: 0 2px 8px rgba(0,0,0,.4);
                    cursor: pointer;
                    position: relative;
                ">
                    <div style="
                        position: absolute;
                        top: 50%;
                        left: 50%;
                        transform: translate(-50%, -50%);
                        width: 8px;
                        height: 8px;
                        background-color: white;
                        border-radius: 50%;
                    "></div>
                </div>
            `;

            const marker = new AMap.Marker({
                position: [item.location.lng, item.location.lat],
                content: content,
                offset: new AMap.Pixel(-14, -14),
                title: item.title,
                extData: { ...item }
            });

            // 绑定点击事件
            marker.on('click', () => {
                // 显示信息窗口
                if (item.content && infoWindowRef.current) {
                    infoWindowRef.current.setContent(`
                        <div style="padding: 10px;">
                            <h3 style="margin: 0 0 8px 0;">${item.title || '标记点'}</h3>
                            <p style="margin: 0; color: #666;">${item.content}</p>
                        </div>
                    `);
                    infoWindowRef.current.open(map, marker.getPosition());
                }

                // 触发点击回调
                onMarkerClick?.(item);
            });

            return marker;
        });

        markersRef.current = markerInstances;

        // 启用聚合
        if (enableCluster && markerInstances.length > 0) {
            // 动态加载MarkerCluster插件
            // @ts-expect-error 高德地图的Typescript定义不完整
            map.plugin(["AMap.MarkerCluster"], () => {
                // 准备聚合数据
                const points = markerData.map(item => ({
                    lnglat: [item.location.lng, item.location.lat],
                    weight: 1,
                    extData: item
                }));

                // 渲染非聚合点
                const _renderMarker = (context: any) => {
                    const item = context.data[0].extData;

                    // 设置标记内容
                    const content = document.createElement('div');
                    content.innerHTML = `
                        <div style="
                            background-color: #ff4d4f;
                            width: 28px;
                            height: 28px;
                            border-radius: 50%;
                            border: 3px solid white;
                            box-shadow: 0 2px 8px rgba(0,0,0,.4);
                            cursor: pointer;
                            position: relative;
                        ">
                            <div style="
                                position: absolute;
                                top: 50%;
                                left: 50%;
                                transform: translate(-50%, -50%);
                                width: 8px;
                                height: 8px;
                                background-color: white;
                                border-radius: 50%;
                            "></div>
                        </div>
                    `;

                    context.marker.setContent(content);
                    context.marker.setOffset(new AMap.Pixel(-14, -14));
                    context.marker.setExtData(item);

                    // 绑定点击事件 - 使用context.marker而不是创建新标记
                    context.marker.on('click', (e: any) => {
                        const clickedItem = e.target.getExtData();
                        if (clickedItem.content && infoWindowRef.current) {
                            infoWindowRef.current.setContent(`
                                <div style="padding: 10px;">
                                    <h3 style="margin: 0 0 8px 0;">${clickedItem.title || '标记点'}</h3>
                                    <p style="margin: 0; color: #666;">${clickedItem.content}</p>
                                </div>
                            `);
                            infoWindowRef.current.open(map, e.target.getPosition());
                        }
                        onMarkerClick?.(clickedItem);
                    });

                    markersRef.current.push(context.marker);
                };

                // 渲染聚合点
                const _renderClusterMarker = (context: any) => {
                    const count = context.count;
                    const div = document.createElement('div');
                    const bgColor = count > 50 ? '#f56c6c' : count > 20 ? '#e6a23c' : '#67c23a';
                    const size = Math.min(60, Math.max(30, 30 + Math.sqrt(count) * 3));

                    div.style.backgroundColor = bgColor;
                    div.style.borderRadius = '50%';
                    div.style.color = 'white';
                    div.style.textAlign = 'center';
                    div.style.lineHeight = size + 'px';
                    div.style.width = size + 'px';
                    div.style.height = size + 'px';
                    div.style.fontSize = '14px';
                    div.style.fontWeight = 'bold';
                    div.style.border = '2px solid white';
                    div.style.boxShadow = '0 2px 6px rgba(0,0,0,.3)';
                    div.style.cursor = 'pointer';
                    div.innerHTML = count.toString();

                    context.marker.setOffset(new AMap.Pixel(-size/2, -size/2));
                    context.marker.setContent(div);
                };

                // 创建聚合实例
                const finalClusterOptions = {
                    gridSize: clusterOptions?.gridSize || 60,
                    maxZoom: clusterOptions?.maxZoom || 18,
                    averageCenter: clusterOptions?.averageCenter !== false,
                    renderMarker: _renderMarker,
                    renderClusterMarker: clusterOptions?.renderClusterMarker || _renderClusterMarker
                };

                clusterRef.current = new AMap.MarkerCluster(map, points, finalClusterOptions);

                // 添加聚合点点击事件 - 点击聚合点时放大地图
                clusterRef.current.on('click', (e: any) => {
                    // 如果是聚合点（包含多个标记）
                    if (e.clusterData && e.clusterData.length > 1) {
                        // 计算聚合中所有点的中心
                        let totalLng = 0, totalLat = 0;
                        e.clusterData.forEach((item: any) => {
                            totalLng += item.lnglat.lng;
                            totalLat += item.lnglat.lat;
                        });
                        const centerLng = totalLng / e.clusterData.length;
                        const centerLat = totalLat / e.clusterData.length;

                        // 放大地图到聚合点中心
                        const currentZoom = map.getZoom();
                        map.setZoomAndCenter(Math.min(currentZoom + 2, 18), [centerLng, centerLat]);
                    }
                });
            });
        } else {
            // 不使用聚合，直接添加到地图
            map.add(markerInstances);
        }
    }, [enableCluster, clusterOptions, onMarkerClick]);

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

    // 当标记数据变化时更新地图
    useEffect(() => {
        if (mapRef.current && configLoaded && (window as any).AMap) {
            const AMap = (window as any).AMap;
            addMarkers(AMap, mapRef.current, markers);
        }
    }, [markers, addMarkers, configLoaded]);

    // 初始化地图 - 配置加载成功后才执行
    useEffect(() => {
        if (!configLoaded || !apiConfigRef.current) return;

        const config = apiConfigRef.current;
        if (!config.apiKey)
            return;

        AMapLoader.load({
            key: config.apiKey, // 申请好的Web端开发者Key，首次调用 load 时必填
            version: "2.0", // 指定要加载的 JSAPI 的版本，缺省时默认为 1.4.15
            plugins: [
                "AMap.Scale",
                "AMap.Marker",
                "AMap.InfoWindow"
            ], //需要使用的的插件列表，如比例尺'AMap.Scale'，支持添加多个如：['...','...']
        })
            .then((AMap) => {
                const map = new AMap.Map(id, {
                    // 设置地图容器id
                    viewMode: "3D", // 是否为3D地图模式
                    zoom: 11, // 初始化地图级别
                    center: [defaultCenter.lng, defaultCenter.lat], // 初始化地图中心点位置
                }) as AMap.Map;

                // 创建红色的选择标记
                const selectMarkerContent = document.createElement('div');
                selectMarkerContent.innerHTML = `
                    <div style="
                        background-color: #ff4d4f;
                        width: 12px;
                        height: 12px;
                        border-radius: 50%;
                        border: 2px solid white;
                        box-shadow: 0 2px 6px rgba(0,0,0,.3);
                    "></div>
                `;

                const marker = new AMap.Marker({
                    position: [defaultCenter.lng, defaultCenter.lat],
                    content: selectMarkerContent,
                    offset: new AMap.Pixel(-6, -6),
                    map
                });
                map.add(marker);

                mapRef.current = map;
                markerRef.current = marker;

                // 创建信息窗口
                infoWindowRef.current = new AMap.InfoWindow({
                    offset: new AMap.Pixel(0, -30),
                    closeWhenClickMap: true
                });

                // 添加标记点
                if (markers && markers.length > 0) {
                    addMarkers(AMap, map, markers);
                }

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
            // 清理标记
            if (markersRef.current.length > 0) {
                markersRef.current.forEach(m => m.setMap(null));
                markersRef.current = [];
            }
            // 清理聚合
            if (clusterRef.current) {
                clusterRef.current.setMap(null);
                clusterRef.current = null;
            }
            // 清理信息窗口
            if (infoWindowRef.current) {
                infoWindowRef.current.close();
                infoWindowRef.current = null;
            }
            // 清理选择标记
            if (markerRef.current) {
                markerRef.current.setMap(null);
                markerRef.current = null;
            }
            mapRef.current?.destroy();
            mapRef.current = null;
        };
    }, [configLoaded, id]);

    return (
        <div className="h-full relative">
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
                <div className={cn(`flex items-center justify-center`, className)} >
                    <Spin size="large" />
                </div>
            ) : keyInvalid ? (
                <div className={cn(`flex items-center justify-center`, className)} >
                    <Empty description="地图配置无效，请检查API密钥设置" />
                </div>
            ) : (
                <div
                    id={id}
                    className={cn("h-full", className)}
                />
            )}
        </div>
    );
}

MapView.displayName = 'MapView';

export default MapView;