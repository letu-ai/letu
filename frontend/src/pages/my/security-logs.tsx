import { useState, useEffect, useRef, useCallback } from 'react';
import { Card, Row, Col, Statistic, Tag, DatePicker, Select, Form, App } from 'antd';
import { HistoryOutlined, EnvironmentOutlined, LaptopOutlined, SafetyOutlined } from '@ant-design/icons';
import { createFileRoute } from '@tanstack/react-router';
import SmartTable from '@/components/SmartTable';
import type { SmartTableRef, SmartTableColumnType } from '@/components/SmartTable/type';
import {
    getSecurityLogs,
    getSecurityLogStats,
    type ISecurityLogListOutput,
    type ISecurityLogListInput,
    type ISecurityLogStatsOutput
} from './-service';
import { formatTime } from '@/utils/timeUtils';

const { RangePicker } = DatePicker;

export const Route = createFileRoute('/my/security-logs')({
    component: SecurityLogsPage
});

function SecurityLogsPage() {
    const tableRef = useRef<SmartTableRef>(null);
    const { message } = App.useApp();
    const [stats, setStats] = useState<ISecurityLogStatsOutput>({
        todayLoginCount: 0,
        recentLoginIp: '',
        abnormalLoginCount: 0,
        totalLoginCount: 0
    });
    const [loadingStats, setLoadingStats] = useState(true);

    const columns: SmartTableColumnType<ISecurityLogListOutput>[] = [
        {
            title: '登录时间',
            dataIndex: 'creationTime',
            width: 180,
            render: (time: string) => formatTime(time)
        },
        {
            title: 'IP地址',
            dataIndex: 'ip',
            width: 140,
            render: (ip: string) => (
                <span className="font-mono text-blue-600">{ip}</span>
            )
        },
        {
            title: '地理位置',
            dataIndex: 'location',
            width: 150,
            render: (location: string) => (
                <span>
                    <EnvironmentOutlined className="mr-1 text-gray-400" />
                    {location || '未知'}
                </span>
            )
        },
        {
            title: '设备信息',
            dataIndex: 'device',
            width: 120,
            render: (device: string, record: ISecurityLogListOutput) => (
                <div>
                    <div className="flex items-center">
                        <LaptopOutlined className="mr-1 text-gray-400" />
                        <span className="text-sm">{device || '未知设备'}</span>
                    </div>
                    {record.os && (
                        <div className="text-xs text-gray-500 mt-1">{record.os}</div>
                    )}
                </div>
            )
        },
        {
            title: '浏览器',
            dataIndex: 'browser',
            width: 150,
            render: (browser: string) => (
                <span className="text-sm">{browser || '未知'}</span>
            )
        },
        {
            title: '登录状态',
            dataIndex: 'isSuccess',
            width: 100,
            render: (isSuccess: boolean) => (
                <Tag color={isSuccess ? 'success' : 'error'} icon={<SafetyOutlined />}>
                    {isSuccess ? '成功' : '失败'}
                </Tag>
            )
        },
        {
            title: '详细信息',
            dataIndex: 'operationMsg',
            ellipsis: true,
            render: (msg: string) => (
                <span className="text-gray-600">{msg || '-'}</span>
            )
        }
    ];

    const loadStats = useCallback(async () => {
        try {
            setLoadingStats(true);
            const data = await getSecurityLogStats();
            setStats(data);
        } catch {
            message.error('获取统计信息失败');
        } finally {
            setLoadingStats(false);
        }
    }, [message]);

    useEffect(() => {
        loadStats();
    }, [loadStats]);

    return (
        <div>
            {/* 统计卡片 */}
            <Row gutter={16} className="mb-6">
                <Col xs={24} sm={12} lg={6}>
                    <Card>
                        <Statistic
                            title="今日登录"
                            value={stats.todayLoginCount}
                            prefix={<HistoryOutlined />}
                            loading={loadingStats}
                        />
                    </Card>
                </Col>
                <Col xs={24} sm={12} lg={6}>
                    <Card>
                        <Statistic
                            title="最近登录IP"
                            value={stats.recentLoginIp || '暂无'}
                            prefix={<EnvironmentOutlined />}
                            loading={loadingStats}
                            classNames={{ content: 'text-sm' }}
                        />
                    </Card>
                </Col>
                <Col xs={24} sm={12} lg={6}>
                    <Card>
                        <Statistic
                            classNames={{ content: stats.abnormalLoginCount > 0 ? 'text-red-500' : 'text-green-500' }}
                            title="异常登录"
                            value={stats.abnormalLoginCount}
                            prefix={<SafetyOutlined />}
                            loading={loadingStats}
                        />
                    </Card>
                </Col>
                <Col xs={24} sm={12} lg={6}>
                    <Card>
                        <Statistic
                            title="总登录次数"
                            value={stats.totalLoginCount}
                            prefix={<LaptopOutlined />}
                            loading={loadingStats}
                        />
                    </Card>
                </Col>
            </Row>

            {/* 登录日志表格 */}
            <SmartTable
                ref={tableRef}
                columns={columns}
                rowKey="id"
                size="small"
                request={async (params: ISecurityLogListInput) => {
                    try {
                        const data = await getSecurityLogs(params);
                        return data;
                    } catch {
                        message.error('获取登录日志失败');
                        return { items: [], totalCount: 0 };
                    }
                }}
                searchItems={[
                    <Form.Item key="dateRange" label="登录时间" name="dateRange">
                        <RangePicker
                            placeholder={['开始日期', '结束日期']}
                            onChange={(dates) => {
                                if (dates && dates[0] && dates[1]) {
                                    // 这里需要在实际使用时处理日期范围
                                }
                            }}
                        />
                    </Form.Item>,
                    <Form.Item key="isSuccess" label="登录状态" name="isSuccess">
                        <Select
                            allowClear
                            placeholder="请选择登录状态"
                            style={{ width: 120 }}
                            options={[
                                { label: '成功', value: true },
                                { label: '失败', value: false },
                            ]}
                        />
                    </Form.Item>,
                    <Form.Item key="ip" label="IP地址" name="ip">
                        <Select
                            mode="tags"
                            placeholder="输入IP地址"
                            style={{ width: 200 }}
                            maxTagCount={2}
                        />
                    </Form.Item>
                ]}
                pagination={{
                    showSizeChanger: true,
                    showQuickJumper: true,
                    showTotal: (total, range) =>
                        `第 ${range[0]}-${range[1]} 条，共 ${total} 条记录`
                }}
            />
        </div>
    );
}