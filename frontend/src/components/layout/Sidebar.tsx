import { Menu, type MenuProps } from 'antd';
import { Link, useLocation } from '@tanstack/react-router';
import { useMemo, useState } from 'react';
import ProIcon from '@/components/ProIcon';
import { HomeOutlined } from '@ant-design/icons';
import useLayoutStore from '@/application/layoutStore';
import useAppConfigStore from '@/application/appConfigStore';
import type { INavigationMenuDto } from '@/application/types';
import type { MenuItemType, SubMenuType } from 'antd/es/menu/interface';
import { cn } from '@/utils/cssUtils';
import { getSelectedMenuKey, getOpenMenuKeys } from '@/utils/menuUtils';

type MenuItem = MenuItemType | SubMenuType;

function convertToAntdMenuItems(menus: INavigationMenuDto[]): MenuItem[] {
    // 1) 将一维数组构造成树（依据 parentId，根为 parentId 空/未找到父级）
    type MenuTreeNode = INavigationMenuDto & { children: MenuTreeNode[] };

    const nodes: MenuTreeNode[] = menus.map((m) => ({ ...m, children: [] }));
    const idMap = new Map<string, MenuTreeNode>();
    nodes.forEach((n) => idMap.set(n.id, n));

    const roots: MenuTreeNode[] = [];
    nodes.forEach((n) => {
        const pid = n.parentId;
        if (pid && idMap.has(pid)) {
            idMap.get(pid)!.children.push(n);
        } else {
            // parentId 为空或未找到父级，视为根
            roots.push(n);
        }
    });

    // 2) 递归按 sort 升序排序
    const sortRecursive = (list: MenuTreeNode[]) => {
        list.sort((a, b) => (a.sort ?? 0) - (b.sort ?? 0));
        list.forEach((child) => sortRecursive(child.children));
    };
    sortRecursive(roots);

    // 3) 映射为 Antd 的 MenuItem
    const toMenuItem = (node: MenuTreeNode): MenuItem => {
        if (node.children.length > 0) {
            // 有子菜单，返回 SubMenuType
            const subMenu: SubMenuType = {
                key: node.path ?? node.id,
                icon: node.icon ? <ProIcon icon={node.icon} /> : null,
                label: node.title,
                children: node.children.map(toMenuItem),
            };
            return subMenu;
        } else {
            // 叶子节点，返回 MenuItemType
            const menuItem: MenuItemType = {
                key: node.path ?? node.id,
                icon: node.icon ? <ProIcon icon={node.icon} /> : null,
                label: node.title,
            };

            if (node.path) {
                // 有路径，创建可点击的链接
                let menuPath = node.path;
                if (node.isExternal) {
                    menuPath = `/external/${node.path}`;
                }
                menuItem.label = (
                    <Link to={menuPath}>
                        <span>{node.title}</span>
                    </Link>
                );
            }

            return menuItem;
        }
    };

    return roots.map(toMenuItem);
}

function getSelectedKeyFromItems(pathname: string, items: MenuItem[]): string | null {
    for (const item of items) {
        const key = item.key as string;
        
        // 精确匹配或路径包含匹配
        if (pathname === key || pathname.startsWith(key + '/')) {
            return key;
        }
        
        // 递归检查子菜单
        if ('children' in item && item.children) {
            const found = getSelectedKeyFromItems(pathname, item.children as MenuItem[]);
            if (found) return found;
        }
    }
    return null;
}

function getOpenKeysFromItems(selectedKey: string, items: MenuItem[]): string[] {
    const openKeys: string[] = [];
    
    const findPath = (targetKey: string, menuItems: MenuItem[], currentPath: string[] = []): boolean => {
        for (const item of menuItems) {
            const key = item.key as string;
            const newPath = [...currentPath, key];
            
            if (key === targetKey) {
                openKeys.push(...currentPath);
                return true;
            }
            
            if ('children' in item && item.children) {
                if (findPath(targetKey, item.children as MenuItem[], newPath)) {
                    return true;
                }
            }
        }
        return false;
    };
    
    findPath(selectedKey, items);
    return openKeys;
}

interface ISidebarProps {
    className?: string;
    menu?: MenuItem[];
}

const Sidebar = ({ className, menu: propMenu }: ISidebarProps) => {
    const collapsed = useLayoutStore(state => state.collapsed);
    const storeMenu = useAppConfigStore(state => state.menu);
    const location = useLocation();
    
    // 用户手动操作的展开状态
    const [userOpenKeys, setUserOpenKeys] = useState<string[]>([]);
    
    const calcItems = useMemo(() => {
        return propMenu || convertToAntdMenuItems(storeMenu);
    }, [propMenu, storeMenu]);
    
    // 根据当前路由计算选中的菜单项
    const selectedKeys = useMemo(() => {
        if (propMenu) {
            // 使用自定义菜单时，从菜单项中匹配
            const selectedKey = getSelectedKeyFromItems(location.pathname, propMenu);
            return selectedKey ? [selectedKey] : [];
        } else {
            // 使用 store 菜单时，保持原有逻辑
            const selectedKey = getSelectedMenuKey(location.pathname, storeMenu);
            return selectedKey ? [selectedKey] : [];
        }
    }, [location.pathname, propMenu, storeMenu]);
    
    // 根据选中菜单项计算需要展开的菜单
    const autoOpenKeys = useMemo(() => {
        const selectedKey = selectedKeys[0];
        if (!selectedKey) return [];
        
        if (propMenu) {
            // 使用自定义菜单时，从菜单项中计算展开状态
            return getOpenKeysFromItems(selectedKey, propMenu);
        } else {
            // 使用 store 菜单时，保持原有逻辑
            return getOpenMenuKeys(selectedKey, storeMenu);
        }
    }, [selectedKeys, propMenu, storeMenu]);
    
    // 合并自动展开和用户手动展开的菜单
    const openKeys = useMemo(() => {
        const allOpenKeys = new Set([...autoOpenKeys, ...userOpenKeys]);
        return Array.from(allOpenKeys);
    }, [autoOpenKeys, userOpenKeys]);
    
    // 处理菜单展开/收起
    const handleOpenChange: MenuProps['onOpenChange'] = (keys) => {
        setUserOpenKeys(keys as string[]);
    };

    return (
        <div className={cn("bg-white min-h-screen border-r border-gray-200", className)}>
            <div className="h-16 bg-primary">
                <Link to="/">
                    <h2 className="flex items-center h-full px-4 text-white text-xl font-semibold">
                        <HomeOutlined className={'text-2xl pr-1 header-icon' + (collapsed ? ' header-icon-center' : '')} />
                        {!collapsed && <span>乐途管理系统</span>}
                    </h2>
                </Link>
            </div>

            <Menu 
                className='bg-gray-200' 
                mode="inline" 
                items={calcItems} 
                inlineCollapsed={collapsed}
                selectedKeys={selectedKeys}
                openKeys={openKeys}
                onOpenChange={handleOpenChange}
            />
        </div>
    );
};

export default Sidebar;
