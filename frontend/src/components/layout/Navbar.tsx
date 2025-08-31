import { Button } from 'antd';
import ProIcon from '@/components/ProIcon';
import { useRef } from 'react';
import SearchModal, { type SearchModalRef } from '@/components/layout/SearchModal';
import UserNotification from '@/components/layout/UserNotification';
import useLayoutStore from '@/application/layoutStore';
import UserInfo from './UserInfo';
import SizeChanger from './SizeChanger';
import NavBreadcrumb from './NavBreadcrumb';



const Navbar = () => {
    const collapsed = useLayoutStore(state => state.collapsed);
    const toggleCollapsed = useLayoutStore(state => state.toggleCollapsed);
    const searchModalRef = useRef<SearchModalRef>(null);

    const setCollapsed = () => {
        toggleCollapsed();
    };

  

    return (
        <>
            <div className="flex justify-between w-full h-16 bg-white" >
                <div className="flex items-center">
                    <Button type="text" onClick={setCollapsed} className="">
                        <ProIcon icon={collapsed ? 'antd:MenuUnfoldOutlined' : 'antd:MenuFoldOutlined'} />
                    </Button>
                    <NavBreadcrumb/>
                </div>
                {/* 右侧菜单 */}
                <div className="grow flex flex-row-reverse items-center">
                    <UserInfo />
                    {/** 通知 */}
                    <UserNotification />
                    {/** 尺寸 */}
                    <SizeChanger />
                    
                    <Button type="text" className="" onClick={searchModalRef?.current?.openModal}>
                        <ProIcon icon="antd:SearchOutlined" />
                    </Button>
                    {/* 搜索框 */}
                    <SearchModal ref={searchModalRef} />
                </div>
            </div>
        </>
    );
}

export default Navbar;
