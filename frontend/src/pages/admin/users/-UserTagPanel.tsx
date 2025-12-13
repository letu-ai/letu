import { Button, Tag, List, Space, App } from 'antd';
import { PlusOutlined, EditOutlined, DeleteOutlined, ExclamationCircleFilled } from '@ant-design/icons';
import { useRef, useState, useEffect } from 'react';
import { getAllUserTags, deleteUserTag, type UserTagListOutput } from './-service';
import UserTagModal, { type ModalRef } from './-UserTagModal';

interface UserTagPanelProps {
    onTagSelect?: (tagId: string | null) => void;
    selectedTagId?: string | null;
}

const UserTagPanel: React.FC<UserTagPanelProps> = ({ onTagSelect, selectedTagId }) => {
    const { message, modal } = App.useApp();
    const [tags, setTags] = useState<UserTagListOutput[]>([]);
    const [loading, setLoading] = useState<boolean>(false);
    const tagModalRef = useRef<ModalRef>(null);

    const loadTags = async () => {
        setLoading(true);
        try {
            const data = await getAllUserTags();
            setTags(data);
        } catch (error) {
            console.error('加载标签失败:', error);
            message.error('加载标签失败');
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        loadTags();
    }, []);

    const handleTagClick = (tagId: string) => {
        if (selectedTagId === tagId) {
            // 如果点击的是已选中的标签，取消选中
            onTagSelect?.(null);
        } else {
            onTagSelect?.(tagId);
        }
    };

    const handleEdit = (tag: UserTagListOutput, e: React.MouseEvent) => {
        e.stopPropagation();
        tagModalRef.current?.openModal(tag);
    };

    const handleDelete = (tag: UserTagListOutput, e: React.MouseEvent) => {
        e.stopPropagation();
        modal.confirm({
            title: '确认删除？',
            icon: <ExclamationCircleFilled />,
            content: `确定要删除标签"${tag.name}"吗？`,
            onOk() {
                deleteUserTag(tag.id).then(() => {
                    message.success('删除成功');
                    loadTags();
                    // 如果删除的是当前选中的标签，取消选中
                    if (selectedTagId === tag.id) {
                        onTagSelect?.(null);
                    }
                });
            },
        });
    };

    return (
        <div className="h-full flex flex-col">
            <div className="pt-0 pb-3">
                <Button
                    type="dashed"
                    block
                    icon={<PlusOutlined />}
                    onClick={() => tagModalRef.current?.openModal()}
                >
                    添加标签
                </Button>
            </div>

            <div className="flex-1 overflow-y-auto">
                <List
                    loading={loading}
                    dataSource={tags}
                    renderItem={(tag) => (
                        <List.Item
                            className={`cursor-pointer hover:bg-gray-50 transition-colors px-3 py-2 ${selectedTagId === tag.id ? 'bg-blue-50' : ''
                                }`}
                            onClick={() => handleTagClick(tag.id)}
                        >
                            <div className="group flex items-center justify-between w-full">
                                <Space>
                                    <Tag color={tag.color || 'default'}>{tag.name}</Tag>
                                    <span className="text-text-muted text-xs">({tag.userCount})</span>
                                </Space>
                                <Space size="small" className="opacity-0 transition-opacity group-hover:opacity-100">
                                    <Button
                                        type="text"
                                        size="small"
                                        icon={<EditOutlined />}
                                        onClick={(e) => handleEdit(tag, e)}
                                    />
                                    <Button
                                        type="text"
                                        size="small"
                                        disabled={tag.userCount > 0}
                                        danger
                                        icon={<DeleteOutlined />}
                                        onClick={(e) => handleDelete(tag, e)}
                                    />
                                </Space>
                            </div>
                        </List.Item>
                    )}
                    locale={{ emptyText: '暂无标签' }}
                />
            </div>

            <UserTagModal ref={tagModalRef} refresh={loadTags} />
        </div>
    );
};

export default UserTagPanel;