import httpClient from '@/utils/httpClient';

/**
 * 新增菜单
 * @param input
 */
export function addMenu(input: MenuDto) {
  return httpClient.post<MenuDto, void>('/api/admin/menus', input);
}

/**
 * 菜单树形列表
 * @param input
 */
export function getMenuList(input: MenuQueryDto) {
  return httpClient.get<MenuQueryDto, MenuListDto[]>('/api/admin/menus', { params: input });
}

/**
 * 修改菜单
 * @param input
 */
export function updateMenu(id: string, input: MenuDto) {
  return httpClient.put<MenuDto, void>(`/api/admin/menus/${id}`, input);
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
 * @param onlyMenu
 * @param keyword
 */
export function getMenuOptions(onlyMenu: boolean, keyword?: string) {
  return httpClient.get<number, MenuOptionResultDto>('/api/admin/menus/menu-options', {
    params: {
      onlyMenu: onlyMenu,
      keyword: keyword,
    },
  });
}

export interface MenuDto {
  id?: string | null;
  title: string;
  name?: string;
  icon?: string | null;
  path: string | null;
  menuType: number;
  permission?: string;
  parentId?: string | null;
  sort: number;
  display: boolean;
  component?: string;
  isExternal?: boolean;
}

export interface MenuQueryDto {
  title?: string | null;
  path?: string | null;
}

export interface MenuOptionResultDto {
  keys: string[];
  tree: MenuOptionTreeDto[];
}

export interface MenuOptionTreeDto {
  key: string;
  title?: string;
  extra?: never;
  children?: MenuOptionTreeDto[];
}

export interface MenuListDto {
  id: string;
  title: string;
  icon: string | null;
  path: string | null;
  menuType: number;
  permission: string;
  parentId: string;
  sort: number;
  display: boolean;
  component: string;
  children: MenuListDto[];
  isExternal: boolean;
}
