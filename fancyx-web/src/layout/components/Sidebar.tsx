import { Menu } from 'antd';
import UserStore from '@/store/userStore.ts';
import type { FrontendMenu } from '@/api/auth.ts';
import { Link } from 'react-router-dom';
import React from 'react';
import ProIcon from '@/components/ProIcon';
import { useDispatch, useSelector } from 'react-redux';
import { open, selectActiveKey } from '@/store/tabStore.ts';
import { selectCollapsed } from '@/store/themeStore.ts';
import { HomeOutlined } from '@ant-design/icons';

interface MenuItem {
  key: string;
  icon: React.ReactNode | null;
  label: React.ReactNode;
  children: MenuItem[] | null;
}

function Sidebar() {
  const dispatch = useDispatch();
  const activeKey = useSelector(selectActiveKey);
  const collapsed = useSelector(selectCollapsed);

  const addTab = (menu: FrontendMenu) => {
    dispatch(open(menu.path));
  };

  function convertToAntdMenuItems(menus: FrontendMenu[]) {
    return menus
      .filter((menu) => menu.display)
      .map((menu) => {
        const item: MenuItem = {
          key: menu.path ?? menu.id,
          icon: menu.icon ? <ProIcon icon={menu.icon} /> : null,
          label: menu.title,
          children: null,
        };

        if (menu.children && menu.children.length > 0) {
          item.children = convertToAntdMenuItems(menu.children);
        } else if (menu.path) {
          item.label = (
            <Link to={menu.path} onClick={() => addTab(menu)}>
              {menu.icon && <ProIcon icon={menu.icon} />}
              <span>{menu.title}</span>
            </Link>
          );
        }

        return item;
      });
  }

  const getItems = () => {
    const menus = UserStore.userInfo?.menus;
    if (Array.isArray(menus) && menus.length > 0) {
      return convertToAntdMenuItems(menus);
    }
    return [];
  };

  return (
    <div className="fancyx-sidebar">
      <div className="sidebar-header">
        <h2>
          <HomeOutlined className={'header-icon' + (collapsed ? ' header-icon-center' : '')} />
          {!collapsed && <span>风汐管理系统</span>}
        </h2>
      </div>

      <Menu mode="inline" items={getItems()} selectedKeys={[activeKey]} inlineCollapsed={collapsed} />
    </div>
  );
}

export default Sidebar;
