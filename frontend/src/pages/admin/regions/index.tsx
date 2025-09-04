import { createFileRoute } from "@tanstack/react-router";
import Permission from "@/components/Permission";
import { BasisPermissions } from "@/application/permissions";
import {
    deleteRegion,
    getRegionChildren,
    getLevelName,
    findNodeInTree,
    updateNodeInTree,
    removeNodeFromTree,
    type IRegionListOutput,
} from "./-service";

import { DeleteOutlined, EditOutlined, PlusOutlined, ImportOutlined } from "@ant-design/icons";
import { Button, Space, Tag, Popconfirm, App, type TableColumnsType } from "antd";
import { useRef, useState, useEffect, useCallback } from "react";
import type { SmartTableRef } from "@/components/SmartTable/type.ts";
import SmartTable from "@/components/SmartTable";
import RegionForm, { type ModalRef } from "./-RegionForm";
import RegionImport, { type ImportModalRef } from "./-RegionImport";

export const Route = createFileRoute("/admin/regions/")({
    component: RegionList
});

// 扩展树节点类型，添加前端状态
interface IRegionTreeNode extends IRegionListOutput {
    isChildrenLoaded?: boolean;  // 标记子节点是否已加载
    children?: IRegionTreeNode[]; // 覆盖children类型
}

// 将服务端数据映射为前端树节点
const mapToTreeNode = (item: IRegionListOutput): IRegionTreeNode => {
    const node: IRegionTreeNode = {
        ...item,
        isChildrenLoaded: false,
        hasChildren: item.level < 4, // 根据层级判断是否可能有子节点
    };
    
    // 如果节点可能有子级，设置空的children数组让Ant Design显示展开按钮
    if (node.hasChildren) {
        node.children = [];
    }
    
    return node;
};

// 构建前端树形数据
const buildFrontendTreeData = (list: IRegionListOutput[]): IRegionTreeNode[] => {
    const map: { [key: string]: IRegionTreeNode } = {};
    const roots: IRegionTreeNode[] = [];

    // 先建立映射表
    list.forEach(item => {
        map[item.id] = mapToTreeNode(item);
    });

    // 构建树形结构
    list.forEach(item => {
        if (item.parentId && map[item.parentId]) {
            // 确保父节点有 children 数组
            if (!map[item.parentId].children) {
                map[item.parentId].children = [];
            }
            map[item.parentId].children!.push(map[item.id]);
        } else {
            roots.push(map[item.id]);
        }
    });

    return roots;
};

