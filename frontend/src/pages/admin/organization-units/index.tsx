import { createFileRoute } from '@tanstack/react-router';
import { buildOrganizationUnitTree, deleteOrganizationUnit, getOrganizationUnitList, type OrganizationUnitListOutput, type OrganizationUnitTreeNode } from './-service';
import { DeleteOutlined, EditOutlined, ExclamationCircleFilled, PlusOutlined } from '@ant-design/icons';
import { App, Button, Form, Input, Space } from 'antd';
import { useRef, useState } from 'react';
import Permission from '@/components/Permission';
import OrganizationUnitForm, { type OrganizationUnitModalRef } from './-OrganizationUnitForm';
import { BasisPermissions } from '@/application/permissions';
import type { SmartTableColumnType, SmartTableRef } from '@/components/SmartTable/type';
import SmartTable from '@/components/SmartTable';

export const Route = createFileRoute('/admin/organization-units/')({
  component: OrganizationUnitList,
});

function OrganizationUnitList() {
  const modalRef = useRef<OrganizationUnitModalRef>(null);
  const tableRef = useRef<SmartTableRef>(null);
  const { message, modal } = App.useApp();
  const [ouTree, setOuTree] = useState<OrganizationUnitTreeNode[]>([]);

  const columns: SmartTableColumnType<OrganizationUnitListOutput>[] = [
    {
      title: '机构名称',
      dataIndex: 'name',
    },
    {
      title: '排序',
      dataIndex: 'sort',
      width: 80,
    },
    {
      title: '操作',
      dataIndex: 'option',
      width: 140,
      fixed: 'right',
      render: (_: any, record: OrganizationUnitListOutput) => (
        <Space>
          <Permission permissions={BasisPermissions.OrganizationUnit.Create}>
            <Button
              type="link"
              icon={<PlusOutlined />}
              key="addChild"
              onClick={() => modalRef.current?.openModal(undefined, record.id)}
            >
              添加
            </Button>
          </Permission>
          <Permission permissions={BasisPermissions.OrganizationUnit.Update}>
            <Button
              type="link"
              icon={<EditOutlined />}
              key="edit"
              onClick={() => {
                rowEdit(record);
              }}
            >
              编辑
            </Button>
          </Permission>
          <Permission permissions={BasisPermissions.OrganizationUnit.Delete}>
            <Button type="link" icon={<DeleteOutlined />} danger onClick={() => rowDelete(record)}>
              删除
            </Button>
          </Permission>
        </Space>
      ),
    },
  ];

  const rowDelete = (record: OrganizationUnitListOutput) => {
    modal.confirm({
      title: `确认删除"${record.name}"吗？`,
      content: `其  子机构将一并删除，且无法恢复，确认删除？`,
      icon: <ExclamationCircleFilled />,
      onOk() {
        deleteOrganizationUnit(record.id).then(() => {
          message.success('删除成功');
          tableRef?.current?.reload();
        });
      },
    });
  };
  const rowEdit = (record: OrganizationUnitListOutput) => {
    modalRef.current?.openModal(record);
  };
  const handleOpenModal = () => {
    if (modalRef.current) {
      modalRef.current.openModal();
    }
  };

  return (
    <>
      <SmartTable
        ref={tableRef}
        columns={columns}
        rowKey="id"
        request={async (params) => {
          const data = await getOrganizationUnitList(params);
          const tree = buildOrganizationUnitTree(data);
          setOuTree(tree);
          return {
            items: tree,
            totalCount: data.length,
          };
        }}
        pagination={false}
        searchItems={
          <>
            <Form.Item label="机构名称" name="name">
              <Input placeholder="请输入机构名称" />
            </Form.Item>
          </>
        }
        toolbar={
          <Permission permissions={BasisPermissions.OrganizationUnit.Create}>
            <Button color="primary" variant="solid" icon={<PlusOutlined />} onClick={() => handleOpenModal()}>
              新增
            </Button>
          </Permission>
        }
      />
      {/* 新增/编辑弹窗 */}
      <OrganizationUnitForm ref={modalRef} refresh={() => tableRef?.current?.reload()} tree={ouTree} />
    </>
  );
}

export default OrganizationUnitList;
