import { Button, Switch, Space, Form, Input, Avatar, Row, Col, Card, Tree, Tabs, Tag, Dropdown } from 'antd';
import { useRef, useState, useEffect } from 'react';
import { DeleteOutlined, EditOutlined, ExclamationCircleFilled, KeyOutlined, PlusOutlined, TeamOutlined, TagsOutlined, EllipsisOutlined } from '@ant-design/icons';
import { App } from 'antd';
import {
    deleteUser,
    getUserList,
    switchUserEnabledStatus,
    type UserListOutput,
} from '@/pages/admin/users/-service';
import UserEditForm, { type ModalRef } from './-UserModal';
import AssignRoleForm, { type AssignRoleFormRef } from "./-AssignRoleForm";
import UserTagPanel from './-UserTagPanel';
import SmartTable from '@/components/SmartTable';
import type { SmartTableRef, SmartTableColumnType } from '@/components/SmartTable/type.ts';
import ResetUserPwdForm, { type ResetUserPwdFormRef } from './-ResetUserPwdForm';
import ProIcon from '@/components/ProIcon';
import Permission, { usePermission } from '@/components/Permission';
import { BasisPermissions } from '@/application/permissions';
import { createFileRoute } from '@tanstack/react-router';
import { getApiBaseUrl } from '@/utils/urlUtils';
import { getOrganizationUnitList, buildOrganizationUnitTree, type OrganizationUnitTreeNode } from '@/pages/admin/organization-units/-service';

export const Route = createFileRoute('/admin/users/')({
    component: UserTable
});

