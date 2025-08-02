import { getDictDataOptions } from '@/pages/admin/data-dictionaries/service';
import React from 'react';
import { Select, Radio } from 'antd';
import { useQuery } from '@tanstack/react-query';

interface IDataDictionarySelectProps {
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

const DataDictionarySelect = ({
    dictType,
    placeholder,
    value,
    isPlainText,
    valueType = 'select',
    disabled,
    onChange,
    style,
}: IDataDictionarySelectProps) => {
    const { data: options } = useQuery({
        queryKey: ['dict', dictType],
        queryFn: async () => {
            const data = await getDictDataOptions(dictType);
            return data;
        },
        staleTime: 5 * 1000,
    });

    if (isPlainText) {
        const displayText = options?.find((item) => item.value === value)?.label;
        return <span>{displayText}</span>;
    }

    if (valueType === 'select') {
        return (
            <Select
                style={style}
                placeholder={placeholder}
                options={options}
                value={value}
                disabled={disabled}
                onChange={onChange}
                allowClear
            />
        );
    } else {
        return <Radio.Group style={style} options={options} value={value} disabled={disabled} onChange={onChange} />;
    }
};

export default DataDictionarySelect;
