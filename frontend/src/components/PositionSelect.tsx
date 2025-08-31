import { TreeSelect } from 'antd';
import { ReloadOutlined } from '@ant-design/icons';
import { useQuery } from '@tanstack/react-query';
import { getPositionOptions } from '@/pages/admin/positions/-service';
import React from 'react';

interface PositionSelectProps {
  value?: string | null;
  onChange?: (value: string | null) => void;
  placeholder?: string;
  disabled?: boolean;
  allowClear?: boolean;
  style?: React.CSSProperties;
  initialLabel?: string | null;
}

const PositionSelect: React.FC<PositionSelectProps> = ({
  value,
  onChange,
  placeholder = "请选择职位",
  initialLabel,
  ...props
}) => {
  const { data, isLoading, refetch, isFetched } = useQuery({
    queryKey: ['positions'],
    queryFn: getPositionOptions,
    staleTime: 60 * 60 * 1000,  // 1小时缓存
    gcTime: 2 * 60 * 60 * 1000,
  });

  // 处理初始值显示
  const treeData = data || [];
  const hasData = treeData.length > 0;
  
  // 为编辑模式提供初始显示数据
  const displayTreeData = hasData ? treeData : 
    (value && initialLabel ? [{ key: value, value, title: initialLabel }] : []);

  const showRefresh = isFetched && !isLoading;

  return (
    <TreeSelect
      value={value}
      onChange={onChange}
      placeholder={placeholder}
      loading={isLoading}
      treeData={displayTreeData}
      showSearch
      allowClear
      treeDefaultExpandAll
      treeNodeFilterProp="title"
      popupRender={(menu) => (
        <div className="relative">
          {menu}
          {showRefresh && (
            <button
              onClick={(e) => {
                e.stopPropagation();
                refetch();
              }}
              className="absolute top-0 right-0  w-6 h-6 bg-white/80 hover:bg-gray-100 rounded-full shadow-sm transition-colors"
              title="刷新职位"
            >
              <ReloadOutlined className="text-xs text-gray-600" />
            </button>
          )}
        </div>
      )}
      {...props}
    />
  );
};

export default PositionSelect;