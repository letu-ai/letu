import { Avatar, Breadcrumb, Button, Dropdown, type MenuProps } from 'antd';
import ProIcon from '@/components/ProIcon';
import { logout } from '@/pages/accounts/service';
import { useLocation, useNavigate } from 'react-router-dom';
import UserStore from '@/store/userStore.ts';
import { open } from '@/store/tabStore.ts';
import { useMemo, useRef } from 'react';
import { LogoutOutlined, UserOutlined } from '@ant-design/icons';
import SearchModal, { type SearchModalRef } from '@/layout/admin/components/SearchModal';
import { useApplication } from '@/components/Application';
import { StaticRoutes } from '@/utils/globalValue.ts';
import { useAuthProvider } from '@/components/AuthProvider';
import { observer } from 'mobx-react-lite';
import NotificationPopover from '@/layout/admin/components/NotificationPopover';
import useLayoutStore, { isSizeType, type SizeType } from '@/store/layoutStore';
import { useDispatch } from 'react-redux';

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

interface ISizeItem {
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

const Navbar = observer(() => {
  const collapsed = useLayoutStore(state => state.collapsed);
  const toggleCollapsed = useLayoutStore(state => state.toggleCollapsed);
  const size = useLayoutStore(state => state.size);
  const setSize = useLayoutStore(state => state.setSize);
  const navigate = useNavigate();
  const searchModalRef = useRef<SearchModalRef>(null);
  const { clearToken } = useAuthProvider();
  const { ossDomain } = useApplication();
  const dispatch = useDispatch();

  const location = useLocation();
  const setCollapsed = () => {
    toggleCollapsed();
  };

  const onClick = ({ key }: { key: string }) => {
    if (key === 'logout') {
      logout().then(() => {
        clearToken();
        navigate(StaticRoutes.Login);
      });
    } else if (key === 'profile') {
      navigate('/admin/profile');
      dispatch(open('/admin/profile'));
    } else if (isSizeType(key)) {
      setSize(key);
    }
  };
  const sizeDisplayText = useMemo(() => {
    return sizeItems.find((h) => h.key === size)?.label ?? '';
  }, [size]);
  const breadcrumbItems = useMemo((): { title: string }[] => {
    const curMenu = UserStore.menuList.find((x) => x.path === location.pathname);
    if (curMenu) {
      return curMenu.layerName.split('/').map((x) => {
        return { title: x };
      });
    }
    return [];
  }, [location.pathname]);

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
                {UserStore.userInfo?.avatar ? (
                  <Avatar size={28} src={ossDomain + UserStore.userInfo?.avatar} alt="头像" />
                ) : (
                  <Avatar size={28} icon={<UserOutlined />} />
                )}
                {UserStore.userInfo?.nickName ?? UserStore.userInfo?.userName}
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
});

export default Navbar;
