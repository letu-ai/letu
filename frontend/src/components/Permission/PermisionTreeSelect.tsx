import React from 'react';
import { TreeSelect } from 'antd';
import { useQuery } from '@tanstack/react-query';
import { fetchFeatureTreeSelectOptions } from './service';


interface IPermissionSelectProps {
    label?: string;
    placeholder?: string;
    value?: string[];
    disabled?: boolean;
    onChange?: (value: string[]) => void;
    style?: React.CSSProperties;
}

const PermissionSelect = ({
    placeholder,
    value,
    disabled,
    onChange,
    style,
}: IPermissionSelectProps) => {
    const { data: treeData } = useQuery({
        queryKey: ['permissions'],
        queryFn: async () => {
            const data = await fetchFeatureTreeSelectOptions();
            return data;
        },
        staleTime: 5 * 1000,
    });

    return (
        <TreeSelect
            style={style}
            placeholder={placeholder}
            treeData={treeData}
            value={value}
            disabled={disabled}
            onChange={onChange}
            allowClear
            showSearch
            multiple
            treeCheckable
            showCheckedStrategy={TreeSelect.SHOW_CHILD}
            treeDefaultExpandAll
            filterTreeNode={(search, node) =>
                node.label?.toString().toLowerCase().includes(search.toLowerCase())
            }
        />
    );
};

export default PermissionSelect;
