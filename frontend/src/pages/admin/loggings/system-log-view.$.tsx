import { getLogFileContent, type LogFileContentDto } from './-service';
import { Button, Input, Spin, App } from 'antd';
import { useEffect, useState, useRef, useCallback } from 'react';
import { createFileRoute, useNavigate } from '@tanstack/react-router';
import { ArrowLeftOutlined, SearchOutlined } from '@ant-design/icons';

export const Route = createFileRoute('/admin/loggings/system-log-view/$')({
    component: SystemViewerPage,
});

function SystemViewerPage() {
    const { _splat: filePath } = Route.useParams();
    const navigate = useNavigate();
    const { message } = App.useApp();
    const [loading, setLoading] = useState(false);
    const [lines, setLines] = useState<string[]>([]);
    const [totalLines, setTotalLines] = useState(0);
    const [skip, setSkip] = useState(0);
    const [hasMore, setHasMore] = useState(true);
    const [searchText, setSearchText] = useState('');
    const [highlightIndex, setHighlightIndex] = useState(-1);
    const containerRef = useRef<HTMLDivElement>(null);
    const observerRef = useRef<IntersectionObserver | null>(null);
    const loadingRef = useRef<HTMLDivElement>(null);
    const take = 100; // 每次加载的行数

    // 加载日志内容
    const loadLogContent = useCallback(async (currentSkip: number, append: boolean = false) => {
        if (!filePath) return;

        setLoading(true);
        try {
            const data: LogFileContentDto = await getLogFileContent(filePath, currentSkip, take);

            if (append) {
                setLines((prev) => [...prev, ...data.lines]);
            } else {
                setLines(data.lines);
            }

            setTotalLines(data.totalLines);
            setHasMore(data.hasMore);
            setSkip(currentSkip + data.lines.length);
        } catch {
            message.error('加载日志内容失败');
        } finally {
            setLoading(false);
        }
    }, [filePath]);

    // 初始加载
    useEffect(() => {
        if (filePath) {
            setSkip(0);
            setLines([]);
            loadLogContent(0, false);
        }
    }, [filePath, loadLogContent]);

    // 瀑布流加载：监听滚动到底部
    useEffect(() => {
        if (!hasMore || loading) return;

        observerRef.current = new IntersectionObserver(
            (entries) => {
                if (entries[0].isIntersecting && hasMore && !loading) {
                    loadLogContent(skip, true);
                }
            },
            { threshold: 0.1 }
        );

        if (loadingRef.current) {
            observerRef.current.observe(loadingRef.current);
        }

        return () => {
            if (observerRef.current) {
                observerRef.current.disconnect();
            }
        };
    }, [hasMore, loading, skip, loadLogContent]);

    // 搜索功能
    const handleSearch = () => {
        if (!searchText.trim()) {
            setHighlightIndex(-1);
            return;
        }

        const index = lines.findIndex((line) =>
            line.toLowerCase().includes(searchText.toLowerCase())
        );

        if (index >= 0) {
            setHighlightIndex(index);
            // 滚动到高亮行
            const element = document.getElementById(`log-line-${index}`);
            if (element) {
                element.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        } else {
            message.warning('未找到匹配的内容');
        }
    };

    // 高亮搜索文本
    const highlightText = (text: string, search: string) => {
        if (!search.trim()) return text;

        const regex = new RegExp(`(${search})`, `gi`);
        const parts = text.split(regex);

        return parts.map((part, index) =>
            regex.test(part) ? (
                <mark key={index} className="bg-yellow-300">
                    {part}
                </mark>
            ) : (
                part
            )
        );
    };

    if (!filePath) {
        return (
            <div className="p-4">
                <Button type="primary" icon={<ArrowLeftOutlined />} onClick={() => navigate({ to: '/admin/loggings/system' })}>
                    返回列表
                </Button>
                <div className="mt-4 text-center text-gray-500">未指定日志文件</div>
            </div>
        );
    }

    return (
        <div className="h-full flex flex-col">
            {/* 头部工具栏 */}
            <div className="p-4 border-b bg-white flex items-center justify-between">
                <div className="flex items-center gap-4">
                    <Button type="primary" icon={<ArrowLeftOutlined />} onClick={() => navigate({ to: '/admin/loggings/system' })}>
                        返回列表
                    </Button>
                    <div className="text-sm text-gray-600">
                        文件: <span className="font-mono">{filePath}</span>
                    </div>
                    <div className="text-sm text-gray-600">
                        总行数: {totalLines.toLocaleString()}
                    </div>
                </div>
                <div className="flex items-center gap-2">
                    <Input
                        placeholder="搜索日志内容"
                        value={searchText}
                        onChange={(e) => setSearchText(e.target.value)}
                        onPressEnter={handleSearch}
                        style={{ width: 300 }}
                        suffix={
                            <Button
                                type="text"
                                icon={<SearchOutlined />}
                                onClick={handleSearch}
                                size="small"
                            />
                        }
                    />
                </div>
            </div>

            {/* 日志内容区域 */}
            <div
                ref={containerRef}
                className="flex-1 overflow-auto p-4 bg-gray-50"
                style={{ fontFamily: 'monospace', fontSize: '13px' }}
            >
                <div className="bg-white rounded shadow-sm p-4">
                    {lines.map((line, index) => (
                        <div
                            key={index}
                            id={`log-line-${index}`}
                            className={`py-1 px-2 hover:bg-gray-50 ${index === highlightIndex ? 'bg-yellow-100' : ''
                                } ${index % 2 === 0 ? 'bg-gray-50' : ''}`}
                        >
                            <span className="text-gray-500 mr-4 select-none" style={{ width: "60px", display: "inline-block" }}>
                                {index + 1}
                            </span>
                            <span className="text-gray-800">{highlightText(line, searchText)}</span>
                        </div>
                    ))}

                    {/* 加载指示器 */}
                    {hasMore && (
                        <div ref={loadingRef} className="text-center py-4">
                            <Spin size="small" />
                            <span className="ml-2 text-gray-500">加载中...</span>
                        </div>
                    )}

                    {!hasMore && lines.length > 0 && (
                        <div className="text-center py-4 text-gray-500">
                            已加载全部内容
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}
