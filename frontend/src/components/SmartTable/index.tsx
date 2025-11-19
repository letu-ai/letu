import { Button, Card, Checkbox, Dropdown, Form, type MenuProps, Table, type TablePaginationConfig, Tooltip } from 'antd';
import React, { type ForwardedRef, forwardRef, useEffect, useImperativeHandle, useMemo, useState, useRef, useCallback } from 'react';
import type { SmartTableProps, SmartTableRef } from './type';
import useDeepCompareEffect from 'use-deep-compare-effect';
import { ColumnHeightOutlined, ReloadOutlined, TableOutlined } from '@ant-design/icons';
import type { TableProps } from 'antd';
import useLayoutStore, { isSizeType } from '@/application/layoutStore';
import { Undo2 } from 'lucide-react';
import { useNavigate, useLocation } from '@tanstack/react-router';

type TableRowSelection<T extends object = object> = TableProps<T>['rowSelection'];
const defaultPagination: TablePaginationConfig =
{
    current: 1,
    pageSize: 10,
    total: 0,
    showSizeChanger: true,
    showQuickJumper: true,
    pageSizeOptions: [10, 20, 50, 100].map(String),
    showTotal: (total: number) => `共 ${total} 条`,
}

const columnWidthItems: MenuProps['items'] = [
    {
        key: 'large',
        label: '宽松',
    },
    {
        key: 'middle',
        label: '中等',
    },
    {
        key: 'small',
        label: '紧凑',
    },
];

// 默认分页参数
const DEFAULT_PAGE = 1;
const DEFAULT_PAGE_SIZE = 10;

// 序列化参数：将 queryParams 转换为 URL 参数（排除默认值）
const serializeParams = (params: Record<string, any>): Record<string, string> => {
    const urlParams: Record<string, string> = {};
    
    Object.keys(params).forEach(key => {
        const value = params[key];
        
        // 跳过空值
        if (value === undefined || value === null || value === '') {
            return;
        }
        
        // 处理分页参数：默认值不写入
        if (key === 'current') {
            if (value === DEFAULT_PAGE) {
                return;
            }
            // 确保数字类型正确转换为字符串（不带引号）
            urlParams[key] = String(Number(value));
            return;
        }
        if (key === 'pageSize') {
            if (value === DEFAULT_PAGE_SIZE) {
                return;
            }
            // 确保数字类型正确转换为字符串（不带引号）
            urlParams[key] = String(Number(value));
            return;
        }
        
        // 处理数组类型（如筛选器的多选值）
        if (Array.isArray(value)) {
            if (value.length > 0) {
                urlParams[key] = value.join(',');
            }
            return;
        }
        
        // 处理排序参数
        if (key === 'field' || key === 'order') {
            // 排序参数转换为 sortField 和 sortOrder
            if (key === 'field') {
                urlParams['sortField'] = String(value);
            } else if (key === 'order') {
                urlParams['sortOrder'] = String(value);
            }
            return;
        }
        
        // 其他参数直接转换
        urlParams[key] = String(value);
    });
    
    return urlParams;
};

// 反序列化参数：从 URL 参数恢复 queryParams
const deserializeParams = (searchParams: URLSearchParams): Record<string, any> => {
    const params: Record<string, any> = {};
    
    // 处理分页参数
    const current = searchParams.get('current');
    if (current) {
        const page = parseInt(current, 10);
        if (!isNaN(page) && page > 0) {
            params.current = page;
        }
    }
    
    const pageSize = searchParams.get('pageSize');
    if (pageSize) {
        const size = parseInt(pageSize, 10);
        if (!isNaN(size) && size > 0) {
            params.pageSize = size;
        }
    }
    
    // 处理排序参数
    const sortField = searchParams.get('sortField');
    const sortOrder = searchParams.get('sortOrder');
    if (sortField) {
        params.field = sortField;
    }
    if (sortOrder) {
        params.order = sortOrder;
    }
    
    // 处理其他参数（排除已处理的参数）
    const excludeKeys = ['current', 'pageSize', 'sortField', 'sortOrder'];
    searchParams.forEach((value, key) => {
        if (!excludeKeys.includes(key)) {
            // 检查是否是数组（包含逗号）
            if (value.includes(',')) {
                params[key] = value.split(',').filter(v => v);
            } else {
                params[key] = value;
            }
        }
    });
    
    return params;
};