function RegionList() {
    const tableRef = useRef<SmartTableRef>(null);
    const modalRef = useRef<ModalRef>(null);
    const importModalRef = useRef<ImportModalRef>(null);
    const { message } = App.useApp();
    const [treeData, setTreeData] = useState<IRegionTreeNode[]>([]);
    const [expandedRowKeys, setExpandedRowKeys] = useState<string[]>([]);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);


    // 加载初始数据（省市两级）
    const loadInitialData = useCallback(async () => {
        setLoading(true);
        setError(null);
        try {
            const data = await getRegionChildren();
            const treeStructure = buildFrontendTreeData(data);

            setTreeData(treeStructure);
        } catch (err) {
            const errorMessage = err instanceof Error ? err.message : "未知错误";
            setError(`加载数据失败: ${errorMessage}`);
        } finally {
            setLoading(false);
        }
    }, []);

    // 按需加载子级数据
    const loadChildren = useCallback(async (id: string) => {
        try {
            const children = await getRegionChildren(id);

            // 更新树形数据
            const updateTreeData = (nodes: IRegionTreeNode[]): IRegionTreeNode[] => {
                return nodes.map(node => {
                    if (node.id === id) {
                        // 将子级数据映射为树节点
                        const childrenNodes = children.map(child => mapToTreeNode(child));
                        
                        const updatedNode: IRegionTreeNode = {
                            ...node,
                            isChildrenLoaded: true, // 标记已加载
                            hasChildren: childrenNodes.length > 0, // 根据实际子级数量设置
                        };
                        
                        // 根据子节点数量设置 children
                        if (childrenNodes.length > 0) {
                            updatedNode.children = childrenNodes;
                        } else {
                            // 如果没有子节点，删除 children 属性，这样展开按钮会消失
                            delete updatedNode.children;
                        }
                        
                        return updatedNode;
                    } else if (node.children && node.children.length > 0) {
                        return {
                            ...node,
                            children: updateTreeData(node.children),
                        };
                    }
                    return node;
                });
            };

            setTreeData(prev => updateTreeData(prev));
            
            // 如果没有子级数据，从展开列表中移除该节点
            if (children.length === 0) {
                setExpandedRowKeys(prev => prev.filter(key => key !== id));
            }
        } catch (error) {
            message.error(`加载子级数据失败: ${error instanceof Error ? error.message : "未知错误"}`);
        }
    }, [message]);

    // 重新加载某个节点的子级
    const reloadNodeChildren = useCallback(async (id: string) => {
        if (!id) return;
        
        try {
            const children = await getRegionChildren(id);
            
            // 使用与 loadChildren 相同的逻辑
            const updateTreeData = (nodes: IRegionTreeNode[]): IRegionTreeNode[] => {
                return nodes.map(node => {
                    if (node.id === id) {
                        const childrenNodes = children.map(child => mapToTreeNode(child));
                        
                        const updatedNode: IRegionTreeNode = {
                            ...node,
                            isChildrenLoaded: true,
                            hasChildren: childrenNodes.length > 0
                        };
                        
                        // 根据子节点数量设置 children
                        if (childrenNodes.length > 0) {
                            updatedNode.children = childrenNodes;
                        } else {
                            // 如果没有子节点，删除 children 属性
                            delete updatedNode.children;
                        }
                        
                        return updatedNode;
                    } else if (node.children && node.children.length > 0) {
                        return {
                            ...node,
                            children: updateTreeData(node.children),
                        };
                    }
                    return node;
                });
            };
            
            setTreeData(prev => updateTreeData(prev));
        } catch (error) {
            message.error(`重新加载子级数据失败: ${error instanceof Error ? error.message : "未知错误"}`);
        }
    }, [message]);

    // 统一的刷新函数 (仅供导入功能使用)
    const refreshData = useCallback(() => {
        setTreeData([]);
        setExpandedRowKeys([]);
        loadInitialData();
    }, [loadInitialData]);

    // 表单成功处理函数
    const handleFormSuccess = useCallback(async (action: "create" | "update", data: IRegionListOutput, parentId?: string) => {
        if (action === "update") {
            // 编辑：直接更新树中的节点
            setTreeData(prev => updateNodeInTree(prev, data.id, { ...data }) as IRegionTreeNode[]);
        } else {
            // 新增：根据情况局部刷新
            if (parentId) {
                const parentNode = findNodeInTree(treeData, parentId);
                if (parentNode && expandedRowKeys.includes(parentId)) {
                    await reloadNodeChildren(parentId);
                }
            } else {
                // 顶级节点，重新加载初始数据
                await loadInitialData();
            }
        }
    }, [treeData, expandedRowKeys, reloadNodeChildren, loadInitialData]);

    // 删除处理函数
    const handleDelete = useCallback(async (record: IRegionTreeNode) => {
        try {
            await deleteRegion(record.id);
            setTreeData(prev => removeNodeFromTree(prev, record.id) as IRegionTreeNode[]);
            message.success("删除成功");
        } catch (error) {
            message.error(`删除失败: ${error instanceof Error ? error.message : "未知错误"}`);
        }
    }, [message]);

    // 展开行事件
    const handleExpand = useCallback((expanded: boolean, record: IRegionTreeNode) => {
        if (expanded && (!record.children || record.children.length === 0) && record.hasChildren) {
            loadChildren(record.id);
        }

        setExpandedRowKeys(prev => {
            if (expanded) {
                return [...prev, record.id];
            } else {
                return prev.filter(key => key !== record.id);
            }
        });
    }, [loadChildren]);

    useEffect(() => {
        loadInitialData();
    }, [loadInitialData]);

    // 统一处理错误消息显示
    useEffect(() => {
        if (error) {
            message.error(error);
        }
    }, [error, message]);

    const columns: TableColumnsType<IRegionTreeNode> = [
        {
            title: "区域名称",
            dataIndex: "name",
            width: 300,
        },
        {
            title: "区域代码",
            dataIndex: "code",
            width: 100,
        },
        {
            title: "层级",
            dataIndex: "level",
            width: 80,
            render: (level: number) => (
                <Tag color="blue">{getLevelName(level)}</Tag>
            ),
        },
        {
            title: "状态",
            dataIndex: "isEnabled",
            render: (isEnabled: boolean) => (
                <Tag color={isEnabled ? "success" : "error"}>
                    {isEnabled ? "启用" : "禁用"}
                </Tag>
            ),
        },
        {
            title: "操作",
            width: 200,
            fixed: "right",
            render: (_: any, record: IRegionTreeNode) => (
                <Space>
                    <Permission permissions={BasisPermissions.Region.Update}>
                        <Button
                            type="link"
                            icon={<EditOutlined />}
                            onClick={() => {
                                modalRef?.current?.openModal(record);
                            }}
                        >
                            编辑
                        </Button>
                    </Permission>
                    <Permission permissions={BasisPermissions.Region.Delete}>
                        <Popconfirm
                            title="确定删除吗？"
                            description="删除后将级联删除所有子级区域，无法撤销"
                            onConfirm={() => {
                                handleDelete(record);
                            }}
                        >
                            <Button type="link" danger icon={<DeleteOutlined />}>
                                删除
                            </Button>
                        </Popconfirm>
                    </Permission>
                </Space>
            ),
        },
    ];

    return (
        <>
            <SmartTable
                columns={columns}
                ref={tableRef}
                rowKey="id"
                pagination={false}
                dataSource={treeData}
                loading={loading}
                expandable={{
                    expandedRowKeys,
                    onExpand: handleExpand,
                    rowExpandable: (record) => {
                        // hasChildren=true的节点都有children数组：
                        // - 空数组：需要异步加载，显示展开按钮
                        // - 非空数组：已加载有数据，显示展开按钮  
                        // - hasChildren=false：已确认无子级，不显示按钮
                        const result = record.hasChildren && record.children !== undefined;
                        return result;
                    },
                }}
                toolbar={
                    <Space size="middle">
                        <Permission permissions={BasisPermissions.Region.Create}>
                            <Button
                                type="primary"
                                icon={<PlusOutlined />}
                                onClick={() => {
                                    modalRef?.current?.openModal();
                                }}
                            >
                                新增
                            </Button>
                        </Permission>
                        <Permission permissions={BasisPermissions.Region.Import}>
                            <Button
                                icon={<ImportOutlined />}
                                onClick={() => {
                                    importModalRef?.current?.openModal();
                                }}
                            >
                                从高德导入
                            </Button>
                        </Permission>
                    </Space>
                }
            />
            {/* 新增/编辑弹窗 */}
            <RegionForm ref={modalRef} onSuccess={handleFormSuccess} treeData={treeData} />
            {/* 导入弹窗 */}
            <RegionImport ref={importModalRef} refresh={refreshData} />
        </>
    );
}