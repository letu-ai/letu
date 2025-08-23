import React from 'react';
import { Select } from 'antd';
import { useQuery } from '@tanstack/react-query';
import { fetchFeatureSelectOptions } from './service';


interface IFeatureSelectProps {
    label?: string;
    placeholder?: string;
    value?: string[];
    featureValueType?: 'BOOLEAN' | 'NUMERIC' | 'STRING';
    disabled?: boolean;
    onChange?: (value: string[]) => void;
    style?: React.CSSProperties;
}

const FeatureSelect = ({
    placeholder,
    value,
    featureValueType,
    disabled,
    onChange,
    style,
}: IFeatureSelectProps) => {
    const { data: options } = useQuery({
        queryKey: ['features'],
        queryFn: async () => {
            const data = await fetchFeatureSelectOptions(featureValueType);
            return data;
        },
        staleTime: 5 * 1000,
    });

    return (
        <Select
            style={style}
            placeholder={placeholder}
            options={options}
            value={value}
            disabled={disabled}
            onChange={onChange}
            allowClear
            mode="multiple"
        />
    );
};

export default FeatureSelect;
