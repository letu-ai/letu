import { Menu } from 'antd';
import UserStore from '@/store/userStore.ts';
import type { IFrontendMenu } from '@/pages/accounts/service';
import { Link } from 'react-router-dom';
import React, { useMemo } from 'react';
import ProIcon from '@/components/ProIcon';
import { useDispatch, useSelector } from 'react-redux';
import { open, selectActiveKey } from '@/store/tabStore.ts';
import { HomeOutlined } from '@ant-design/icons';
import { observer } from 'mobx-react-lite';
import _ from 'lodash';
import useLayoutStore from '@/store/layoutStore';

interface MenuItem {
  key: string;
  icon: React.ReactNode | null;
  label: React.ReactNode;
  children: MenuItem[] | null;
}

const Sidebar = observer(() => {
  const dispatch = useDispatch();
  const activeKey = useSelector(selectActiveKey);
  const collapsed = useLayoutStore(state => state.collapsed);

  const addTab = (menu: IFrontendMenu) => {
    dispatch(open(menu.path));
  };

  function convertToAntdMenuItems(menus: IFrontendMenu[]) {
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
          if (menu.isExternal) {
            menu.path = `/external/${menu.path}`;
          }
          item.label = (
            <Link to={menu.path} onClick={() => addTab(menu)}>
              <span>{menu.title}</span>
            </Link>
          );
        }

        return item;
      });
  }

  /* eslint-disable react-hooks/exhaustive-deps */
  const calcItems = useMemo(() => {
    const menus = _.cloneDeep(UserStore.userInfo?.menus ?? []);
    if (Array.isArray(menus) && menus.length > 0) {
      return convertToAntdMenuItems(menus);
    }
    return [];
  }, [UserStore.userInfo?.menus]);

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
});

export default Sidebar;
