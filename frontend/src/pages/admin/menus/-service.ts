import httpClient from '@/utils/httpClient';

/**
 * 新增菜单
 * @param input
 */
export function addMenu(input: IMenuItemCreateOrOutput) {
  return httpClient.post<IMenuItemCreateOrOutput, void>('/api/admin/menus', input);
}

/**
 * 菜单树形列表
 * @param input
 */
export function getMenuList(input: IMenuItemListInput) {
  return httpClient.get<IMenuItemListInput, IMenuItemListOutput[]>("/api/admin/menus/", { params: input });
}

/**
 * 修改菜单
 * @param input
 */
export function updateMenu(id: string, input: IMenuItemCreateOrOutput) {
  return httpClient.put<IMenuItemCreateOrOutput, void>(`/api/admin/menus/${id}`, input);
}

/**
 * 删除菜单
 * @param ids
 */
export function deleteMenu(ids: string[]) {
  return httpClient.delete<string[], void>('/api/admin/menus', {
    data: ids,
  });
}

/**
 * 获取菜单组成的选项树
 * @param onlyFolder
 * @param keyword
 */
export function getMenuOptions(appName: string, onlyFolder: boolean = false) {
  return httpClient.get<number, IMenuTreeSelectOption[]>(`/api/admin/menus/${appName}/tree-options`, {
    params: {
      onlyFolder
    },
  });
}

/**
 * 菜单类型
 */
export const MenuType = {
  Folder: 1,
  Menu: 2,
} as const;

export type MenuType = typeof MenuType[keyof typeof MenuType];


export interface IMenuItemCreateOrOutput {
  title: string;
  icon?: string | null;
  path: string | null;
  applicationName: string;
  menuType: MenuType;
  parentId?: string | null;
  sort: number;
  display: boolean;
  isExternal?: boolean;
  permissions?: string[];
  features?: string[];
}

export interface IMenuItemListInput {
  applicationName: string;
  title?: string | null;
  path?: string | null;
}

export interface IMenuTreeSelectOption {
  parent?: string;
  value: string;
  label: string;
  children?: IMenuTreeSelectOption[];
}

export interface IMenuItemListOutput {
  id: string;
  title: string;
  icon: string | null;
  path: string | null;
  menuType: MenuType;
  parentId: string;
  sort: number;
  display: boolean;
  children: IMenuItemListOutput[];
  isExternal: boolean;
  permissions?: string[];
  permissionDisplayNames?: string[]; // 权限显示名称（权限组/权限名）
  features?: string[];
  featureDisplayNames?: string[]; // 功能显示名称（功能组/功能名）
}
