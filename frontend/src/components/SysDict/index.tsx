import { getDictDataOptions } from '@/pages/admin/data-dictionaries/service';
import React from 'react';
import { Select, Radio } from 'antd';
import { useQuery } from '@tanstack/react-query';

interface SysDictProps {
  dictType: string;
  name?: string;
  label?: string;
  placeholder?: string;
  value?: string;
  isPlainText?: boolean;
  disabled?: boolean;
  valueType?: string;
  onChange?: (value: any) => void;
  style?: React.CSSProperties;
}

const SysDict: React.FC<SysDictProps> = ({
  dictType,
  placeholder,
  value,
  isPlainText,
  valueType = 'select',
  disabled,
  onChange,
  style,
}) => {
  const useDict = () => {
    return useQuery({
      queryKey: ['dict', dictType],
      queryFn: async () => {
        const { data } = await getDictDataOptions(dictType);
        return data;
      },
      staleTime: 5 * 1000,
    });
  };

  const getOptions = () => {
    // eslint-disable-next-line react-hooks/rules-of-hooks
    const { data } = useDict();
    return data ?? [];
  };

  if (isPlainText) {
    const displayText = getOptions().find((item) => item.value === value)?.label;
    return <span>{displayText}</span>;
  }
  if (valueType === 'select') {
    return (
      <Select
        style={style}
        placeholder={placeholder}
        options={getOptions()}
        value={value}
        disabled={disabled}
        onChange={onChange}
        allowClear
      />
    );
  } else {
    return <Radio.Group style={style} options={getOptions()} value={value} disabled={disabled} onChange={onChange} />;
  }
};

export default SysDict;
