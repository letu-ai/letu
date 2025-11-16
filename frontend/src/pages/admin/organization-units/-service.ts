import httpClient from '@/utils/httpClient';

// 字典常量
export const ORGANIZATION_UNIT_CATEGORY_DICT = 'organization-unit-category';
export const ORGANIZATION_UNIT_TYPE_DICT = 'organization-unit-type';

/**
 * 新增组织单元
 * @param input
 */
export function addOrganizationUnit(input: OrganizationUnitCreateOrUpdateInput) {
    return httpClient.post<OrganizationUnitCreateOrUpdateInput, void>('/api/admin/organization-units', input);
}

/**
 * 组织单元列表
 * @param dto
 */
export function getOrganizationUnitList(input: OrganizationUnitListInput) {
    return httpClient.get<OrganizationUnitListInput, OrganizationUnitListOutput[]>('/api/admin/organization-units', { params: input });
}

/**
 * 修改组织单元
 * @param input
 */
export function updateOrganizationUnit(id: string, input: OrganizationUnitCreateOrUpdateInput) {
    return httpClient.put<OrganizationUnitCreateOrUpdateInput, void>(`/api/admin/organization-units/${id}`, input);
}

/**
 * 删除组织单元
 * @param id 部门ID
 */
export function deleteOrganizationUnit(id: string) {
    return httpClient.delete<string, void>(`/api/admin/organization-units/${id}`);
}

export interface OrganizationUnitListOutput {
    id: string;
    parentId?: string;
    name: string;
    sort: number;
    category: string;
    type?: string;
    regionCode?: string;
    streetName?: string;
    address?: string;
    contactPerson?: string;
    contactPhone?: string;
    longitude?: number;
    latitude?: number;
}

export interface OrganizationUnitListInput {
    name?: string;
    category?: string;
}

export interface OrganizationUnitCreateOrUpdateInput {
    name: string;
    sort: number;
    parentId?: string;
    category: string;
    type?: string;
    regionCode?: string;
    streetName?: string;
    address?: string;
    contactPerson?: string;
    contactPhone?: string;
    longitude?: number;
    latitude?: number;
}

export interface OrganizationUnitTreeNode extends OrganizationUnitListOutput {
    children?: OrganizationUnitTreeNode[];
}

/**
 * 将扁平组织机构列表构造成树，并删除叶子空 children，避免展开按钮
 */
export function buildOrganizationUnitTree(list: OrganizationUnitListOutput[]): OrganizationUnitTreeNode[] {
    const map = new Map<string, OrganizationUnitTreeNode>();
    const roots: OrganizationUnitTreeNode[] = [];
    list.forEach((item) => {
        map.set(item.id, { ...item, children: [] });
    });
    list.forEach((item) => {
        const node = map.get(item.id)!;
        if (item.parentId && map.has(item.parentId)) {
            map.get(item.parentId)!.children!.push(node);
        } else {
            roots.push(node);
        }
    });
    const sortChildren = (nodes: OrganizationUnitTreeNode[]) => {
        nodes.sort((a, b) => (a.sort ?? 0) - (b.sort ?? 0));
        nodes.forEach((n) => n.children && n.children.length && sortChildren(n.children));
    };
    sortChildren(roots);
    const prune = (nodes: OrganizationUnitTreeNode[]) => {
        nodes.forEach((n) => {
            if (n.children && n.children.length > 0) {
                prune(n.children);
            } else {
                delete n.children;
            }
        });
    };
    prune(roots);
    return roots;
}

/**
 * 从树中排除指定节点及其所有子孙，返回新的树（不修改输入）
 */
export function excludeOrganizationSubtree(nodes: OrganizationUnitTreeNode[], targetId: string): OrganizationUnitTreeNode[] {
    const clone = (arr: OrganizationUnitTreeNode[]): OrganizationUnitTreeNode[] =>
        arr.map(n => ({ ...n, children: n.children ? clone(n.children) : undefined }));
    const pruned = (arr: OrganizationUnitTreeNode[]): OrganizationUnitTreeNode[] =>
        arr
            .filter(n => n.id !== targetId)
            .map(n => {
                const children = n.children ? pruned(n.children) : undefined;
                const node: OrganizationUnitTreeNode = { ...n, ...(children && children.length > 0 ? { children } : {}) };
                return node;
            });
    return pruned(clone(nodes));
}
