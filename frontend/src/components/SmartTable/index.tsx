import { Button, Card, Checkbox, Dropdown, Form, type MenuProps, Space, Table, type TablePaginationConfig, Tooltip } from 'antd';
import React, { type ForwardedRef, forwardRef, useEffect, useImperativeHandle, useMemo, useState } from 'react';
import type { SmartTableProps, SmartTableRef } from './type';
import useDeepCompareEffect from 'use-deep-compare-effect';
import { ColumnHeightOutlined, ReloadOutlined, SettingOutlined, TableOutlined } from '@ant-design/icons';
import type { TableProps } from 'antd';
import useLayoutStore, { isSizeType } from '@/application/layoutStore';

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

const SmartTable = forwardRef<SmartTableRef, SmartTableProps<any>>(
    <T extends object = any>(props: SmartTableProps<T>, ref: ForwardedRef<SmartTableRef>) => {
        const {
            columns,
            selection = false,
            params,
            extraContent,
            pagination: paginationProps,
            dataSource: dataSourceProps,
            ...restProps
        } = props;
        const [form] = Form.useForm();
        const [loading, setLoading] = useState(false);
        const [queryParams, setQueryParams] = useState({
            current: 1,
            pageSize: 10,
        });
        const [total, setTotal] = useState<number>(0);
        const [dataSource, setDataSource] = useState<readonly T[]>(dataSourceProps ?? []);
        const size = useLayoutStore(state => state.size);
        const [tableSize, setTableSize] = useState(props.size);
        const [selectedRowKeys, setSelectedRowKeys] = useState<React.Key[]>([]);
        const [columnVisibility, setColumnVisibility] = useState<Record<string, boolean>>({});

        useImperativeHandle(ref, () => ({
            reload: async () => await fetchData(),
            getSelectedKeys: () => selectedRowKeys,
            setQueryFormFieldValue: (field, value) => {
                form.setFieldValue(field, value);
            },
        }));

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
        }, [paginationProps]);

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
                setLoading(false);
            }
        };

        useDeepCompareEffect(() => {
            fetchData();
        }, [queryParams, params]);

        const columnWidthItemClick = ({ key }: { key: string }) => {
            if (isSizeType(key))
                setTableSize(key);
        };

        const handleTableChange = (pagination: TablePaginationConfig) => {
            setQueryParams({
                ...queryParams,
                current: pagination.current ?? 1,
                pageSize: pagination.pageSize ?? 10,
            });
        };

        const onSearch = () => {
            setQueryParams({ ...queryParams, ...form.getFieldsValue() });
        };
        const onReset = () => {
            form.resetFields();
            onSearch();
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
                        <Form layout="inline" form={form} initialValues={{ layout: 'inline' }} style={{ maxWidth: 'none' }}>
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
                            <Form.Item>
                                <Space>
                                    <Button type="primary" onClick={onSearch}>
                                        查询
                                    </Button>
                                    <Button onClick={onReset}>重置</Button>
                                </Space>
                            </Form.Item>
                        </Form>
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
