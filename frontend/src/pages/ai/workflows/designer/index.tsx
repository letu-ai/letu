'use client';

import { createFileRoute, useNavigate } from '@tanstack/react-router';
import { useCallback, useEffect, useMemo, useState } from 'react';
import {
    ReactFlow,
    Controls,
    Background,
    BackgroundVariant,
    addEdge,
    useNodesState,
    useEdgesState,
} from '@xyflow/react';
import type { Connection, Node, Edge } from '@xyflow/react';
import '@xyflow/react/dist/style.css';
import { Button, Input, Spin, App } from 'antd';
import { SaveOutlined, SendOutlined, ArrowLeftOutlined } from '@ant-design/icons';
import { getWorkflow, createWorkflow, updateWorkflow, publishWorkflow } from '../-service';
import type { FlowData, WorkflowNode, WorkflowNodeData } from '@/types/ai/workflow';
import { StartNode } from './-nodes/StartNode';
import { TextAnalysisNode } from './-nodes/TextAnalysisNode';
import { UserInputNode } from './-nodes/UserInputNode';
import { FileSelectNode } from './-nodes/FileSelectNode';
import { NodePanel } from './-components/NodePanel';
import { PropertyPanel } from './-components/PropertyPanel';

export const Route = createFileRoute('/ai/workflows/designer/')({
    component: WorkflowDesigner,
    validateSearch: (search: Record<string, unknown>) => ({
        id: search.id as string | undefined,
    }),
});

// 默认流程数据
const defaultFlowData: FlowData = {
    nodes: [
        {
            id: 'start-1',
            type: 'start',
            position: { x: 250, y: 100 },
            data: {
                type: 'start',
                name: '开始',
                description: '工作流开始节点',
                requireModel: true,
            },
        },
    ],
    edges: [],
};

