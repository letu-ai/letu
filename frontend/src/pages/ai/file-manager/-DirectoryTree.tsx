'use client';

import { useState } from 'react';
import { Folder, FolderOpen, Plus, Trash2, Edit2, ChevronRight, ChevronDown } from 'lucide-react';
import { cn } from '@/lib/utils';
import { createDirectory, updateDirectory, deleteDirectory, type IDirectory } from './-service';
import { toast } from 'sonner';
import { getErrorInfo } from '@/utils/httpClient';
import { useConfirm } from '@/components/ConfirmDialog';

interface IDirectoryTreeProps {
    directories: IDirectory[];
    selectedDirectoryId: string | null;
    onSelectDirectory: (id: string | null) => void;
    onDirectoryCreated: () => void;
    onDirectoryDeleted: () => void;
    onDirectoryRenamed: () => void;
}

export function DirectoryTree({
    directories,
    selectedDirectoryId,
    onSelectDirectory,
    onDirectoryCreated,
    onDirectoryDeleted,
    onDirectoryRenamed,
}: IDirectoryTreeProps) {
    const [expandedIds, setExpandedIds] = useState<Set<string>>(new Set());
    const [editingId, setEditingId] = useState<string | null>(null);
    const [editName, setEditName] = useState('');
    const [originalEditName, setOriginalEditName] = useState('');
    const [creatingParentId, setCreatingParentId] = useState<string | null>(null);
    const [newDirectoryName, setNewDirectoryName] = useState('');
    const { confirm, confirmDialog } = useConfirm();

    const toggleExpand = (id: string) => {
        const newExpanded = new Set(expandedIds);
        if (newExpanded.has(id)) {
            newExpanded.delete(id);
        } else {
            newExpanded.add(id);
        }
        setExpandedIds(newExpanded);
    };

    const handleCreateDirectory = async (parentId: string | null) => {
        if (!newDirectoryName.trim())
            return;

        try {
            await createDirectory(
                {
                    name: newDirectoryName.trim(),
                    parentId,
                },
                { showGlobalErrorMessage: false }
            );
            setNewDirectoryName('');
            setCreatingParentId(null);
            onDirectoryCreated();
            // 自动展开父目录
            if (parentId) {
                setExpandedIds((prev) => new Set(prev).add(parentId));
            }
        } catch (error: any) {
            const { message } = await getErrorInfo(error);
            toast.error('创建目录失败', { duration: 5000, description: message });
        }
    };

    const handleDeleteDirectory = async (id: string, dirName: string, e: React.MouseEvent) => {
        e.stopPropagation();
        confirm({
            title: '确认删除',
            description: `确定要删除"${dirName}"吗？`,
            confirmText: '删除',
            cancelText: '取消',
            variant: 'destructive',
            action: async () => {
                try {
                    await deleteDirectory(id, { showGlobalErrorMessage: false });
                    onDirectoryDeleted();
                } catch (error: any) {
                    const { message } = await getErrorInfo(error);
                    toast.error('删除目录失败', { duration: 5000, description: message });
                    throw error; // 重新抛出错误，防止对话框关闭
                }
            },
        });
    };

    const handleStartEdit = (dir: IDirectory, e: React.MouseEvent) => {
        e.stopPropagation();
        setEditingId(dir.id);
        setEditName(dir.name);
        setOriginalEditName(dir.name);
    };

    const handleSaveEdit = async (id: string) => {
        if (!editName.trim()) {
            setEditingId(null);
            setOriginalEditName('');
            return;
        }

        // 如果名称没有改变，不提交
        if (editName.trim() === originalEditName) {
            setEditingId(null);
            setOriginalEditName('');
            return;
        }

        try {
            await updateDirectory(id, { name: editName.trim() }, { showGlobalErrorMessage: false });
            setEditingId(null);
            setOriginalEditName('');
            onDirectoryRenamed();
        } catch (error: any) {
            const { message } = await getErrorInfo(error);
            toast.error('重命名目录失败', { duration: 5000, description: message });
        }
    };

    const renderDirectory = (dir: IDirectory, level: number = 0) => {
        const isExpanded = expandedIds.has(dir.id);
        const isSelected = selectedDirectoryId === dir.id;
        const isEditing = editingId === dir.id;
        const hasChildren = dir.children && dir.children.length > 0;

        return (
            <div key={dir.id}>
                <div
                    className={cn(
                        'flex items-center gap-2 px-2 py-1.5 rounded-md cursor-pointer group hover:bg-muted transition-colors',
                        isSelected && 'bg-accent text-accent-foreground border border-border'
                    )}
                    style={{ paddingLeft: `${level * 16 + 8}px` }}
                    onClick={() => {
                        if (!isEditing) {
                            onSelectDirectory(dir.id);
                            if (hasChildren) {
                                toggleExpand(dir.id);
                            }
                        }
                    }}
                >
                    {hasChildren ? (
                        <button
                            onClick={(e) => {
                                e.stopPropagation();
                                toggleExpand(dir.id);
                            }}
                            className="p-0.5 hover:bg-secondary rounded"
                        >
                            {isExpanded ? (
                                <ChevronDown className="w-4 h-4 text-muted-foreground" />
                            ) : (
                                <ChevronRight className="w-4 h-4 text-muted-foreground" />
                            )}
                        </button>
                    ) : (
                        <div className="w-5" />
                    )}

                    {isExpanded ? (
                        <FolderOpen className="w-4 h-4 text-primary" />
                    ) : (
                        <Folder className="w-4 h-4 text-primary" />
                    )}

                    {isEditing ? (
                        <input
                            title="重命名目录"
                            type="text"
                            value={editName}
                            onChange={(e) => setEditName(e.target.value)}
                            onBlur={() => handleSaveEdit(dir.id)}
                            onKeyDown={(e) => {
                                if (e.key === 'Enter') {
                                    handleSaveEdit(dir.id);
                                } else if (e.key === 'Escape') {
                                    setEditingId(null);
                                    setOriginalEditName('');
                                }
                            }}
                            onClick={(e) => e.stopPropagation()}
                            className="flex-1 px-2 py-0.5 text-sm bg-card border border-input rounded text-foreground focus:outline-none focus:ring-1 focus:ring-ring"
                            autoFocus
                        />
                    ) : (
                        <span className="flex-1 text-sm text-card-foreground truncate">{dir.name}</span>
                    )}

                    {!isEditing && (
                        <div className="flex items-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                            <button
                                onClick={(e) => {
                                    e.stopPropagation();
                                    setCreatingParentId(dir.id);
                                    setNewDirectoryName('');
                                }}
                                className="p-1 hover:bg-secondary rounded"
                                title="创建子目录"
                            >
                                <Plus className="w-3.5 h-3.5 text-muted-foreground" />
                            </button>
                            <button
                                onClick={(e) => handleStartEdit(dir, e)}
                                className="p-1 hover:bg-secondary rounded"
                                title="重命名"
                            >
                                <Edit2 className="w-3.5 h-3.5 text-muted-foreground" />
                            </button>
                            <button
                                onClick={(e) => handleDeleteDirectory(dir.id, dir.name, e)}
                                className="p-1 hover:bg-secondary rounded"
                                title="删除"
                            >
                                <Trash2 className="w-3.5 h-3.5 text-destructive" />
                            </button>
                        </div>
                    )}
                </div>

                {isExpanded && hasChildren && (
                    <div>
                        {dir.children?.map((child) => renderDirectory(child, level + 1))}
                    </div>
                )}

                {creatingParentId === dir.id && (
                    <div
                        className="px-2 py-1.5"
                        style={{ paddingLeft: `${(level + 1) * 16 + 8}px` }}
                        onClick={(e) => e.stopPropagation()}
                    >
                        <input
                            title="创建目录"
                            type="text"
                            value={newDirectoryName}
                            onChange={(e) => setNewDirectoryName(e.target.value)}
                            onBlur={() => {
                                if (newDirectoryName.trim()) {
                                    handleCreateDirectory(dir.id);
                                } else {
                                    setCreatingParentId(null);
                                }
                            }}
                            onKeyDown={(e) => {
                                if (e.key === 'Enter') {
                                    handleCreateDirectory(dir.id);
                                } else if (e.key === 'Escape') {
                                    setCreatingParentId(null);
                                    setNewDirectoryName('');
                                }
                            }}
                            placeholder="目录名称"
                            className="w-full px-2 py-1 text-sm bg-card border border-input rounded text-foreground focus:outline-none focus:ring-1 focus:ring-ring"
                            autoFocus
                        />
                    </div>
                )}
            </div>
        );
    };

    return (
        <div className="space-y-1">
            {/* 根目录操作 */}
            <div className="mb-2">
                <div
                    className={cn(
                        'flex items-center gap-2 px-2 py-1.5 rounded-md cursor-pointer group hover:bg-muted transition-colors',
                        selectedDirectoryId === null && 'bg-accent text-accent-foreground border border-border'
                    )}
                >
                    <Folder className="w-4 h-4 text-muted-foreground" />
                    <button
                        onClick={() => onSelectDirectory(null)}
                        className="flex-1 text-left text-sm text-card-foreground"
                    >
                        根目录
                    </button>
                    {creatingParentId === null && (
                        <div className="flex items-center gap-1">
                            <button
                                onClick={(e) => {
                                    e.stopPropagation();
                                    setCreatingParentId('');
                                    setNewDirectoryName('');
                                }}
                                className="p-1 hover:bg-secondary rounded"
                                title="创建根目录"
                            >
                                <Plus className="w-3.5 h-3.5 text-muted-foreground" />
                            </button>
                        </div>
                    )}
                </div>
            </div>

            {creatingParentId === '' && (
                <div className="mb-2">
                    <input
                        type="text"
                        value={newDirectoryName}
                        onChange={(e) => setNewDirectoryName(e.target.value)}
                        onBlur={() => {
                            if (newDirectoryName.trim()) {
                                handleCreateDirectory(null);
                            } else {
                                setCreatingParentId(null);
                            }
                        }}
                        onKeyDown={(e) => {
                            if (e.key === 'Enter') {
                                handleCreateDirectory(null);
                            } else if (e.key === 'Escape') {
                                setCreatingParentId(null);
                                setNewDirectoryName('');
                            }
                        }}
                        placeholder="目录名称"
                        className="w-full px-2 py-1 text-sm bg-card border border-input rounded text-foreground focus:outline-none focus:ring-1 focus:ring-ring"
                        autoFocus
                    />
                </div>
            )}

            {/* 目录树 */}
            {directories.map((dir) => renderDirectory(dir))}

            {/* 确认对话框 */}
            {confirmDialog}
        </div>
    );
}

