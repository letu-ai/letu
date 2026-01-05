'use client';

import { useState, useEffect } from 'react';
import { DirectoryTree } from './-DirectoryTree';
import { FileList } from './-FileList';
import { Folder } from 'lucide-react';
import type { IDirectory } from './-service';
import { getDirectories } from './-service';
import { createFileRoute } from '@tanstack/react-router';
import { toast } from 'sonner';
import { getErrorInfo } from '@/utils/httpClient';

export const Route = createFileRoute('/ai/file-manager/')({
    component: FileManagerPage,
});


function FileManagerPage() {
    const [directories, setDirectories] = useState<IDirectory[]>([]);
    const [selectedDirectoryId, setSelectedDirectoryId] = useState<string | null>(null);
    const [loading, setLoading] = useState(true);

    // 加载目录树
    const loadDirectories = async () => {
        setLoading(true);
        try {
            const data = await getDirectories({ showGlobalErrorMessage: false });
            setDirectories(data);
        } catch (error: any) {
            const { message } = await getErrorInfo(error);
            toast.error('加载目录树失败', { duration: 5000, description: message });
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        loadDirectories();
    }, []);

    const handleDirectoryCreated = () => {
        loadDirectories();
    };

    const handleDirectoryDeleted = () => {
        loadDirectories();
        // 如果删除的是当前选中的目录，清空选择
        setSelectedDirectoryId(null);
    };

    const handleDirectoryRenamed = () => {
        loadDirectories();
    };

    return (
        <div className="flex flex-1 flex-col min-h-full">
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 w-full">
                <div className="mb-6">
                    <div className="flex items-center gap-3 mb-3">
                        <div className="p-2 rounded-lg bg-primary shadow-sm">
                            <Folder className="w-5 h-5 text-white" />
                        </div>
                        <div>
                            <h1 className="text-2xl font-bold text-foreground">
                                文件管理
                            </h1>
                            <p className="text-sm text-muted-foreground mt-1">
                                管理您的图片、Excel、Word和PDF文件，支持按目录组织
                            </p>
                        </div>
                    </div>
                </div>

                <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
                    {/* 左侧 - 目录树 */}
                    <div className="lg:col-span-1">
                        <div className="bg-card border border-border rounded-xl p-5 shadow-sm">
                            <h2 className="text-sm font-semibold text-card-foreground mb-4 px-1 uppercase tracking-wider">
                                目录
                            </h2>
                            {loading ? (
                                <div className="text-sm text-muted-foreground flex items-center gap-2">
                                    <div className="w-4 h-4 border-2 border-primary border-t-transparent rounded-full animate-spin"></div>
                                    加载中...
                                </div>
                            ) : (
                                <DirectoryTree
                                    directories={directories}
                                    selectedDirectoryId={selectedDirectoryId}
                                    onSelectDirectory={setSelectedDirectoryId}
                                    onDirectoryCreated={handleDirectoryCreated}
                                    onDirectoryDeleted={handleDirectoryDeleted}
                                    onDirectoryRenamed={handleDirectoryRenamed}
                                />
                            )}
                        </div>
                    </div>

                    {/* 右侧 - 文件列表 */}
                    <div className="lg:col-span-3">
                        <FileList
                            directoryId={selectedDirectoryId}
                            onFilesChanged={() => {
                                // 文件变化时不需要重新加载目录树
                            }}
                        />
                    </div>
                </div>
            </div>
        </div>
    );
}

