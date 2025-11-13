import type { INavigationMenuDto } from '@/application/types';

/**
 * 根据当前路由路径获取匹配的菜单项key
 * @param currentPath 当前路由路径
 * @param menus 菜单数据
 * @returns 匹配的菜单项key
 */
export function getSelectedMenuKey(currentPath: string, menus: INavigationMenuDto[]): string | null {
    // 处理外部链接路由，将 /external/* 转换回原始路径
    let matchPath = currentPath;
    if (currentPath.startsWith('/external/')) {
        matchPath = currentPath.replace('/external/', '');
    }

    // 规范化路径：移除末尾斜杠，转为小写
    const normalizePath = (path: string) => path.toLowerCase().replace(/\/$/, '');
    const normalizedMatchPath = normalizePath(matchPath);

    // 递归查找匹配的菜单项
    function findMatchingMenu(menuList: INavigationMenuDto[]): INavigationMenuDto | null {
        for (const menu of menuList) {
            // 优先检查当前菜单项是否匹配（精确匹配或子路由匹配）
            // 如果匹配，直接返回当前菜单项，不再递归检查子菜单
            // 这样可以确保父菜单项能够匹配其所有子路由
            if (menu.path) {
                const normalizedMenuPath = normalizePath(menu.path);
                
                // 精确匹配
                if (normalizedMenuPath === normalizedMatchPath) {
                    return menu;
                }
                
                // 前缀匹配 - 当前路径是菜单路径的子路径
                if (normalizedMatchPath.startsWith(normalizedMenuPath + '/')) {
                    return menu;
                }
            }
            
            // 如果当前菜单项不匹配，再递归查找子菜单
            const childMatch = findMatchingMenu(getChildMenus(menu.id, menus));
            if (childMatch) {
                return childMatch;
            }
        }
        return null;
    }

    // 获取根菜单项
    const rootMenus = menus.filter(menu => !menu.parentId);
    const matchedMenu = findMatchingMenu(rootMenus);
    
    return matchedMenu ? (matchedMenu.path ?? matchedMenu.id) : null;
}

/**
 * 根据选中的菜单项计算需要展开的所有父级菜单keys
 * @param selectedKey 选中的菜单项key
 * @param menus 菜单数据
 * @returns 需要展开的菜单keys数组
 */
export function getOpenMenuKeys(selectedKey: string | null, menus: INavigationMenuDto[]): string[] {
    if (!selectedKey) return [];

    // 找到选中的菜单项
    const selectedMenu = menus.find(menu => 
        (menu.path ?? menu.id) === selectedKey
    );
    
    if (!selectedMenu) return [];

    const openKeys: string[] = [];
    
    // 递归向上查找所有父级菜单
    function findParentKeys(menuId: string) {
        const menu = menus.find(m => m.id === menuId);
        if (!menu || !menu.parentId) return;
        
        const parentMenu = menus.find(m => m.id === menu.parentId);
        if (parentMenu) {
            const parentKey = parentMenu.path ?? parentMenu.id;
            openKeys.unshift(parentKey); // 添加到开头，保持层级顺序
            findParentKeys(parentMenu.id); // 继续向上查找
        }
    }
    
    findParentKeys(selectedMenu.id);
    
    return openKeys;
}

/**
 * 获取指定菜单项的子菜单
 * @param parentId 父菜单ID
 * @param menus 菜单数据
 * @returns 子菜单数组
 */
function getChildMenus(parentId: string, menus: INavigationMenuDto[]): INavigationMenuDto[] {
    return menus.filter(menu => menu.parentId === parentId);
}

/**
 * 检查菜单项是否有子菜单
 * @param menuId 菜单ID
 * @param menus 菜单数据
 * @returns 是否有子菜单
 */
export function hasChildMenus(menuId: string, menus: INavigationMenuDto[]): boolean {
    return menus.some(menu => menu.parentId === menuId);
}