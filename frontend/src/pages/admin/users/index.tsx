import { Button, Switch, Space, Form, Input, Avatar, Row, Col, Card, Tree } from 'antd';
import { useRef, useState, useEffect } from 'react';
import { DeleteOutlined, EditOutlined, ExclamationCircleFilled, KeyOutlined, PlusOutlined, TeamOutlined } from '@ant-design/icons';
import { App } from 'antd';
import {
    deleteUser,
    getUserList,
    switchUserEnabledStatus,
    type UserListOutput,
    type IUserListInput,
} from '@/pages/admin/users/-service';
import UserEditForm, { type ModalRef } from './-UserModal';
import AssignRoleForm, { type AssignRoleFormRef } from "./-AssignRoleForm";
import SmartTable from '@/components/SmartTable';
import type { SmartTableRef, SmartTableColumnType } from '@/components/SmartTable/type.ts';
import ResetUserPwdForm, { type ResetUserPwdFormRef } from './-ResetUserPwdForm';
import ProIcon from '@/components/ProIcon';
import Permission from '@/components/Permission';
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
    const [orgTreeData, setOrgTreeData] = useState<OrganizationUnitTreeNode[]>([]);
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
                        <span className="font-medium">{text}</span>
                    </div>)
            },
        },
        {
            title: '昵称',
            dataIndex: 'nickName',
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
            title: '部门',
            dataIndex: 'departmentName',
        },
        {
            title: '职位',
            dataIndex: 'positionName',
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
            width: 240,
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

                    <Permission permissions={BasisPermissions.User.ResetPassword}>
                        <Button
                            type="link"
                            icon={<KeyOutlined />}
                            onClick={() => {
                                resetUserPwdFormRef?.current?.openModal(record);
                            }}
                        >
                            重置密码
                        </Button>
                    </Permission>
                    <Permission permissions={BasisPermissions.Role.ManagePermission}>
                        <Button
                            type="link"
                            onClick={() => {
                                assignRoleRef?.current?.openModal(record);
                            }}
                        >
                            <ProIcon icon="iconify:simple-line-icons:check" />
                            分配角色
                        </Button>
                    </Permission>
                    <Permission permissions={BasisPermissions.User.Delete}>
                        <Button type="link" icon={<DeleteOutlined />} danger onClick={() => rowDelete(record.id)}>
                            删除
                        </Button>
                    </Permission>
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
        // 刷新表格数据
        // tableRef.current?.reload();
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

    return (
        <Row gutter={16} className="h-full">
            <Col span={6}>
                <Card
                    title="组织机构"
                    className="h-full"
                    styles={{
                        body: {
                            padding: '12px'
                        }
                    }}
                >
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
                </Card>
            </Col>
            <Col span={18}>
                <SmartTable
                    rowKey="id"
                    columns={columns}
                    ref={tableRef}
                    params={{
                        organizationUnitId: selectedOrgUnitId
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