function UserTable() {
    const tableRef = useRef<SmartTableRef>(null);
    const { message, modal } = App.useApp();
    const userEditModalRef = useRef<ModalRef>(null);
    const assignRoleRef = useRef<AssignRoleFormRef>(null);
    const resetUserPwdFormRef = useRef<ResetUserPwdFormRef>(null);
    const [selectedOrgUnitId, setSelectedOrgUnitId] = useState<string | undefined>();
    const [selectedTagId, setSelectedTagId] = useState<string | null>(null);
    const [orgTreeData, setOrgTreeData] = useState<OrganizationUnitTreeNode[]>([]);
    const [activeTab, setActiveTab] = useState<string>('org');
    const canResetPassword = usePermission({ permissions: BasisPermissions.User.ResetPassword });
    const canAssignRole = usePermission({ permissions: BasisPermissions.User.ManagePermission });
    const canDelete = usePermission({ permissions: BasisPermissions.User.Delete });

    const columns: SmartTableColumnType<UserListOutput>[] = [
        {
            title: '#',
            key: 'index',
            render: (_, __, index: number) => index + 1,
        },
        {
            title: '账号',
            dataIndex: 'userName',
            key: 'userName',
            render: (text, record) => {
                return (
                    <div className="flex items-center gap-2">
                        <Avatar size={32} src={record.avatar ? `${getApiBaseUrl()}/api/admin/users/avatars/${record.avatar}` : undefined} icon={<img src="/images/avatar/male.png" />} />
                        <div className="flex flex-col">
                            <span className="font-medium">{text}</span>
                            <span className="text-sm text-gray-500">{record.nickName}</span>
                        </div>
                    </div>)
            },
        },
        {
            title: '手机号',
            dataIndex: 'phone',
        },
        {
            title: '邮箱',
            dataIndex: 'email',
        },
        {
            title: '所属机构',
            dataIndex: 'organizationUnitName',
        },
        {
            title: '部门 & 职位',
            dataIndex: 'departmentName',
            render: (text, record) => {
                return (
                    <div>
                        <span className="font-medium">{text}</span> / <span className="text-sm text-gray-500">{record.positionName}</span>
                    </div>
                )
            },
        },
        {
            title: '标签',
            dataIndex: 'tags',
            key: 'tags',
            render: (tags: UserListOutput['tags']) => (
                <>
                    {tags && tags.length > 0 ? (
                        tags.map(tag => (
                            <Tag key={tag.id} color={tag.color || 'default'} style={{ marginBottom: 4 }}>
                                {tag.name}
                            </Tag>
                        ))
                    ) : (
                        <span className="text-gray-400">-</span>
                    )}
                </>
            ),
        },
        {
            title: '描述',
            dataIndex: 'description',
        },
        {
            title: '状态',
            dataIndex: 'isEnabled',
            key: 'isEnabled',
            render: (text: boolean, record) => (
                <Switch
                    checked={text}
                    checkedChildren="启用"
                    unCheckedChildren="禁用"
                    onChange={() => onUserStatusChange(record)}
                />
            ),
        },
        {
            title: '操作',
            key: 'action',
            width: 140,
            fixed: 'right',
            render: (_, record) => (
                <Space>
                    <Permission permissions={BasisPermissions.User.Delete}>
                        <Button
                            type="link"
                            icon={<EditOutlined />}
                            onClick={() => rowEdit(record)}>
                            编辑
                        </Button>
                    </Permission>
                    <Dropdown menu={{
                        items: [
                            {
                                key: 'assignRole',
                                icon: <ProIcon icon="iconify:simple-line-icons:check" />,
                                label: '分配角色',
                                disabled: !canAssignRole,
                            },
                            {
                                key: 'resetPassword',
                                icon: <KeyOutlined />,
                                label: '重置密码',
                                disabled: !canResetPassword,
                            },
                            {
                                key: 'divider1',
                                type: 'divider',
                            },
                            {
                                key: 'delete',
                                danger: true,
                                icon: <DeleteOutlined />,
                                label: '删除',
                                disabled: !canDelete,
                            },
                        ],
                        onClick: ({ key }) => handleMenuClick(key, record),
                    }}>
                        <Button type="link" icon={<EllipsisOutlined />} />
                    </Dropdown>
                </Space>
            ),
        },

    ];

    useEffect(() => {
        loadOrganizationUnits();
    }, []);

    const loadOrganizationUnits = async () => {
        try {
            const data = await getOrganizationUnitList({});
            const tree = buildOrganizationUnitTree(data);
            setOrgTreeData(tree);
        } catch (error) {
            console.error('Failed to load organization units:', error);
        }
    };

    const convertToTreeData = (nodes: OrganizationUnitTreeNode[]): any[] => {
        return nodes.map(node => ({
            key: node.id,
            title: node.name,
            icon: <TeamOutlined />,
            children: node.children ? convertToTreeData(node.children) : undefined
        }));
    };

    const onOrgTreeSelect = (selectedKeys: React.Key[]) => {
        const orgId = selectedKeys[0] as string | undefined;
        setSelectedOrgUnitId(orgId);
        setSelectedTagId(null); // 清除标签筛选
    };

    const onTagSelect = (tagId: string | null) => {
        setSelectedTagId(tagId);
        setSelectedOrgUnitId(undefined); // 清除机构筛选
    };

    const handleTabChange = (key: string) => {
        setActiveTab(key);
        // 切换Tab时清除筛选条件
        setSelectedOrgUnitId(undefined);
        setSelectedTagId(null);
    };

    const rowEdit = (record: UserListOutput) => {
        userEditModalRef.current?.openModal(record);
    };

    const rowDelete = (id: string) => {
        modal.confirm({
            title: '确认删除？',
            icon: <ExclamationCircleFilled />,
            onOk() {
                deleteUser(id).then(() => {
                    message.success('删除成功');
                    tableRef?.current?.reload();
                });
            },
        });
    };
    const onUserStatusChange = (record: UserListOutput) => {
        switchUserEnabledStatus(record.id).then(() => {
            message.success('状态更改成功');
            tableRef?.current?.reload();
        });
    };

    const handleMenuClick = (key: string, record: UserListOutput) => {
        switch (key) {
            case 'assignRole':
                assignRoleRef?.current?.openModal(record);
                break;
            case 'resetPassword':
                resetUserPwdFormRef?.current?.openModal(record);
                break;
            case 'delete':
                rowDelete(record.id);
                break;
        }
    };

    return (
        <Row gutter={16} className="h-full">
            <Col span={6}>
                <Card
                    className="h-full"
                    styles={{
                        body: {
                            padding: '0',
                            height: '100%'
                        }
                    }}
                >
                    <Tabs
                        activeKey={activeTab}
                        onChange={handleTabChange}
                        items={[
                            {
                                key: 'org',
                                label: (
                                    <span className="pl-3">
                                        <TeamOutlined /> 组织机构
                                    </span>
                                ),
                                children: (
                                    <div className="p-3 h-full">
                                        <div className="mb-2">
                                            <Button
                                                type="link"
                                                onClick={() => {
                                                    setSelectedOrgUnitId(undefined);
                                                }}
                                                className="p-0"
                                            >
                                                <TeamOutlined /> 全部用户
                                            </Button>
                                        </div>
                                        <Tree
                                            treeData={convertToTreeData(orgTreeData)}
                                            onSelect={onOrgTreeSelect}
                                            defaultExpandAll
                                            showIcon
                                        />
                                    </div>
                                ),
                            },
                            {
                                key: 'tags',
                                label: (
                                    <span>
                                        <TagsOutlined /> 用户标签
                                    </span>
                                ),
                                children: (
                                    <div className="h-full p-3">
                                        <UserTagPanel onTagSelect={onTagSelect} selectedTagId={selectedTagId} />
                                    </div>
                                ),
                            },
                        ]}
                    />
                </Card>
            </Col>
            <Col span={18}>
                <SmartTable
                    rowKey="id"
                    columns={columns}
                    ref={tableRef}
                    params={{
                        organizationUnitId: selectedOrgUnitId,
                        tagIds: selectedTagId ? selectedTagId : undefined
                    }}
                    request={async (params) => {
                        const data = await getUserList(params);
                        return data;
                    }}
                    searchItems={
                        <Form.Item label="关键字" name="keyword">
                            <Input placeholder="搜索账号/昵称/手机号/邮箱" />
                        </Form.Item>
                    }
                    toolbar={
                        <Permission permissions={BasisPermissions.User.Create}>
                            <Button
                                color="primary"
                                variant="solid"
                                icon={<PlusOutlined />}
                                onClick={() => {
                                    userEditModalRef?.current?.openModal();
                                }}
                            >
                                新增
                            </Button>
                        </Permission>
                    }
                />
            </Col>
            {/* 新增/编辑弹窗 */}
            <UserEditForm ref={userEditModalRef} refresh={() => tableRef?.current?.reload()} />
            {/* 分配角色弹窗 */}
            <AssignRoleForm ref={assignRoleRef} />
            {/* 重置密码弹窗 */}
            <ResetUserPwdForm ref={resetUserPwdFormRef} />
        </Row>
    );
}