import { forwardRef, useEffect, useImperativeHandle, useState } from 'react';
import { Empty, Input, Menu, Modal } from 'antd';
import { SearchOutlined } from '@ant-design/icons';
import { Link } from 'react-router-dom';
import { open } from '@/store/tabStore.ts';
import { useDispatch } from 'react-redux';
import useAppConfigStore from '@/application/appConfigStore';

export interface SearchModalRef {
  openModal: () => void;
}

const SearchModal = forwardRef<SearchModalRef, any>((_, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [searchText, setSearchText] = useState<string>();
  const [filteredData, setFilteredData] = useState<any[]>([]);
  const menu = useAppConfigStore(state => state.menu);

  const dispatch = useDispatch();
  useImperativeHandle(ref, () => ({
    openModal,
  }));

  useEffect(() => {
    if (searchText) {
      const filterData = menu
        .filter((x) => x.path !== null && (x.title.includes(searchText) || x.path?.includes(searchText)))
        .map((m) => {
          return {
            key: m.id,
            label: (
              <Link
                to={m.path!}
                onClick={() => {
                  dispatch(open(m.path));
                  setIsOpenModal(false);
                  setSearchText('');
                }}
              >
                <span>
                  {m.title}&nbsp;{m.path}
                </span>
              </Link>
            ),
          };
        });
      setFilteredData(filterData);
    } else {
      setFilteredData([]);
    }
  }, [searchText, menu]);

  const openModal = () => {
    setIsOpenModal(true);
  };

  const onCancel = () => {
    setIsOpenModal(false);
    setSearchText('');
  };

  return (
    <Modal title="搜索菜单" open={isOpenModal} onCancel={onCancel} footer={null} width="600px">
      <div className="mt-2 mb-2">
        <Input
          placeholder="请输入菜单标题/路径"
          size="large"
          value={searchText}
          onChange={(e) => {
            setSearchText(e.target.value);
          }}
          prefix={<SearchOutlined style={{ color: 'rgba(0,0,0,.25)' }} />}
        />
      </div>
      <div>
        {filteredData.length > 0 ? (
          <Menu mode="inline" style={{ borderRight: 0 }} items={filteredData} />
        ) : (
          <Empty
            image={Empty.PRESENTED_IMAGE_SIMPLE}
            description={searchText ? '未找到匹配的菜单' : '请输入关键词搜索'}
            style={{ padding: '40px 0' }}
          />
        )}
      </div>
    </Modal>
  );
});
export default SearchModal;
