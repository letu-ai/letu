import { Space, Form, Input, Button, Tag } from 'antd';
import { useRef } from 'react';
import { PlusOutlined, ExclamationCircleFilled, EditOutlined, HddOutlined, DeleteOutlined } from '@ant-design/icons';
import { deleteRole, getRoleList, type RoleListDto } from '@/pages/admin/roles/service';
import RoleForm, { type ModalRef } from './_RoleForm';
import AssignMenuForm, { type AssignMenuModalRef } from './_AssignMenuForm';
import PermissionForm, { type PermissionModalRef } from './_PermissionForm';
import SmartTable from '@/components/SmartTable';
import type { SmartTableColumnType, SmartTableRef } from '@/components/SmartTable/type';
import { PermissionConstant } from '@/utils/globalValue';
import useApp from 'antd/es/app/useApp';
import Permission from '@/components/Permission';
import { BasisPermissions } from '@/application/permissions';

const Role = () => {
  const modalRef = useRef<ModalRef>(null);
  const assignMenuForRef = useRef<AssignMenuModalRef>(null);
  const permissionForRef = useRef<PermissionModalRef>(null);
  const tableRef = useRef<SmartTableRef>(null);
  const { message, modal } = useApp();
  const columns: SmartTableColumnType[] = [
    {
      title: '角色名',
      dataIndex: 'name',
      key: 'name',
    },
    {
      title: '状态',
      dataIndex: 'isEnabled',
      render: (isEnabled: boolean) => {
        if (isEnabled) {
          return <Tag color="success">启用</Tag>;
        }
        return <Tag>禁用</Tag>;
      },
    },
    {
      title: '备注',
      dataIndex: 'remark',
      key: 'remark',
    },
    {
      title: '创建时间',
      dataIndex: 'creationTime',
    },
    {
      title: '操作',
      key: 'action',
      width: 210,
      fixed: 'right',
      render: (_: any, record: RoleListDto) => {
        if (record.name === PermissionConstant.SuperAdmin) return <></>;
        return (
          <Space>
            <Permission permissions={BasisPermissions.Role.Update}>
              <Button type="link" icon={<EditOutlined />} onClick={() => rowEdit(record)}>
                编辑
              </Button>
            </Permission>
              <Button type="link" icon={<HddOutlined />} onClick={() => openPermissionModal(record)}>
                权限
              </Button>
            <Permission permissions={BasisPermissions.MenuItem.Default}>
              <Button type="link" icon={<HddOutlined />} onClick={() => openAssignModal(record)}>
                菜单权限
              </Button>
            </Permission>
            <Permission permissions={BasisPermissions.Role.Delete}>
              <Button type="link" icon={<DeleteOutlined />} danger onClick={() => rowDelete(record.id)}>
                删除
              </Button>
            </Permission>
          </Space>
        );
      },
    },
  ];

  const openAssignModal = (row: RoleListDto) => {
    assignMenuForRef?.current?.openModal(row);
  };

  const openPermissionModal = (row: RoleListDto) => {
    permissionForRef?.current?.openModal(row);
  };

  const handleOpenModal = () => {
    if (modalRef.current) {
      modalRef.current.openModal();
    }
  };

  const rowDelete = (id: string) => {
    modal.confirm({
      title: '确认删除？',
      icon: <ExclamationCircleFilled />,
      onOk() {
        deleteRole(id).then(() => {
          message.success('删除成功');
          tableRef?.current?.reload();
        });
      },
    });
  };
  const rowEdit = (record: RoleListDto) => {
    modalRef.current?.openModal(record);
  };

  return (
    <>
      <SmartTable
        ref={tableRef}
        rowKey="id"
        columns={columns}
        request={async (params) => {
          const data = await getRoleList(params);
          return data;
        }}
        searchItems={
          <Form.Item label="角色" name="name">
            <Input placeholder="请输入角色名" />
          </Form.Item>
        }
        toolbar={
          <Permission permissions={BasisPermissions.Role.Create}>
            <Button color="primary" variant="solid" icon={<PlusOutlined />} onClick={() => handleOpenModal()}>
              新增
            </Button>
          </Permission>
        }
      />
      {/* 角色新增/编辑弹窗 */}
      <RoleForm ref={modalRef} refresh={() => tableRef?.current?.reload()} />
      {/* 分配菜单 */}
      <AssignMenuForm ref={assignMenuForRef} />
      {/* 分配权限 */}
      <PermissionForm ref={permissionForRef} />
    </>
  );
};
export default Role;
