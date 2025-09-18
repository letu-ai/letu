import React from 'react';
import { type TableColumnsType, type TableProps } from 'antd';
import type { PagedResult } from '@/types/api';

export type SmartTableColumnType<T = any> = TableColumnsType<T>[number] & {
    dataIndex?: string;
    defaultHidden?: boolean;  // 列是否默认隐藏
    hideable?: boolean;       // 列是否可以被隐藏（false表示不可隐藏）
};

export interface SmartTableProps<T> extends Omit<TableProps<T>, 'columns'> {
    columns: SmartTableColumnType<T>[];
    request?: (params: any) => Promise<PagedResult<T>>;
    searchItems?: React.ReactNode | React.ReactNode[];
    toolbar?: React.ReactNode | React.ReactNode[];
    extraContent?: React.ReactNode | React.ReactNode[];
    selection?: boolean;
    params?: Record<string, any>;
}

export interface SmartTableRef {
    reload: () => void;
    getSelectedKeys: () => React.Key[];
    setQueryFormFieldValue: (field: string, value: any) => void;
}