function WorkflowDesigner() {
    const navigate = useNavigate();
    const { message } = App.useApp();
    const { id } = Route.useSearch();

    const [loading, setLoading] = useState(!!id);
    const [saving, setSaving] = useState(false);
    const [publishing, setPublishing] = useState(false);
    const [workflowId, setWorkflowId] = useState<string | undefined>(id);
    const [workflowName, setWorkflowName] = useState('未命名工作流');
    const [workflowDescription, setWorkflowDescription] = useState('');
    const [selectedNode, setSelectedNode] = useState<WorkflowNode | null>(null);
    const [isPublished, setIsPublished] = useState(false);
    const [version, setVersion] = useState(1);

    const [nodes, setNodes, onNodesChange] = useNodesState<WorkflowNode>([]);
    const [edges, setEdges, onEdgesChange] = useEdgesState<Edge>([]);

    // 自定义节点类型
    const nodeTypes = useMemo(
        () => ({
            start: StartNode,
            'text-analysis': TextAnalysisNode,
            'user-input': UserInputNode,
            'file-select': FileSelectNode,
        }),
        []
    );

    // 加载工作流数据
    useEffect(() => {
        if (id) {
            loadWorkflow(id);
        } else {
            // 新建工作流，使用默认数据
            setNodes(defaultFlowData.nodes as WorkflowNode[]);
            setEdges(defaultFlowData.edges);
        }
    }, [id]);

    const loadWorkflow = async (workflowId: string) => {
        try {
            setLoading(true);
            const workflow = await getWorkflow(workflowId);
            setWorkflowName(workflow.name);
            setWorkflowDescription(workflow.description || '');
            setIsPublished(workflow.isPublished);
            setVersion(workflow.version);

            if (workflow.flowData) {
                const flowData: FlowData = JSON.parse(workflow.flowData);
                setNodes(flowData.nodes as WorkflowNode[]);
                setEdges(flowData.edges);
            } else {
                setNodes(defaultFlowData.nodes as WorkflowNode[]);
                setEdges(defaultFlowData.edges);
            }
        } catch {
            message.error('加载工作流失败');
            navigate({ to: '/ai/workflows' });
        } finally {
            setLoading(false);
        }
    };

    // 连接边
    const onConnect = useCallback(
        (params: Connection) => setEdges((eds) => addEdge(params, eds)),
        [setEdges]
    );

    // 选中节点
    const onNodeClick = useCallback((_: React.MouseEvent, node: Node) => {
        setSelectedNode(node as WorkflowNode);
    }, []);

    // 取消选中
    const onPaneClick = useCallback(() => {
        setSelectedNode(null);
    }, []);

    // 更新节点数据
    const updateNodeData = useCallback(
        (nodeId: string, data: Partial<WorkflowNodeData>) => {
            setNodes((nds) =>
                nds.map((node) => {
                    if (node.id === nodeId) {
                        return {
                            ...node,
                            data: { ...node.data, ...data } as WorkflowNodeData,
                        } as WorkflowNode;
                    }
                    return node;
                })
            );
            // 更新选中节点
            if (selectedNode && selectedNode.id === nodeId) {
                setSelectedNode((prev) =>
                    prev ? ({ ...prev, data: { ...prev.data, ...data } as WorkflowNodeData } as WorkflowNode) : null
                );
            }
        },
        [setNodes, selectedNode]
    );

    // 删除节点
    const deleteNode = useCallback(
        (nodeId: string) => {
            // 不允许删除开始节点
            const node = nodes.find((n) => n.id === nodeId);
            if (node?.data.type === 'start') {
                message.warning('开始节点不能删除');
                return;
            }

            setNodes((nds) => nds.filter((n) => n.id !== nodeId));
            setEdges((eds) => eds.filter((e) => e.source !== nodeId && e.target !== nodeId));
            if (selectedNode?.id === nodeId) {
                setSelectedNode(null);
            }
        },
        [nodes, setNodes, setEdges, selectedNode, message]
    );

    // 添加节点
    const addNode = useCallback(
        (type: string) => {
            const id = `${type}-${Date.now()}`;
            const newNode: WorkflowNode = {
                id,
                type,
                position: { x: 250, y: 200 + nodes.length * 100 },
                data: getDefaultNodeData(type),
            };
            setNodes((nds) => [...nds, newNode]);
        },
        [nodes.length, setNodes]
    );

    // 获取默认节点数据
    const getDefaultNodeData = (type: string): WorkflowNodeData => {
        switch (type) {
            case 'start':
                return {
                    type: 'start',
                    name: '开始',
                    description: '工作流开始节点',
                    requireModel: true,
                };
            case 'text-analysis':
                return {
                    type: 'text-analysis',
                    name: '文本分析',
                    description: '使用AI分析文本',
                    systemPrompt: '',
                    inputVariables: [],
                };
            case 'user-input':
                return {
                    type: 'user-input',
                    name: '用户输入',
                    description: '等待用户输入',
                    prompt: '',
                };
            case 'file-select':
                return {
                    type: 'file-select',
                    name: '文件选择',
                    description: '选择文件',
                    mode: 'directory',
                };
            default:
                throw new Error(`Unknown node type: ${type}`);
        }
    };

    // 保存工作流
    const handleSave = async () => {
        if (!workflowName.trim()) {
            message.warning('请输入工作流名称');
            return;
        }

        const flowData: FlowData = { nodes, edges };

        try {
            setSaving(true);
            if (workflowId) {
                // 更新
                const result = await updateWorkflow(workflowId, {
                    name: workflowName,
                    description: workflowDescription,
                    flowData: JSON.stringify(flowData),
                });
                setIsPublished(result.isPublished);
                message.success('保存成功');
            } else {
                // 新建
                const result = await createWorkflow({
                    name: workflowName,
                    description: workflowDescription,
                    flowData: JSON.stringify(flowData),
                });
                setWorkflowId(result.id);
                setIsPublished(result.isPublished);
                setVersion(result.version);
                message.success('创建成功');
                // 更新 URL
                navigate({ to: '/ai/workflows/designer', search: { id: result.id }, replace: true });
            }
        } catch {
            message.error('保存失败');
        } finally {
            setSaving(false);
        }
    };

    // 发布工作流
    const handlePublish = async () => {
        if (!workflowId) {
            message.warning('请先保存工作流');
            return;
        }

        try {
            setPublishing(true);
            const result = await publishWorkflow(workflowId);
            setIsPublished(result.isPublished);
            setVersion(result.version);
            message.success(`发布成功，版本号: ${result.version}`);
        } catch {
            message.error('发布失败');
        } finally {
            setPublishing(false);
        }
    };

    if (loading) {
        return (
            <div className="flex items-center justify-center h-full">
                <Spin size="large" />
            </div>
        );
    }

    return (
        <div className="flex flex-col h-full bg-background">
            {/* 顶部工具栏 */}
            <div className="flex items-center justify-between px-4 py-3 border-b border-border bg-card">
                <div className="flex items-center gap-4">
                    <Button
                        type="text"
                        icon={<ArrowLeftOutlined />}
                        onClick={() => navigate({ to: '/ai/workflows' })}
                    >
                        返回
                    </Button>
                    <Input
                        value={workflowName}
                        onChange={(e) => setWorkflowName(e.target.value)}
                        placeholder="工作流名称"
                        className="w-64"
                        size="large"
                    />
                    <div className="flex items-center gap-2 text-sm text-muted-foreground">
                        <span>版本: v{version}</span>
                        <span
                            className={`px-2 py-0.5 rounded text-xs ${isPublished
                                    ? 'bg-green-100 text-green-700'
                                    : 'bg-yellow-100 text-yellow-700'
                                }`}
                        >
                            {isPublished ? '已发布' : '草稿'}
                        </span>
                    </div>
                </div>
                <div className="flex items-center gap-2">
                    <Button
                        icon={<SaveOutlined />}
                        onClick={handleSave}
                        loading={saving}
                    >
                        保存
                    </Button>
                    <Button
                        type="primary"
                        icon={<SendOutlined />}
                        onClick={handlePublish}
                        loading={publishing}
                        disabled={!workflowId}
                    >
                        发布
                    </Button>
                </div>
            </div>

            {/* 主体区域 */}
            <div className="flex flex-1 overflow-hidden">
                {/* 左侧节点面板 */}
                <NodePanel onAddNode={addNode} />

                {/* 中间画布 */}
                <div className="flex-1">
                    <ReactFlow
                        nodes={nodes}
                        edges={edges}
                        onNodesChange={onNodesChange}
                        onEdgesChange={onEdgesChange}
                        onConnect={onConnect}
                        onNodeClick={onNodeClick}
                        onPaneClick={onPaneClick}
                        nodeTypes={nodeTypes}
                        fitView
                        snapToGrid
                        snapGrid={[15, 15]}
                    >
                        <Controls />
                        <Background variant={BackgroundVariant.Dots} gap={12} size={1} />
                    </ReactFlow>
                </div>

                {/* 右侧属性面板 */}
                <PropertyPanel
                    selectedNode={selectedNode}
                    onUpdateNode={updateNodeData}
                    onDeleteNode={deleteNode}
                />
            </div>
        </div>
    );
}
