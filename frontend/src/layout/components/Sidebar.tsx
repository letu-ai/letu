import { Menu } from 'antd';
import { Link } from 'react-router-dom';
import React, { useMemo } from 'react';
import ProIcon from '@/components/ProIcon';
import { useDispatch, useSelector } from 'react-redux';
import { open, selectActiveKey } from '@/store/tabStore.ts';
import { HomeOutlined } from '@ant-design/icons';
import useLayoutStore from '@/application/layoutStore';
import useAppConfigStore from '@/application/appConfigStore';
import type { INavigationMenuDto } from '@/application/types';

interface MenuItem {
  key: string;
  icon: React.ReactNode | null;
  label: React.ReactNode;
  children: MenuItem[] | null;
}

const Sidebar = () => {
  const dispatch = useDispatch();
  const activeKey = useSelector(selectActiveKey);
  const collapsed = useLayoutStore(state => state.collapsed);
  const menu = useAppConfigStore(state => state.menu);

  const addTab = (menu: INavigationMenuDto) => {
    if (menu.path) {
      dispatch(open(menu.path));
    }
  };

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
      const item: MenuItem = {
        key: node.path ?? node.id,
        icon: node.icon ? <ProIcon icon={node.icon} /> : null,
        label: node.title,
        children: null
      };

      if (node.children.length > 0) {
        item.children = node.children.map(toMenuItem);
      } else if (node.path) {
        // 叶子节点且有路径，创建可点击的链接
        let menuPath = node.path;
        if (node.isExternal) {
          menuPath = `/external/${node.path}`;
        }
        item.label = (
          <Link to={menuPath} onClick={() => addTab(node)}>
            <span>{node.title}</span>
          </Link>
        );
      }

      return item;
    };

    return roots.map(toMenuItem);
  }

  const calcItems = useMemo(() => {
    return convertToAntdMenuItems(menu);
  }, [menu]);

  return (
    <div className="letu-sidebar">
      <div className="sidebar-header">
        <h2>
          <HomeOutlined className={'header-icon' + (collapsed ? ' header-icon-center' : '')} />
          {!collapsed && <span>乐途管理系统</span>}
        </h2>
      </div>

      <Menu mode="inline" items={calcItems} selectedKeys={[activeKey]} inlineCollapsed={collapsed} />
    </div>
  );
};

export default Sidebar;
