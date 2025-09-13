import httpClient from "@/utils/httpClient";

// 行政区域输出接口
export interface IRegionListOutput {
    id: string;
    code: string;
    parentCOde?: string;
    name: string;
    level: number;
    sort: number;
    creationTime: string;
    children?: IRegionListOutput[];
    hasChildren?: boolean;
    nextLevel?: number;
}


// 行政区域导入进度接口
export interface IRegionImportProgress {
    percentage: number;
    currentProvince: string;
    current: number;
    total: number;
    isImporting: boolean;
}

// 行政区域导入结果接口
export interface IRegionImportResult {
    totalCount: number;
    provincesCount: number;
    citiesCount: number;
    districtsCount: number;
    success: boolean;
    errorMessage?: string;
}

/**
 * 获取子级区域（统一使用基于Code的接口）
 */
export const getRegionChildren = async (parentCode?: string): Promise<IRegionListOutput[]> => {
    return await getRegionChildrenByCode(parentCode);
};

/**
 * 根据代码获取区域信息
 */
export const getRegionByCode = async (code: string): Promise<IRegionListOutput | null> => {
    return await httpClient.get<void, IRegionListOutput>(`/api/admin/regions/by-code/${code}`);
};


/**
 * 从高德地图导入行政区域
 * @param includeStreets 是否导入街道数据
 */
export const importFromAmap = async (includeStreets: boolean = false): Promise<IRegionImportResult> => {
    return await httpClient.post<void, IRegionImportResult>(`/api/admin/regions/import-from-amap`,
         { includeStreets });
};

/**
 * 获取导入进度
 */
export const getImportProgress = async (): Promise<IRegionImportProgress> => {
    return await httpClient.get<void, IRegionImportProgress>("/api/admin/regions/import-progress");
};

/**
 * 构建树形数据结构
 */
export const buildTreeData = (list: IRegionListOutput[]): IRegionListOutput[] => {
    const map: { [key: string]: IRegionListOutput } = {};
    const roots: IRegionListOutput[] = [];

    // 先建立映射表，并设置hasChildren
    list.forEach(item => {
        map[item.id] = {
            ...item,
            children: [],
            hasChildren: getHasChildrenByLevel(item.level)
        };
    });

    // 构建树形结构
    list.forEach(item => {
        if (item.parentCOde && map[item.parentCOde]) {
            map[item.parentCOde].children!.push(map[item.id]);
        } else {
            roots.push(map[item.id]);
        }
    });

    return roots;
};

/**
 * 根据层级判断节点是否可能有子节点
 */
const getHasChildrenByLevel = (level: number): boolean => {
    // 中国行政区划层级：
    // 1: 省/直辖市 - 通常有子节点
    // 2: 市/州 - 通常有子节点
    // 3: 县/区 - 可能有子节点（街道/乡镇）
    // 4: 街道/乡镇 - 通常没有子节点
    return level < 4;
};

/**
 * 获取层级名称
 */
export const getLevelName = (level: number): string => {
    switch (level) {
        case 1:
            return "省/直辖市";
        case 2:
            return "市/州";
        case 3:
            return "县/区";
        case 4:
            return "街道/乡镇";
        default:
            return "未知层级";
    }
};

/**
 * 根据父级code获取子级区域列表
 */
export const getRegionChildrenByCode = async (parentCode?: string): Promise<IRegionListOutput[]> => {
    const path = parentCode ? `/api/admin/regions/children-by-code/${parentCode}` : "/api/admin/regions/children-by-code";
    return await httpClient.get<void, IRegionListOutput[]>(path);
};

/**
 * 根据code获取区域完整路径
 */
export const getRegionPathByCodes = async (code: string): Promise<IRegionListOutput[]> => {
    return await httpClient.get<void, IRegionListOutput[]>(`/api/admin/regions/path-by-code/${code}`);
};

/**
 * 根据区域代码获取街道列表
 */
export const getStreets = async (regionCode: string): Promise<string[]> => {
    return await httpClient.get<void, string[]>(`/api/admin/regions/streets/${regionCode}`);
};