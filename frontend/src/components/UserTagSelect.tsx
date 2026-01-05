import { Select, Tag } from 'antd';
import { ReloadOutlined } from '@ant-design/icons';
import { useQuery } from '@tanstack/react-query';
import { getUserTagOptions } from '@/pages/admin/users/-service';
import React from 'react';

interface UserTagSelectProps {
  value?: string[] | null;
  onChange?: (value: string[] | null) => void;
  placeholder?: string;
  disabled?: boolean;
  allowClear?: boolean;
  style?: React.CSSProperties;
}

const UserTagSelect: React.FC<UserTagSelectProps> = ({
  value,
  onChange,
  placeholder = "请选择标签",
  ...props
}) => {
  const { data, isLoading, refetch, isFetched } = useQuery({
    queryKey: ['userTagOptions'],
    queryFn: getUserTagOptions,
    staleTime: 60 * 60 * 1000,  // 1小时缓存
    gcTime: 2 * 60 * 60 * 1000,
  });

  // 只在有缓存时显示刷新按钮
  const showRefresh = isFetched && !isLoading;

  const options = data || [];

  return (
    <Select
      mode="multiple"
      value={value}
      onChange={onChange}
      placeholder={placeholder}
      loading={isLoading}
      options={options}
      showSearch
      allowClear
      filterOption={(input, option) =>
        (option?.label ?? '').toLowerCase().includes(input.toLowerCase())
      }
      tagRender={({ label, value: tagValue, closable, onClose }) => {
        // 找到对应的标签数据以获取颜色
        const tagData = options.find(opt => opt.value === tagValue);
        return (
          <Tag
            color={tagData?.color || 'default'}
            closable={closable}
            onClose={onClose}
            style={{ marginRight: 3 }}
          >
            {label}
          </Tag>
        );
      }}
      popupRender={(menu) => (
        <div className="relative">
          {menu}
          {showRefresh && (
            <button
              onClick={(e) => {
                e.stopPropagation();
                refetch();
              }}
              className="absolute top-0 right-0 w-6 h-6 bg-white/80 hover:bg-gray-100 rounded-full shadow-sm transition-colors"
              title="刷新标签"
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

export default UserTagSelect;