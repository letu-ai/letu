import { Select } from 'antd';
import { useState, useMemo } from 'react';
import { useQuery } from '@tanstack/react-query';
import { useDebounce } from 'ahooks';
import { searchEmployeeOptions, getEmployeesByIds } from '@/pages/admin/employees/-service';
import React from 'react';

interface EmployeeSelectProps {
  value?: string | null;
  onChange?: (value: string | null) => void;
  placeholder?: string;
  disabled?: boolean;
  allowClear?: boolean;
  style?: React.CSSProperties;
  initialLabel?: string | null; // 初始显示的员工名称（用于编辑时避免查询后端）
}

const EmployeeSelect: React.FC<EmployeeSelectProps> = ({
  value,
  onChange,
  placeholder = "输入姓名或工号搜索",
  initialLabel,
  ...props
}) => {
  const [searchKeyword, setSearchKeyword] = useState('');
  const debouncedKeyword = useDebounce(searchKeyword, { wait: 300 });

  // 搜索查询
  const { data: searchData, isLoading } = useQuery({
    queryKey: ['employees-search', debouncedKeyword],
    queryFn: () => searchEmployeeOptions(debouncedKeyword),
    enabled: debouncedKeyword.length >= 1,
    staleTime: 5 * 60 * 1000,  // 5分钟缓存
  });
  
  // 回填查询 - 只在有值、未搜索且没有初始标签时查询后端
  const needInitialQuery = !!value && !searchKeyword && !initialLabel;
  const { data: initialData } = useQuery({
    queryKey: ['employee-by-id', value],
    queryFn: () => getEmployeesByIds([value!]),
    enabled: needInitialQuery,
    staleTime: Infinity,  // 永久缓存
  });


  // 合并选项 - 根据搜索状态决定显示内容
  const options = useMemo(() => {
    const map = new Map<string, { label: string; value: string }>();
    
    // 如果有搜索结果，优先显示搜索结果
    if (searchData && searchData.length > 0) {
      searchData.forEach(emp => {
        map.set(emp.value, {
          label: `${emp.label} (${emp.code})`,
          value: emp.value,
        });
      });
    }
    // 如果有初始标签，直接使用（编辑时避免查询后端）
    else if (value && initialLabel) {
      map.set(value, {
        label: initialLabel,
        value: value,
      });
    }
    // 否则显示从后端查询的回填数据
    else if (initialData) {
      initialData.forEach(emp => {
        map.set(emp.value, {
          label: `${emp.label} (${emp.code})`,
          value: emp.value,
        });
      });
    }
    
    return Array.from(map.values());
  }, [initialData, searchData, value, initialLabel]);

  return (
    <Select
      showSearch
      value={value}
      onChange={onChange}
      placeholder={placeholder}
      onSearch={setSearchKeyword}
      filterOption={false}  // 使用服务端搜索
      options={options}
      loading={isLoading}
      allowClear
      notFoundContent={
        searchKeyword.length < 1 
          ? "请输入姓名或工号搜索"
          : isLoading 
          ? "搜索中..." 
          : "未找到匹配的员工"
      }
      {...props}
    />
  );
};

export default EmployeeSelect;