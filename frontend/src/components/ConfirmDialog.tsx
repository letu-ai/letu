'use client';

import { useState, useCallback } from 'react';
import {
    AlertDialog,
    AlertDialogAction,
    AlertDialogCancel,
    AlertDialogContent,
    AlertDialogDescription,
    AlertDialogFooter,
    AlertDialogHeader,
    AlertDialogTitle,
} from '@/components/ui/alert-dialog';
import { cn } from '@/lib/utils';

interface ConfirmDialogProps {
    open: boolean;
    onOpenChange: (open: boolean) => void;
    title: string;
    description: string;
    confirmText?: string;
    cancelText?: string;
    onConfirm: () => void | Promise<void>;
    variant?: 'default' | 'destructive';
    loading?: boolean;
}

export function ConfirmDialog({
    open,
    onOpenChange,
    title,
    description,
    confirmText = '确认',
    cancelText = '取消',
    onConfirm,
    variant = 'default',
    loading = false,
}: ConfirmDialogProps) {
    const handleConfirm = async () => {
        try {
            await onConfirm();
            // 只有在成功执行后才关闭对话框
            if (!loading) {
                onOpenChange(false);
            }
        } catch {
            // 如果 onConfirm 抛出错误，不关闭对话框，让用户看到错误信息
            // 错误处理由调用者负责（如显示 toast）
        }
    };

    return (
        <AlertDialog open={open} onOpenChange={onOpenChange}>
            <AlertDialogContent>
                <AlertDialogHeader>
                    <AlertDialogTitle>{title}</AlertDialogTitle>
                    <AlertDialogDescription>{description}</AlertDialogDescription>
                </AlertDialogHeader>
                <AlertDialogFooter>
                    <AlertDialogCancel disabled={loading}>{cancelText}</AlertDialogCancel>
                    <AlertDialogAction
                        onClick={handleConfirm}
                        disabled={loading}
                        className={cn(
                            variant === 'destructive' &&
                                'bg-destructive text-destructive-foreground hover:bg-destructive/90'
                        )}
                    >
                        {loading ? '处理中...' : confirmText}
                    </AlertDialogAction>
                </AlertDialogFooter>
            </AlertDialogContent>
        </AlertDialog>
    );
}

interface IConfirmOptions {
    title?: string;
    description: string;
    confirmText?: string;
    cancelText?: string;
    variant?: 'default' | 'destructive';
    action?: () => void | Promise<void>;
}

interface IConfirmState extends IConfirmOptions {
    open: boolean;
    resolve?: (value: boolean) => void;
}

export function useConfirm() {
    const [state, setState] = useState<IConfirmState | null>(null);

    const confirm = useCallback((options: IConfirmOptions): Promise<boolean> | void => {
        // 如果提供了 action，不需要返回 Promise
        if (options.action) {
            setState({
                ...options,
                open: true,
            });
            return;
        }
        // 如果没有 action，返回 Promise 以保持向后兼容
        return new Promise((resolve) => {
            setState({
                ...options,
                open: true,
                resolve,
            });
        });
    }, []);

    const handleConfirm = useCallback(async () => {
        if (!state) return;

        try {
            // 如果有 action，执行它
            if (state.action) {
                await state.action();
                // 执行成功后关闭对话框
                setState(null);
            } else if (state.resolve) {
                // 如果没有 action，使用 resolve（向后兼容）
                state.resolve(true);
                setState(null);
            }
        } catch {
            // 如果 action 抛出错误，不关闭对话框，让用户看到错误信息
            // 错误处理由调用者负责（如显示 toast）
        }
    }, [state]);

    const handleOpenChange = useCallback(
        (open: boolean) => {
            if (!open && state) {
                // 如果对话框被关闭（比如点击外部或按 ESC），视为取消
                if (state.resolve) {
                    state.resolve(false);
                }
                setState(null);
            }
        },
        [state]
    );

    const ConfirmDialogComponent = state ? (
        <ConfirmDialog
            open={state.open}
            onOpenChange={handleOpenChange}
            title={state.title || '确认'}
            description={state.description}
            confirmText={state.confirmText}
            cancelText={state.cancelText}
            onConfirm={handleConfirm}
            variant={state.variant}
        />
    ) : null;

    return {
        confirm,
        confirmDialog: ConfirmDialogComponent,
    };
}

