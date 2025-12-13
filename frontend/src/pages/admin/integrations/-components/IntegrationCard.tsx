import React, { useState, useRef } from 'react';
import { Card, Badge, Switch } from 'antd';
import { CaretRightOutlined } from '@ant-design/icons';
import { cn } from '@/lib/utils';

interface IntegrationCardProps {
    icon: React.ReactNode;
    title: string;
    description: string;
    enabled: boolean;
    onExpand?: () => Promise<void> | void;
    onEnableChange?: (enabled: boolean) => Promise<void> | void;
    children: React.ReactNode;
}

export default function IntegrationCard({
    icon,
    title,
    description,
    enabled,
    onExpand,
    onEnableChange,
    children
}: IntegrationCardProps) {
    const [isOpen, setIsOpen] = useState(false);
    const hasExpandedRef = useRef(false);

    const handleToggle = async () => {
        // 禁用状态下不允许展开
        if (!enabled) {
            return;
        }

        const newOpenState = !isOpen;
        setIsOpen(newOpenState);

        // 首次展开时调用 onExpand
        if (newOpenState && !hasExpandedRef.current) {
            hasExpandedRef.current = true;
            await onExpand?.();
        }
    };

    const handleSwitchChange = async (checked: boolean) => {
        // 当用户手动切换为启用时，自动展开
        if (checked && !enabled) {
            setIsOpen(true);
            // 如果是首次展开，调用 onExpand
            if (!hasExpandedRef.current) {
                hasExpandedRef.current = true;
                await onExpand?.();
            }
        }

        // 当禁用时，重置展开状态
        if (!checked) {
            setIsOpen(false);
            // 不重置 hasExpandedRef.current，保持数据加载状态的记忆
        }

        await onEnableChange?.(checked);
    };

    return (
        <Card className="shadow-sm hover:shadow-md transition-shadow duration-200">
            <div
                className={`flex items-center justify-between py-4 px-6 ${enabled ? 'cursor-pointer' : 'cursor-not-allowed'}`}
                onClick={handleToggle}
            >
                {/* 左侧：图标 + 标题 + 描述 */}
                <div className="flex items-center gap-4">
                    <div className="p-2 rounded-lg bg-blue-50">
                        {icon}
                    </div>
                    <div>
                        <div className="flex items-center gap-3">
                            <span className="text-base font-medium">{title}</span>
                        </div>
                        <p className="text-sm text-gray-500 mt-1 mb-0">{description}</p>
                    </div>
                </div>

                {/* 右侧：Badge + Switch + 展开箭头 */}
                <div className="flex items-center gap-3">
                    <Badge
                        status={enabled ? "success" : "default"}
                        text={enabled ? "已启用" : "已禁用"}
                    />
                    <Switch
                        checked={enabled}
                        onChange={handleSwitchChange}
                        onClick={(_, event) => event.stopPropagation()}
                    />
                    <CaretRightOutlined
                        className={`text-gray-500 transition-transform duration-200 ${
                            isOpen ? 'rotate-90' : ''
                        } ${!enabled ? 'opacity-30' : ''}`}
                    />
                </div>
            </div>

            {/* 只有在首次展开后才渲染子组件，之后通过display控制显示隐藏 */}
            {hasExpandedRef.current && (
                <div
                    className={cn("border-t border-gray-100", isOpen ? 'block' : 'none')}
                >
                    <div className="pt-4 px-6 pb-4">
                        {children}
                    </div>
                </div>
            )}
        </Card>
    );
}