const SmartTable = forwardRef<SmartTableRef, SmartTableProps<any>>(
    <T extends object = any>(props: SmartTableProps<T>, ref: ForwardedRef<SmartTableRef>) => {
        const {
            columns,
            selection = false,
            params,
            extraContent,
            pagination: paginationProps,
            dataSource: dataSourceProps,
            syncUrl = true, // 默认启用 URL 同步
            ...restProps
        } = props;
        const [form] = Form.useForm();
        const navigate = useNavigate();
        const location = useLocation();
        const [loading, setLoading] = useState(false);
        const isInitializedRef = useRef(false);
        const previousPathnameRef = useRef<string>(location.pathname);
        const isResettingRef = useRef(false); // 标记是否正在重置路径
        
        // 从 URL 读取初始参数
        const getInitialParams = () => {
            if (!syncUrl) {
                return { current: DEFAULT_PAGE, pageSize: DEFAULT_PAGE_SIZE };
            }
            
            // 如果正在重置路径，直接返回默认值
            if (isResettingRef.current) {
                return { current: DEFAULT_PAGE, pageSize: DEFAULT_PAGE_SIZE };
            }
            
            const searchParams = new URLSearchParams(location.search);
            const urlParams = deserializeParams(searchParams);
            
            return {
                current: urlParams.current ?? DEFAULT_PAGE,
                pageSize: urlParams.pageSize ?? DEFAULT_PAGE_SIZE,
                ...Object.fromEntries(
                    Object.entries(urlParams).filter(([key]) => 
                        key !== 'current' && key !== 'pageSize' && key !== 'field' && key !== 'order'
                    )
                ),
                ...(urlParams.field && { field: urlParams.field }),
                ...(urlParams.order && { order: urlParams.order }),
            };
        };
        
        const [queryParams, setQueryParams] = useState(getInitialParams);
        const [total, setTotal] = useState<number>(0);
        const [dataSource, setDataSource] = useState<readonly T[]>(dataSourceProps ?? []);
        const size = useLayoutStore(state => state.size);
        const [tableSize, setTableSize] = useState(props.size);
        const [selectedRowKeys, setSelectedRowKeys] = useState<React.Key[]>([]);
        const [columnVisibility, setColumnVisibility] = useState<Record<string, boolean>>({});

        // 更新 URL 参数
        const updateUrlParams = useCallback((newParams: Record<string, any>) => {
            if (!syncUrl || !isInitializedRef.current) {
                return;
            }
            
            const urlParams = serializeParams(newParams);
            const currentSearch = new URLSearchParams(location.search);
            
            // 标准表格参数键
            const standardTableKeys = ['current', 'pageSize', 'sortField', 'sortOrder'];
            
            // 获取所有新参数中的键（包括查询表单字段）
            const newParamKeys = new Set(Object.keys(newParams));
            
            // 从当前 URL 中获取所有可能的表格相关参数键
            // 包括：标准表格参数 + 当前 URL 中存在的非标准参数（可能是查询表单字段）
            const allTableParamKeys = new Set(standardTableKeys);
            currentSearch.forEach((_, key) => {
                // 如果当前 URL 中的参数不在标准列表中，且不在新参数中，可能是需要清除的查询表单字段
                if (!standardTableKeys.includes(key)) {
                    allTableParamKeys.add(key);
                }
            });
            
            // 移除不再存在的表格参数
            // 对于标准表格参数，如果不在 urlParams 中（说明是默认值被过滤掉了），应该删除
            // 对于非标准参数（查询表单字段），如果不在 urlParams 中且不在 newParams 中，则删除
            allTableParamKeys.forEach(key => {
                if (standardTableKeys.includes(key)) {
                    // 标准表格参数：如果不在 urlParams 中，说明是默认值，应该删除
                    if (!urlParams[key]) {
                        currentSearch.delete(key);
                    }
                } else {
                    // 非标准参数（查询表单字段）：如果不在 urlParams 中且不在 newParams 中，则删除
                    if (!urlParams[key] && !newParamKeys.has(key)) {
                        currentSearch.delete(key);
                    }
                }
            });
            
            // 添加或更新新参数
            Object.entries(urlParams).forEach(([key, value]) => {
                currentSearch.set(key, value);
            });
            
            // 构建新的 search 对象
            const newSearchObj: Record<string, string> = {};
            currentSearch.forEach((value, key) => {
                newSearchObj[key] = value;
            });
            
            // 使用 navigate 更新 URL
            navigate({ 
                to: location.pathname,
                search: newSearchObj,
                replace: true, // 使用 replace 避免历史记录堆积
            });
        }, [syncUrl, location.pathname, location.search, navigate]);

        useImperativeHandle(ref, () => ({
            reload: async () => await fetchData(),
            getSelectedKeys: () => selectedRowKeys,
            setQueryFormFieldValue: (field, value) => {
                form.setFieldValue(field, value);
            },
        }));

        // 监听路径变化，当路径变化时重置查询参数和表单
        useEffect(() => {
            const currentPathname = location.pathname;
            const previousPathname = previousPathnameRef.current;
            
            // 如果路径发生变化
            if (currentPathname !== previousPathname) {
                // 标记正在重置，阻止 updateUrlParams 执行
                isResettingRef.current = true;
                
                // 先清除 URL 中的查询参数（如果 syncUrl 启用）
                if (syncUrl) {
                    navigate({
                        to: currentPathname,
                        search: {},
                        replace: true,
                    });
                }
                
                // 重置查询参数为默认值
                const defaultParams = {
                    current: DEFAULT_PAGE,
                    pageSize: DEFAULT_PAGE_SIZE,
                };
                setQueryParams(defaultParams);
                
                // 重置表单字段
                form.resetFields();
                
                // 重置初始化标志，以便重新初始化
                isInitializedRef.current = false;
                
                // 更新记录的路径
                previousPathnameRef.current = currentPathname;
                
                // 延迟取消重置标志，确保 URL 清除完成后再允许 updateUrlParams
                setTimeout(() => {
                    isResettingRef.current = false;
                }, 100);
            }
        }, [location.pathname, syncUrl, form, navigate]);

        // 初始化：从 URL 恢复表单字段
        useEffect(() => {
            if (!isInitializedRef.current) {
                if (syncUrl) {
                    const searchParams = new URLSearchParams(location.search);
                    const urlParams = deserializeParams(searchParams);
                    
                    // 提取查询表单字段（排除分页和排序参数）
                    const formFields: Record<string, any> = {};
                    Object.keys(urlParams).forEach(key => {
                        if (!['current', 'pageSize', 'field', 'order'].includes(key)) {
                            formFields[key] = urlParams[key];
                        }
                    });
                    
                    // 回填表单
                    if (Object.keys(formFields).length > 0) {
                        form.setFieldsValue(formFields);
                    }
                }
                // 无论是否启用 syncUrl，都标记为已初始化
                isInitializedRef.current = true;
            }
        }, [syncUrl, location.search, form]);

        useEffect(() => {
            setDataSource(dataSourceProps ?? []);
        }, [dataSourceProps]);

        useEffect(() => {
            setTableSize(size);
        }, [size]);

        // 初始化列显示状态
        useEffect(() => {
            const visibility: Record<string, boolean> = {};
            columns.forEach(col => {
                const key = (col.key || col.dataIndex) as string;
                if (key) {
                    // 如果列有defaultHidden属性，则默认隐藏，否则默认显示
                    visibility[key] = !col.defaultHidden;
                }
            });
            setColumnVisibility(visibility);
        }, [columns]);

        const pagination = useMemo(() => {
            if (paginationProps === false)
                return false;

            return {
                ...defaultPagination,
                total: total,
                current: queryParams.current,
                pageSize: queryParams.pageSize,
            };
        }, [paginationProps, total, queryParams]);

        // 处理columns，根据columnVisibility设置hidden属性
        const processedColumns = useMemo(() => {
            return columns.map(col => {
                const key = (col.key || col.dataIndex) as string;
                return {
                    ...col,
                    hidden: key ? columnVisibility[key] === false : false
                };
            });
        }, [columns, columnVisibility]);

        const fetchData = async () => {
            if (props.request) {
                setLoading(true);
                try {
                    const result = await props.request({ ...queryParams, ...params });
                    //判断当前页是否有数据，无数据设置第1页
                    if (result.items === null || result.items.length === 0) {
                        if (result.totalCount > 0) {
                            setQueryParams({
                                ...queryParams,
                                current: 1,
                            });
                        }
                    }
                    setTotal(result.totalCount);
                    setDataSource(result.items);
                } finally {
                    setLoading(false);
                }
            }
        };

        useDeepCompareEffect(() => {
            fetchData();
        }, [queryParams, params]);

        // 监听 queryParams 变化，同步到 URL（排除初始化阶段和重置阶段）
        useEffect(() => {
            if (syncUrl && isInitializedRef.current && !isResettingRef.current) {
                updateUrlParams(queryParams);
            }
        }, [queryParams, syncUrl, updateUrlParams]);

        const columnWidthItemClick = ({ key }: { key: string }) => {
            if (isSizeType(key))
                setTableSize(key);
        };

        const handleTableChange = (
            pagination: TablePaginationConfig,
            filters?: Record<string, any>,
            sorter?: any
        ) => {
            setQueryParams((prev: Record<string, any>) => ({
                ...prev,
                ...filters,
                ...sorter,
                current: pagination.current ?? 1,
                pageSize: pagination.pageSize ?? 10,
            }));
        };

        const onSearch = () => {
            const formValues = form.getFieldsValue();
            setQueryParams((prev: Record<string, any>) => ({ ...prev, ...formValues, current: 1 })); // 查询时重置到第一页
        };
        
        const onReset = () => {
            form.resetFields();
            // 重置时清除所有查询参数，只保留分页大小
            const resetParams: Record<string, any> = { 
                current: DEFAULT_PAGE, 
                pageSize: queryParams.pageSize 
            };
            setQueryParams(resetParams);
        };
        const onSelectChange = (newSelectedRowKeys: React.Key[]) => {
            setSelectedRowKeys(newSelectedRowKeys);
        };
        const rowSelection: TableRowSelection<T> = {
            selectedRowKeys,
            onChange: onSelectChange,
        };

        return (
            <div className="letu-table-wrapper">
                {props.searchItems && (
                    <Card className="mb-1">
                        <div className="flex justify-between">
                            <Form form={form} className='flex-1'
                            >
                                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-x-4">
                                    {Array.isArray(props.searchItems)
                                        ? React.Children.map(props.searchItems, (child, index) => {
                                            if (React.isValidElement(child)) {
                                                return React.cloneElement(child, {
                                                    key: child.key || `child-${index}`,
                                                });
                                            }
                                            return child;
                                        })
                                        : props.searchItems}
                                </div>
                            </Form>
                            <div className="flex gap-2 pl-4">
                                <Button type="primary" onClick={onSearch}>
                                    查询
                                </Button>
                                <Button type="text" onClick={onReset}><Undo2 color="gray" /></Button>
                            </div>
                        </div>
                    </Card>
                )}



                <Card>
                    {/* 额外内容区域 - 在搜索面板和表格之间 */}
                    {extraContent}

                    {/* 新增/编辑等操作栏 */}
                    <div className="flex justify-between">
                        <div className="custom-toolbar mb-2">
                            {Array.isArray(props.toolbar)
                                ? React.Children.map(props.toolbar, (child, index) => {
                                    if (React.isValidElement(child)) {
                                        return React.cloneElement(child, {
                                            key: child.key || `child-${index}`,
                                        });
                                    }
                                    return child;
                                })
                                : props.toolbar}
                        </div>
                        <div className={'right-operation-toolbar ' + (props.toolbar ? 'mt-1' : 'mb-1')}>
                            <Tooltip title="刷新">
                                <Button color="default" variant="link" icon={<ReloadOutlined />} onClick={fetchData}></Button>
                            </Tooltip>
                            <Tooltip title="列宽">
                                <Dropdown
                                    menu={{
                                        items: columnWidthItems,
                                        onClick: columnWidthItemClick,
                                        activeKey: tableSize,
                                    }}
                                    trigger={['click']}
                                >
                                    <Button color="default" variant="link" icon={<ColumnHeightOutlined />}></Button>
                                </Dropdown>
                            </Tooltip>
                            <Tooltip title="列设置">
                                <Dropdown
                                    trigger={['click']}
                                    popupRender={() => (
                                        <div
                                            className="rounded-md border-primary-border p-2 max-h-400 min-w-40 overflow-y-auto bg-white shadow-md"
                                        >
                                            {columns
                                                .filter(col => col.hideable !== false)
                                                .map((col, index) => {
                                                    const key = (col.key || col.dataIndex) as string;
                                                    if (!key) return null;

                                                    const title = typeof col.title === 'string'
                                                        ? col.title
                                                        : `列 ${index + 1}`;

                                                    return (
                                                        <div key={key} style={{ padding: '4px 12px' }}>
                                                            <Checkbox
                                                                checked={columnVisibility[key] !== false}
                                                                onChange={(e) => {
                                                                    setColumnVisibility(prev => ({
                                                                        ...prev,
                                                                        [key]: e.target.checked
                                                                    }));
                                                                }}
                                                            >
                                                                {title}
                                                            </Checkbox>
                                                        </div>
                                                    );
                                                })}
                                        </div>
                                    )}
                                >
                                    <Button color="default" variant="link" icon={<TableOutlined />}></Button>
                                </Dropdown>
                            </Tooltip>
                        </div>
                    </div>
                    <Table
                        {...restProps}
                        dataSource={dataSource}
                        columns={processedColumns}
                        rowKey={props.rowKey ?? 'id'}
                        size={tableSize}
                        pagination={pagination}
                        onChange={handleTableChange}
                        loading={loading}
                        rowSelection={selection ? rowSelection : undefined}
                    />
                </Card>
            </div>
        );
    },
);

export default SmartTable;
