import { createFileRoute, useNavigate } from '@tanstack/react-router';
import { Button, Card, Space, Spin, Empty, Tag, Tooltip } from 'antd';
import { PlusOutlined, EditOutlined, DeleteOutlined, StarOutlined, SendOutlined } from '@ant-design/icons';
import { useState, useEffect } from 'react';
import { App } from 'antd';
import { getWorkflowList, deleteWorkflow, updateWorkflow, publishWorkflow } from './-service';
import type { WorkflowTemplateDto } from './-service';

export const Route = createFileRoute('/ai/workflows/')({
    component: WorkflowsPage
});

function WorkflowsPage() {
    const navigate = useNavigate();
    const { message, modal } = App.useApp();
    const [workflows, setWorkflows] = useState<WorkflowTemplateDto[]>([]);
    const [loading, setLoading] = useState(true);

    const loadWorkflows = async () => {
        try {
            setLoading(true);
            const result = await getWorkflowList();
            setWorkflows(result);
        } catch {
            message.error('加载工作流列表失败');
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        loadWorkflows();
    }, []);

    const handleCreate = () => {
        navigate({ to: '/ai/workflows/designer', search: { id: undefined } });
    };

    const handleEdit = (id: string) => {
        navigate({ to: '/ai/workflows/designer', search: { id } });
    };

    const handleDelete = (id: string, name: string) => {
        modal.confirm({
            title: '确认删除',
            content: `确定要删除工作流 "${name}" 吗？此操作不可恢复。`,
            onOk: async () => {
                try {
                    await deleteWorkflow(id);
                    message.success('删除成功');
                    loadWorkflows();
                } catch {
                    message.error('删除失败');
                }
            }
        });
    };

    const handleToggleDefault = async (id: string, currentIsDefault: boolean) => {
        try {
            await updateWorkflow(id, { isDefault: !currentIsDefault });
            message.success('操作成功');
            loadWorkflows();
        } catch {
            message.error('操作失败');
        }
    };

    const handlePublish = async (id: string, name: string) => {
        modal.confirm({
            title: '确认发布',
            content: `确定要发布工作流 "${name}" 吗？发布后可供执行使用。`,
            onOk: async () => {
                try {
                    await publishWorkflow(id);
                    message.success('发布成功');
                    loadWorkflows();
                } catch {
                    message.error('发布失败');
                }
            }
        });
    };

    if (loading) {
        return (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '400px' }}>
                <Spin size="large" />
            </div>
        );
    }

    return (
        <div style={{ padding: '24px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '24px' }}>
                <div>
                    <h1 style={{ fontSize: '24px', fontWeight: 'bold', marginBottom: '8px' }}>工作流管理</h1>
                    <p style={{ color: '#666' }}>创建、编辑和管理您的工作流程</p>
                </div>
                <Button type="primary" icon={<PlusOutlined />} onClick={handleCreate}>
                    创建新工作流
                </Button>
            </div>

            {workflows.length === 0 ? (
                <Empty description="还没有工作流，创建您的第一个工作流吧" />
            ) : (
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(300px, 1fr))', gap: '16px' }}>
                    {workflows.map((workflow) => (
                        <Card
                            key={workflow.id}
                            hoverable
                            actions={[
                                <EditOutlined key="edit" onClick={() => handleEdit(workflow.id)} />,
                                <Tooltip key="publish" title={workflow.isPublished ? '已发布' : '发布'}>
                                    <SendOutlined
                                        style={{ color: workflow.isPublished ? '#52c41a' : undefined }}
                                        onClick={() => !workflow.isPublished && handlePublish(workflow.id, workflow.name)}
                                    />
                                </Tooltip>,
                                <StarOutlined
                                    key="star"
                                    style={{ color: workflow.isDefault ? '#faad14' : undefined }}
                                    onClick={() => handleToggleDefault(workflow.id, workflow.isDefault)}
                                />,
                                <DeleteOutlined key="delete" onClick={() => handleDelete(workflow.id, workflow.name)} />
                            ]}
                        >
                            <Card.Meta
                                title={
                                    <Space>
                                        {workflow.name}
                                        {workflow.isDefault && <span style={{ color: '#faad14' }}>★</span>}
                                    </Space>
                                }
                                description={
                                    <div>
                                        <div>{workflow.description || '暂无描述'}</div>
                                        <div style={{ marginTop: 8 }}>
                                            <Space size="small">
                                                <Tag color="blue">v{workflow.version}</Tag>
                                                <Tag color={workflow.isPublished ? 'green' : 'orange'}>
                                                    {workflow.isPublished ? '已发布' : '草稿'}
                                                </Tag>
                                            </Space>
                                        </div>
                                    </div>
                                }
                            />
                        </Card>
                    ))}
                </div>
            )}
        </div>
    );
}

