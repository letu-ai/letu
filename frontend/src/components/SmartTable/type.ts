import React from 'react';
import { type TableProps } from 'antd';
import type { PagedResult } from '@/types/api';

export interface SmartTableProps<T> extends Omit<TableProps<T>, 'columns'> {
  columns: SmartTableColumnType[];
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

export interface SmartTableColumnType {
  title?: string | React.ReactNode;
  dataIndex?: string;
  key?: string;
  width?: number | string;
  fixed?: 'left' | 'right' | boolean;
  required?: boolean;

  [key: string]: any;
}
