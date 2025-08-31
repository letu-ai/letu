import { TreeSelect } from 'antd';
import { ReloadOutlined } from '@ant-design/icons';
import { useQuery } from '@tanstack/react-query';
import { getDeptTreeOptions } from '@/pages/admin/departments/-service';
import React from 'react';

interface DepartmentSelectProps {
  value?: string | null;
  onChange?: (value: string | null) => void;
  placeholder?: string;
  disabled?: boolean;
  allowClear?: boolean;
  style?: React.CSSProperties;
  initialLabel?: string | null;  // 编辑时的初始显示
}

const DepartmentSelect: React.FC<DepartmentSelectProps> = ({
  value,
  onChange,
  placeholder = "请选择部门",
  initialLabel,
  ...props
}) => {
  const { data, isLoading, refetch, isFetched } = useQuery({
    queryKey: ['departmentTreeOptions'],
    queryFn: getDeptTreeOptions,
    staleTime: 60 * 60 * 1000,  // 1小时缓存
    gcTime: 2 * 60 * 60 * 1000,
  });

  // 只在有缓存时显示刷新按钮
  const showRefresh = isFetched && !isLoading;

  // 处理初始值显示
  const treeData = data || [];
  const hasData = treeData.length > 0;
  
  // 为编辑模式提供初始显示数据
  const displayTreeData = hasData ? treeData : 
    (value && initialLabel ? [{ key: value, value, title: initialLabel }] : []);

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
              title="刷新部门"
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

export default DepartmentSelect;