import { useAppConfig } from '@/components/AppConfigProvider';
import type { INavigationMenuDto } from '@/application/types';
import { useLocation } from '@tanstack/react-router';
import { Breadcrumb } from 'antd';
import { useMemo } from 'react';


// 从 menu 中查找当前路径对应的菜单项
const findMenuByPath = (menus: INavigationMenuDto[], path: string): INavigationMenuDto | null => {
    for (const menuItem of menus) {
        if (menuItem.path === path) {
            return menuItem;
        }
    }
    return null;
};


// 根据菜单ID构建层级路径
const findMenuById = (menus: INavigationMenuDto[], targetId: string): INavigationMenuDto | null => {
    for (const menuItem of menus) {
        if (menuItem.id === targetId) {
            return menuItem;
        }
    }

    return null;
};

function NavBreadcrumb() {
    const { menu } = useAppConfig();
    const location = useLocation();

    const breadcrumbItems = useMemo((): { title: string }[] => {
        const currentMenu = findMenuByPath(menu, location.pathname);
        if (!currentMenu)
            return [];

        const breadcrumbs: { title: string, path?: string }[] = [];
        let current: INavigationMenuDto | null = currentMenu;

        // 从当前菜单向上查找父级菜单
        while (current) {
            breadcrumbs.unshift({ title: current.title, path: current.path ?? undefined });
            if (current.parentId) {
                current = findMenuById(menu, current.parentId);
            } else {
                current = null;
            }
        }

        return breadcrumbs;
    }, [location.pathname, menu]);

    return (
        <Breadcrumb items={breadcrumbItems} />
    );
}

export default NavBreadcrumb;