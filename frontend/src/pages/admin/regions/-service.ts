import httpClient from "@/utils/httpClient";

// 行政区域输出接口
export interface IRegionListOutput {
    id: string;
    code: string;
    name: string;
    level: number;
    parentId?: string;
    sort: number;
    isEnabled: boolean;
    creationTime: string;
    children?: IRegionListOutput[];
    hasChildren?: boolean;
}

// 行政区域新增/编辑输入接口
export interface IRegionCreateOrUpdateInput {
    code: string;
    name: string;
    parentId?: string;
    sort: number;
    isEnabled: boolean;
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
 * 获取子级区域
 */
export const getRegionChildren = async (parentId?: string): Promise<IRegionListOutput[]> => {
    const path = parentId ? `/api/admin/regions/children/${parentId}` : "/api/admin/regions/children";
    return await httpClient.get<void, IRegionListOutput[]>(path);
};

/**
 * 根据代码获取区域信息
 */
export const getRegionByCode = async (code: string): Promise<IRegionListOutput | null> => {
    return await httpClient.get<void, IRegionListOutput>(`/api/admin/regions/by-code/${code}`);
};

/**
 * 新增行政区域
 */
export const createRegion = async (data: IRegionCreateOrUpdateInput): Promise<IRegionListOutput> => {
    return await httpClient.post<IRegionCreateOrUpdateInput, IRegionListOutput>("/api/admin/regions", data);
};

/**
 * 更新行政区域
 */
export const updateRegion = async (id: string, data: IRegionCreateOrUpdateInput): Promise<IRegionListOutput> => {
    return await httpClient.put<IRegionCreateOrUpdateInput, IRegionListOutput>(`/api/admin/regions/${id}`, data);
};

/**
 * 删除行政区域
 */
export const deleteRegion = async (id: string): Promise<void> => {
    await httpClient.delete<void, void>(`/api/admin/regions/${id}`);
};

/**
 * 从高德地图导入行政区域
 */
export const importFromAmap = async (): Promise<IRegionImportResult> => {
    return await httpClient.post<void, IRegionImportResult>("/api/admin/regions/import-from-amap");
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
        if (item.parentId && map[item.parentId]) {
            map[item.parentId].children!.push(map[item.id]);
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
 * 在树中查找指定节点
 */
export const findNodeInTree = (nodes: IRegionListOutput[], nodeId: string): IRegionListOutput | null => {
    for (const node of nodes) {
        if (node.id === nodeId) return node;
        if (node.children) {
            const found = findNodeInTree(node.children, nodeId);
            if (found) return found;
        }
    }
    return null;
};

/**
 * 更新树中的指定节点
 */
export const updateNodeInTree = (nodes: IRegionListOutput[], nodeId: string, updatedData: Partial<IRegionListOutput>): IRegionListOutput[] => {
    return nodes.map(node => {
        if (node.id === nodeId) {
            return { ...node, ...updatedData };
        }
        if (node.children) {
            return { ...node, children: updateNodeInTree(node.children, nodeId, updatedData) };
        }
        return node;
    });
};

/**
 * 从树中删除指定节点
 */
export const removeNodeFromTree = (nodes: IRegionListOutput[], nodeId: string): IRegionListOutput[] => {
    return nodes.filter(node => node.id !== nodeId)
        .map(node => ({
            ...node,
            children: node.children ? removeNodeFromTree(node.children, nodeId) : undefined
        }));
};