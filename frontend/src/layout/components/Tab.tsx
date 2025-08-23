import { Tabs } from 'antd';
import { selectTabs, selectActiveKey, remove, setActiveKey } from '@/store/tabStore.ts';
import { useSelector, useDispatch } from 'react-redux';
import { useNavigate } from 'react-router';
import styled from 'styled-components';
import { useEffect } from 'react';
import { useLocation } from 'react-router-dom';
import useAppConfigStore from '@/application/appConfigStore';

const StyledTabs = styled(Tabs)`
  .ant-tabs-nav {
    margin-bottom: 0 !important;
  }

  .ant-tabs-nav-wrap,
  .ant-tabs-nav-list,
  .ant-tabs-tab {
    border: none !important;
    border-radius: 0 !important;
  }

  .ant-tabs-tab {
    background: #e5e5e5 !important;
    margin: 6px 6px !important;
    padding: 4px 10px !important;
    border-radius: 4px !important;
    font-size: 12px !important;
  }

  .ant-tabs-nav::before {
    border-bottom: none !important;
  }

  .ant-tabs-tab-active {
    background: #ecf5ff !important;
  }
`;

const Tab = () => {
  const tabs: any[] = useSelector(selectTabs);
  const activeKey = useSelector(selectActiveKey);
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const location = useLocation();
  const menu = useAppConfigStore(state => state.menu);

  useEffect(() => {
    if (location.pathname) {
      onChange(location.pathname);
    }
  }, [location.pathname]);

  /**
   * 切换面板回调
   * @param {*} newActiveKey
   */
  const onChange = (newActiveKey: string) => {
    if (newActiveKey === '' || newActiveKey === '/') {
      navigate('/');
      dispatch(setActiveKey(newActiveKey));
    }
    const tmp = menu.find((h) => h.path === newActiveKey);
    if (!tmp)
      return;

    navigate(newActiveKey);
    dispatch(setActiveKey(newActiveKey));
  };
  const onEdit = (targetKey: string, action: string) => {
    if (action === 'remove') {
      dispatch(remove(targetKey));
      //找到要跳转/指定的活动标签
      const index = tabs.findIndex((h) => h.key === targetKey && targetKey !== '');
      if (index > 0) {
        onChange(tabs[index - 1].key);
      }
    }
  };

  return (
    <div className="letu-tabs">
      <StyledTabs
        hideAdd
        type="editable-card"
        onChange={onChange}
        activeKey={activeKey}
        onEdit={(e, action) => onEdit(e as string, action)}
        items={tabs}
      />
    </div>
  );
};
export default Tab;
