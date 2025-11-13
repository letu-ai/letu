import httpClient from "@/utils/httpClient";

/**
 * 搜索地址（POI搜索）
 * @param keywords 关键字
 * @param city 城市（可选）
 * @returns POI列表
 */
export const searchAddress = async (
    keywords: string,
    city?: string
): Promise<IAmapPoi[]> => {
    return await httpClient.get<void, IAmapPoi[]>("/api/amap/poi", {
        params: {
            keywords,
            city: city || "",
            offset: 20,
            page: 1
        }
    });
};

/**
 * 逆地理编码（坐标转地址）
 * @param location 经纬度坐标，格式："lng,lat"
 * @returns 逆地理编码结果
 */
export const getAddressByLocation = async (
    location: string
): Promise<IAmapReGeoCode> => {
    return await httpClient.get<void, IAmapReGeoCode>("/api/amap/regeocode", {
        params: { location }
    });
};

/**
 * 地理编码（地址转坐标）
 * @param address 地址
 * @param city 城市（可选）
 * @returns 地理编码结果
 */
export const getLocationByAddress = async (
    address: string,
    city?: string
): Promise<IAmapGeoCode[]> => {
    return await httpClient.get<void, IAmapGeoCode[]>("/api/amap/geocode", {
        params: {
            address,
            city: city || ""
        }
    });
};

/**
 * 获取行政区域
 * @param adCode 行政区代码
 * @returns 行政区域列表
 */
export const getDistrict = async (adCode: string): Promise<IAmapDistrict[]> => {
    return await httpClient.get<void, IAmapDistrict[]>(`/api/amap/district/${adCode}`);
};

/**
 * 获取所有省份
 * @returns 省份列表
 */
export const getAllProvinces = async (): Promise<IAmapDistrict[]> => {
    return await httpClient.get<void, IAmapDistrict[]>("/api/amap/provinces");
};

/**
 * 获取高德地图Web端配置
 * @returns Web端配置信息
 */
export const getAmapWebConfig = async (): Promise<IAmapWebConfig> => {
    return await httpClient.get<void, IAmapWebConfig>("/api/amap/web-config");
};

// Map-related utility functions

/**
 * 坐标格式转换：字符串转对象
 * @param location 经纬度字符串，格式："lng,lat"
 * @returns 坐标对象
 */
export const parseLocationString = (location: string): { lng: number; lat: number } => {
    const [lng, lat] = location.split(',').map(Number);
    return { lng, lat };
};

/**
 * 坐标格式转换：对象转字符串
 * @param location 坐标对象
 * @returns 经纬度字符串
 */
export const formatLocationString = (location: { lng: number; lat: number }): string => {
    return `${location.lng},${location.lat}`;
};

/**
 * 计算两点间距离（米）
 * @param point1 坐标点1
 * @param point2 坐标点2
 * @returns 距离（米）
 */
