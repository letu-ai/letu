import { Avatar, Breadcrumb, Button, Dropdown, type MenuProps } from 'antd';
import ProIcon from '@/components/ProIcon';
import { useLocation, useNavigate } from 'react-router-dom';
import { open } from '@/store/tabStore.ts';
import { useMemo, useRef } from 'react';
import { LogoutOutlined, UserOutlined } from '@ant-design/icons';
import SearchModal, { type SearchModalRef } from '@/layout/components/SearchModal';
import NotificationPopover from '@/layout/components/NotificationPopover';
import useLayoutStore, { isSizeType, type SizeType } from '@/application/layoutStore';
import { useDispatch } from 'react-redux';
import { StaticRoutes } from '@/utils/globalValue';
import type { MenuItemType } from 'antd/lib/menu/interface';
import useAppConfigStore from '@/application/appConfigStore';
import type { INavigationMenuDto } from '@/application/types';

const userItems: MenuProps['items'] = [
  {
    key: 'profile',
    label: '个人信息',
    icon: <UserOutlined />,
  },
  {
    type: 'divider',
  },
  {
    key: 'logout',
    label: '退出登录',
    icon: <LogoutOutlined />,
  },
];

interface ISizeItem extends MenuItemType {
  icon: React.ReactNode;
  key: SizeType;
  label: string;
}

const sizeItems: ISizeItem[] = [
  {
    key: 'large',
    icon: <ProIcon icon="antd:FontSizeOutlined" />,
    label: '大',
  },
  {
    key: 'middle',
    icon: <ProIcon icon="antd:FontSizeOutlined" />,
    label: '中',
  },
  {
    key: 'small',
    icon: <ProIcon icon="antd:FontSizeOutlined" />,
    label: '小',
  },
];

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

const Navbar = () => {
  const collapsed = useLayoutStore(state => state.collapsed);
  const toggleCollapsed = useLayoutStore(state => state.toggleCollapsed);
  const size = useLayoutStore(state => state.size);
  const setSize = useLayoutStore(state => state.setSize);
  const currentUser = useAppConfigStore(state => state.currentUser);
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const searchModalRef = useRef<SearchModalRef>(null);
  const menu = useAppConfigStore(state => state.menu);

  const location = useLocation();
  const setCollapsed = () => {
    toggleCollapsed();
  };

  const onClick = ({ key }: { key: string }) => {
    switch (key) {
      case 'logout':
        navigate(StaticRoutes.logout);
        break;

      case 'profile':
        navigate('/admin/profile');
        dispatch(open('/admin/profile'));
        break;

      default:
        if (isSizeType(key)) {
          setSize(key);
        }
        break;
    }
  };

  const sizeDisplayText = useMemo(() => {
    return sizeItems.find((h) => h.key === size)?.label ?? '';
  }, [size]);

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
    <>
      <div className="flex w-full letu-navbar">
        <div>
          <Button type="text" onClick={setCollapsed} className="navbar-btn">
            <ProIcon icon={collapsed ? 'antd:MenuUnfoldOutlined' : 'antd:MenuFoldOutlined'} />
          </Button>
        </div>
        <div className="ml-10 letu-navbar-breadcrumb-wrapper">
          <Breadcrumb items={breadcrumbItems} />
        </div>
        {/* 右侧菜单 */}
        <div className="grow flex flex-row-reverse letu-navbar-right-wrapper">
          <div>
            <Dropdown
              menu={{
                items: userItems,
                selectable: true,
                onClick,
              }}
              trigger={['click']}
            >
              <Button type="text" className="navbar-btn">
                {currentUser.avatar ? (
                  <Avatar size={28} src={"ossDomain" + currentUser.avatar} alt="头像" />
                ) : (
                  <Avatar size={28} icon={<UserOutlined />} />
                )}
                {currentUser.name ?? currentUser.userName}
              </Button>
            </Dropdown>
          </div>
          {/** 通知 */}
          <div>
            <NotificationPopover />
          </div>
          {/** 尺寸 */}
          <div>
            <Dropdown
              overlayClassName="size-wrapper"
              menu={{
                items: sizeItems,
                selectable: true,
                onClick,
              }}
              trigger={['click']}
            >
              <Button type="text" className="navbar-btn">
                <ProIcon icon="antd:FontSizeOutlined" />
                {sizeDisplayText}
              </Button>
            </Dropdown>
          </div>
          {/** 搜索 */}
          <div>
            <Button type="text" className="navbar-btn" onClick={searchModalRef?.current?.openModal}>
              <ProIcon icon="antd:SearchOutlined" />
            </Button>
            {/* 搜索框 */}
            <SearchModal ref={searchModalRef} />
          </div>
        </div>
      </div>
    </>
  );
}

export default Navbar;
