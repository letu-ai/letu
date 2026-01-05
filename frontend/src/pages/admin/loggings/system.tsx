import { getLogFileList, type ILogFileListOutput, type LogFileQueryDto } from './-service';
import { Form, Select, Tag } from 'antd';
import { useRef } from 'react';
import type { SmartTableColumnType, SmartTableRef } from '@/components/SmartTable/type';
import SmartTable from '@/components/SmartTable';
import { createFileRoute, Link } from '@tanstack/react-router';
import { DownloadOutlined, FileZipOutlined } from '@ant-design/icons';
import dayjs from 'dayjs';
import { getApiBaseUrl } from '@/utils/urlUtils';

export const Route = createFileRoute('/admin/loggings/system')({
    component: SystemLogsPage,
});

function SystemLogsPage() {
    const tableRef = useRef<SmartTableRef>(null);
    // 格式化文件大小
    const formatFileSize = (bytes: number): string => {
        if (bytes === 0) return '0 B';
        const k = 1024;
        const sizes = ['B', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return `${(bytes / Math.pow(k, i)).toFixed(2)} ${sizes[i]}`;
    };

    // 获取月份选项
    const getMonthOptions = () => {
        const options = [];
        const now = new Date();
        for (let i = 0; i < 12; i++) {
            const date = new Date(now.getFullYear(), now.getMonth() - i, 1);
            const value = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, `0`)}`;
            const label = `${date.getFullYear()}年${date.getMonth() + 1}月`;
            options.push({ value, label });
        }
        return options;
    };

    const columns: SmartTableColumnType<ILogFileListOutput>[] = [
        {
            title: '创建时间',
            dataIndex: 'creationTime',
            width: 180,
            render: (time: string) => dayjs(time).format('YYYY-MM-DD'),
        },
        {
            title: '文件名',
            dataIndex: 'fileName',
            ellipsis: {
                showTitle: false,
            },
            render: (fileName: string, record: ILogFileListOutput) => (
                <div>
                    <Link 
                        to="/admin/loggings/system-log-view/$" 
                        params={{ _splat: record.filePath }}
                    >
                        <div className="flex items-center gap-2">
                            {record.isCompressed ? (
                                <FileZipOutlined className="text-orange-500" />
                            ) : (
                                <FileZipOutlined className="text-blue-500" />
                            )}
                            <span className="font-mono font-medium">{fileName}</span>
                            {record.isCompressed && (
                                <Tag color="orange">已压缩</Tag>
                            )}
                        </div>
                        <div className="text-xs text-gray-500 mt-1">
                            路径: {record.filePath}
                        </div>
                    </Link>
                </div>
            ),
        },
        {
            title: '文件大小',
            dataIndex: 'fileSize',
            width: 120,
            align: 'right',
            render: (size: number) => formatFileSize(size),
        },
        {
            title: '操作',
            width: 200,
            fixed: 'right',
            render: (_: any, record: ILogFileListOutput) => (
                <a href={`${getApiBaseUrl()}/api/admin/logs/system/download/${record.filePath}`}><DownloadOutlined />下载</a>
            ),
        }
    ];

    return (
        <SmartTable
            ref={tableRef}
            columns={columns}
            rowKey="filePath"
            request={async (params) => {
                const data = await getLogFileList(params as LogFileQueryDto);
                return data;
            }}
            searchItems={
                <>
                    <Form.Item label="月份" name="month">
                        <Select
                            placeholder="请选择月份"
                            options={getMonthOptions()}
                            allowClear
                        />
                    </Form.Item>
                </>
            }
        />
    );
}