export const calculateDistance = (
    point1: { lng: number; lat: number },
    point2: { lng: number; lat: number }
): number => {
    const R = 6371000; // 地球半径（米）
    const lat1Rad = (point1.lat * Math.PI) / 180;
    const lat2Rad = (point2.lat * Math.PI) / 180;
    const deltaLatRad = ((point2.lat - point1.lat) * Math.PI) / 180;
    const deltaLngRad = ((point2.lng - point1.lng) * Math.PI) / 180;

    const a =
        Math.sin(deltaLatRad / 2) * Math.sin(deltaLatRad / 2) +
        Math.cos(lat1Rad) *
            Math.cos(lat2Rad) *
            Math.sin(deltaLngRad / 2) *
            Math.sin(deltaLngRad / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return R * c;
};

// Type definitions

export interface IMapConfig {
    apiKey?: string;
    securityJsCode?: string;
}

export interface IAddressPickerValue {
    name?: string;          // POI名称
    address: string;        // 详细地址
    location: string;       // 经纬度，格式："lng,lat"
    province?: string;      // 省份
    city?: string;         // 城市
    district?: string;     // 区县
    adCode?: string;       // 行政区代码
}

export interface IAmapPoi {
    name: string;
    id: string;
    location: string;
    type: string;
    typeCode: string;
    provinceName: string;
    cityName: string;
    districtName: string;
    address: string;
    provinceCode: string;
    adCode: string;
    cityCode: string;
}

export interface IAmapGeoCode {
    formattedAddress: string;
    location: string;
    level: string;
    province: string;
    city: string;
    district: string;
    township: string;
    neighborhood: string;
    building: string;
    adCode: string;
    street: string;
    number: string;
    cityCode: string;
}

export interface IAmapDistrict {
    adCode: string;
    name: string;
    center: string;
    level: string;
    districts?: IAmapDistrict[];
}

export interface IAmapReGeoCode {
    formattedAddress: string;
    addressComponent: {
        country: string;
        province: string;
        city: string;
        citycode: string;
        district: string;
        adcode: string;
        township: string;
        towncode: string;
        neighborhood?: string;
        building?: string;
        streetNumber?: {
            street: string;
            number: string;
            location: string;
            direction: string;
            distance: string;
        };
    };
    pois?: IAmapPoi[];
}

export interface IAmapWebConfig {
    apiKey?: string;
    securityJsCode?: string;
}

export interface IAddressPickerProps {
    value?: IAddressPickerValue;
    onChange?: (value: IAddressPickerValue | undefined) => void;
    placeholder?: string;
    disabled?: boolean;
    allowClear?: boolean;
    className?: string;
    city?: string;          // 城市范围限制
    showMap?: boolean;      // 是否显示地图
    mapHeight?: number;     // 地图高度（像素）
}

// MapDisplay related types (re-exported from MapView.tsx)
export interface IMapLocation {
    lng: number;
    lat: number;
}

export interface IMapMarker {
    id?: string;
    location: IMapLocation;
    title?: string;
    content?: string;
    icon?: string | IMarkerIcon;  // 自定义图标
    draggable?: boolean;
    extData?: any;  // 扩展数据
}

// 标记图标配置
export interface IMarkerIcon {
    size?: [number, number];  // 图标尺寸
    image?: string;  // 图标图片地址
    imageSize?: [number, number];  // 图标显示大小
    imageOffset?: [number, number];  // 图标偏移量
}

// 聚合配置选项
export interface IClusterOptions {
    gridSize?: number;  // 聚合计算时网格的像素大小，默认60
    maxZoom?: number;  // 最大的聚合级别，大于该级别就不进行相应的聚合
    averageCenter?: boolean;  // 是否平均聚合点的位置
    renderClusterMarker?: (context: IClusterContext) => any;  // 自定义聚合点样式
    renderMarker?: (context: IMarkerContext) => any;  // 自定义非聚合点样式
    minClusterSize?: number;  // 最小聚合数量，默认2
}

// 聚合点上下文
export interface IClusterContext {
    count: number;  // 聚合点包含的标记数量
    markers: any[];  // 聚合点包含的标记
    marker: any;  // 聚合点标记实例
    clusterData: any[];  // 聚合数据
}

// 标记上下文
export interface IMarkerContext {
    marker: any;  // 标记实例
    data: IMapMarker;  // 标记数据
}

export interface IMapDisplayProps {
    apiKey?: string;
    securityJsCode?: string;
    height?: number;
    center?: IMapLocation;
    zoom?: number;
    marker?: IMapMarker;
    markers?: IMapMarker[];
    clickable?: boolean;
    disabled?: boolean;
    loading?: boolean;
    showTip?: boolean;
    tipText?: string;
    onMapClick?: (location: IMapLocation) => void;
    onMarkerDragEnd?: (location: IMapLocation, marker?: IMapMarker) => void;
    onMarkerClick?: (marker: IMapMarker) => void;
    onMapReady?: (map: any) => void;
    onError?: (error: string) => void;
}

export interface IMapDisplayRef {
    setCenter: (location: IMapLocation) => void;
    setZoom: (level: number) => void;
    setMarkerPosition: (location: IMapLocation | null) => void;
    getMarker: () => any;
    getMap: () => any;
}