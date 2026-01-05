'use client';

import { useState, useEffect, useRef } from 'react';
import { Upload, File, FileSpreadsheet, FileText, Image, Trash2, Download, X, FileText as PdfIcon } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { getFiles, uploadFiles, deleteFile, getFileDownloadUrl, getThumbnailUrl, type IFileItem } from './-service';
import { toast } from 'sonner';
import { getErrorInfo } from '@/utils/httpClient';
import { useConfirm } from '@/components/ConfirmDialog';


interface FileListProps {
    directoryId: string | null;
    onFilesChanged: () => void;
}

export function FileList({ directoryId, onFilesChanged }: FileListProps) {
    const [files, setFiles] = useState<IFileItem[]>([]);
    const [loading, setLoading] = useState(false);
    const [uploading, setUploading] = useState(false);
    const [previewFile, setPreviewFile] = useState<IFileItem | null>(null);
    const [thumbnailErrors, setThumbnailErrors] = useState<Set<string>>(new Set());
    const fileInputRef = useRef<HTMLInputElement>(null);
    const { confirm, confirmDialog } = useConfirm();

    // 加载文件列表
    const loadFiles = async () => {
        setLoading(true);
        try {
            const data = await getFiles(directoryId, { showGlobalErrorMessage: false });
            setFiles(data);
            // 清空缩略图错误状态，重新尝试加载
            setThumbnailErrors(new Set());
        } catch (error: any) {
            const { message } = await getErrorInfo(error);
            toast.error('加载文件列表失败', { duration: 5000, description: message });
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        loadFiles();
    }, [directoryId]);

    // 格式化文件大小
    const formatFileSize = (bytes: number): string => {
        if (bytes === 0) return '0 B';
        const k = 1024;
        const sizes = ['B', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return `${(bytes / Math.pow(k, i)).toFixed(2)} ${sizes[i]}`;
    };

    // 获取文件图标或缩略图
    const getFileIcon = (file: IFileItem) => {
        // 如果是图片类型，显示缩略图
        if (file.type === 'Image') {
            const hasError = thumbnailErrors.has(file.id);
            
            if (hasError) {
                // 如果缩略图加载失败，显示默认图标
                return <Image className="w-10 h-10 text-primary" />;
            }
            
            return (
                <img
                    src={getThumbnailUrl(file.id)}
                    alt={file.originalName}
                    className="w-10 h-10 object-contain rounded border border-border bg-muted"
                    onError={() => {
                        // 如果缩略图加载失败，记录错误并显示默认图标
                        setThumbnailErrors((prev) => new Set(prev).add(file.id));
                    }}
                />
            );
        }
        
        // 其他文件类型显示图标
        switch (file.type) {
            case 'Excel':
                return <FileSpreadsheet className="w-8 h-8 text-green-600" />;
            case 'Word':
                return <FileText className="w-8 h-8 text-primary" />;
            case 'Pdf':
                return <PdfIcon className="w-8 h-8 text-destructive" />;
            default:
                return <File className="w-8 h-8 text-muted-foreground" />;
        }
    };

    // 处理文件上传
    const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
        const selectedFiles = e.target.files;
        if (!selectedFiles || selectedFiles.length === 0) return;

        setUploading(true);
        try {
            await uploadFiles(Array.from(selectedFiles), directoryId, { showGlobalErrorMessage: false });
            toast.success('文件上传成功');
            loadFiles();
            onFilesChanged();
        } catch (error: any) {
            toast.error(error?.message || '文件上传失败');
        } finally {
            setUploading(false);
            // 清空input
            e.target.value = '';
        }
    };

    // 处理文件删除
    const handleDeleteFile = (file: IFileItem) => {
        confirm({
            title: '删除文件',
            description: `确定要删除文件「${file.originalName}」吗？删除后无法恢复。`,
            confirmText: '删除',
            variant: 'destructive',
            action: async () => {
                try {
                    await deleteFile(file.id, { showGlobalErrorMessage: false });
                    toast.success('文件删除成功');
                    loadFiles();
                    onFilesChanged();
                    if (previewFile?.id === file.id) {
                        setPreviewFile(null);
                    }
                } catch (error: any) {
                    toast.error(error?.message || '删除文件失败');
                    throw error; // 重新抛出以阻止对话框关闭
                }
            },
        });
    };

    // 处理文件下载
    const handleDownloadFile = (fileId: string) => {
        window.open(getFileDownloadUrl(fileId), '_blank');
    };

    // 处理文件预览
    const handlePreviewFile = (file: IFileItem) => {
        setPreviewFile(file);
    };

    return (
        <div className="bg-card border border-border rounded-xl p-6 shadow-sm">
            <div className="flex items-center justify-between mb-4">
                <h2 className="text-sm font-semibold text-card-foreground uppercase tracking-wider">
                    {directoryId ? '文件列表' : '根目录文件'}
                </h2>
                <div>
                    <input
                        title="上传文件"
                        ref={fileInputRef}
                        type="file"
                        multiple
                        accept="image/*,.xlsx,.xls,.docx,.doc,.pdf"
                        onChange={handleFileUpload}
                        disabled={uploading}
                        className="hidden"
                    />
                    <Button
                        type="button"
                        disabled={uploading}
                        className="bg-primary hover:bg-primary-hover text-white"
                        onClick={() => {
                            fileInputRef.current?.click();
                        }}
                    >
                        <Upload className="w-4 h-4 mr-2" />
                        {uploading ? '上传中...' : '上传文件'}
                    </Button>
                </div>
            </div>

            {loading ? (
                <div className="text-center py-8 text-muted-foreground">加载中...</div>
            ) : files.length === 0 ? (
                <div className="text-center py-12">
                    <File className="w-12 h-12 mx-auto mb-4 text-muted-foreground/30" />
                    <p className="text-muted-foreground">暂无文件</p>
                    <p className="text-sm text-muted-foreground mt-2">点击"上传文件"按钮上传文件</p>
                </div>
            ) : (
                <div className="border border-border rounded-lg overflow-hidden">
                    <div className="overflow-x-auto">
                        <table className="w-full">
                            <thead className="bg-muted border-b border-border">
                                <tr>
                                    <th className="px-4 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">
                                        文件名
                                    </th>
                                    <th className="px-4 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">
                                        类型
                                    </th>
                                    <th className="px-4 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">
                                        大小
                                    </th>
                                    <th className="px-4 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">
                                        上传时间
                                    </th>
                                    <th className="px-4 py-3 text-right text-xs font-medium text-muted-foreground uppercase tracking-wider">
                                        操作
                                    </th>
                                </tr>
                            </thead>
                            <tbody className="divide-y divide-border bg-card">
                                {files.map((file) => (
                                    <tr
                                        key={file.id}
                                        className="hover:bg-muted transition-colors group"
                                    >
                                        <td className="px-4 py-3">
                                            <div className="flex items-center gap-3 min-w-0">
                                                <div className="flex-shrink-0">
                                                    {getFileIcon(file)}
                                                </div>
                                                <div className="min-w-0 flex-1">
                                                    <p
                                                        className={`text-sm font-medium text-foreground break-words ${file.type === 'Image' ? 'cursor-pointer hover:underline' : ''}`}
                                                        title={file.type === 'Image' ? `点击预览: ${file.originalName}` : file.originalName}
                                                        onClick={() => file.type === 'Image' && handlePreviewFile(file)}
                                                    >
                                                        {file.originalName}
                                                    </p>
                                                    {file.directory && (
                                                        <p className="text-xs text-muted-foreground mt-1 truncate">
                                                            路径: {file.directory.path}
                                                        </p>
                                                    )}
                                                </div>
                                            </div>
                                        </td>
                                        <td className="px-4 py-3">
                                            <span className="text-xs text-muted-foreground">
                                                {file.type === 'Image' ? '图片' : file.type === 'Excel' ? 'Excel' : file.type === 'Word' ? 'Word' : 'PDF'}
                                            </span>
                                        </td>
                                        <td className="px-4 py-3">
                                            <span className="text-xs text-muted-foreground">
                                                {formatFileSize(file.size)}
                                            </span>
                                        </td>
                                        <td className="px-4 py-3">
                                            <span className="text-xs text-muted-foreground">
                                                {new Date(file.creationTime).toLocaleString('zh-CN', {
                                                    year: 'numeric',
                                                    month: '2-digit',
                                                    day: '2-digit',
                                                    hour: '2-digit',
                                                    minute: '2-digit',
                                                })}
                                            </span>
                                        </td>
                                        <td className="px-4 py-3">
                                            <div className="flex items-center justify-end gap-2">
                                                <Button
                                                    variant="ghost"
                                                    size="sm"
                                                    onClick={() => handleDownloadFile(file.id)}
                                                    className="text-xs h-7 px-2 text-muted-foreground hover:text-foreground"
                                                >
                                                    <Download className="w-3.5 h-3.5 mr-1" />
                                                    下载
                                                </Button>
                                                <Button
                                                    variant="ghost"
                                                    size="sm"
                                                    onClick={() => handleDeleteFile(file)}
                                                    className="text-xs h-7 px-2 text-destructive hover:text-destructive-foreground hover:bg-destructive/10"
                                                >
                                                    <Trash2 className="w-3.5 h-3.5" />
                                                </Button>
                                            </div>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>
            )}

            {/* 图片预览模态框 */}
            {previewFile && previewFile.type === 'Image' && (
                <div
                    className="fixed inset-0 bg-foreground/80 backdrop-blur-sm z-50 flex items-center justify-center p-4"
                    onClick={() => setPreviewFile(null)}
                >
                    <div className="relative max-w-4xl max-h-[90vh]">
                        <button
                            title="关闭预览"
                            type="button"
                            onClick={() => setPreviewFile(null)}
                            className="absolute top-4 right-4 p-2 bg-card rounded-full hover:bg-muted transition-colors z-10 shadow-lg"
                        >
                            <X className="w-5 h-5 text-card-foreground" />
                        </button>
                        <img
                            src={getFileDownloadUrl(previewFile.id)}
                            alt={previewFile.originalName}
                            className="max-w-full max-h-[90vh] object-contain rounded-lg"
                            onClick={(e) => e.stopPropagation()}
                        />
                    </div>
                </div>
            )}

            {confirmDialog}
        </div>
    );
}

