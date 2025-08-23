import { Space, Form, Input, Button, Tag, Avatar, Select } from 'antd';
import { useRef, useState } from 'react';
import { PlusOutlined, ExclamationCircleFilled, EditOutlined, DeleteOutlined, SettingOutlined } from '@ant-design/icons';
import { deleteTenant, getTenantList, type TenantListOutput } from './service';
import TenantForm, { type ModalRef } from './_TenantForm';
import FeatureEditor from '@/pages/admin/components/FeatureEditor';
import SmartTable from '@/components/SmartTable';
import type { SmartTableColumnType, SmartTableRef } from '@/components/SmartTable/type.ts';
import useApp from 'antd/es/app/useApp';
import Permission from '@/components/Permission';
import { BasisPermissions } from '@/application/permissions';

const Tenant = () => {
  const modalRef = useRef<ModalRef>(null);
  const tableRef = useRef<SmartTableRef>(null);
  const { message, modal } = useApp();
  const [featureEditorVisible, setFeatureEditorVisible] = useState(false);
  const [currentTenantId, setCurrentTenantId] = useState<string | null>(null);
  
  const columns: SmartTableColumnType[] = [
    {
      title: '租户信息',
      dataIndex: 'name',
      key: 'name',
      render: (name: string, record: TenantListOutput) => {
        return (
          <div style={{ display: 'flex', alignItems: 'center' }}>
            {record.logo ? 
              <Avatar src={record.logo} style={{ marginRight: 12 }} /> : 
              <Avatar style={{ marginRight: 12 }}>T</Avatar>}
            <span>{name}</span>
          </div>
        );
      }
    },
    {
      title: '版本',
      dataIndex: 'editionName',
      key: 'editionName',
      render: (text: string) => {
        return text || '未分配';
      }
    },
    {
      title: '绑定域名',
      dataIndex: 'bindDomain',
      key: 'bindDomain',
      render: (text: string) => text || '-'
    },
    {
      title: '状态',
      dataIndex: 'isActive',
      key: 'isActive',
      render: (isActive: boolean) => {
        if (isActive) {
          return <Tag color="success">启用</Tag>;
        }
        return <Tag>禁用</Tag>;
      },
    },
    {
      title: '失效日期',
      dataIndex: 'expireDate',
      key: 'expireDate',
      render: (text: string) => text || '-'
    },
    {
      title: '操作',
      key: 'action',
      width: 150,
      fixed: 'right',
      render: (_: any, record: TenantListOutput) => {
        return (
          <Space>
            <Button type="link" icon={<SettingOutlined />} onClick={() => rowSetFeature(record.id)}>
              功能
            </Button>
            <Permission permissions={BasisPermissions.Tenant.Update}>
              <Button type="link" icon={<EditOutlined />} onClick={() => rowEdit(record)}>
                编辑
              </Button>
            </Permission>
            <Permission permissions={BasisPermissions.Tenant.Delete}>
              <Button type="link" icon={<DeleteOutlined />} danger onClick={() => rowDelete(record.id)}>
                删除
              </Button>
            </Permission>
          </Space>
        );
      },
    },
  ];

  const handleOpenModal = () => {
    if (modalRef.current) {
      modalRef.current.openModal();
    }
  };

  const rowDelete = (id: string) => {
    modal.confirm({
      title: '确认删除？',
      icon: <ExclamationCircleFilled />,
      content: '删除租户将会移除所有相关数据，且无法恢复，确认删除？',
      onOk() {
        deleteTenant(id).then(() => {
          message.success('删除成功');
          tableRef?.current?.reload();
        });
      },
    });
  };
  
  const rowEdit = (record: TenantListOutput) => {
    modalRef.current?.openModal(record);
  };

  const rowSetFeature = (tenantId: string) => {
    setCurrentTenantId(tenantId);
    setFeatureEditorVisible(true);
  };

  return (
    <>
      <SmartTable
        ref={tableRef}
        rowKey="id"
        columns={columns}
        request={async (params) => {
          const data = await getTenantList(params);
          return data;
        }}
        searchItems={
          <>
            <Form.Item label="租户名称" name="name">
              <Input placeholder="请输入租户名称" />
            </Form.Item>
            <Form.Item label="状态" name="isActive">
              <Select
                placeholder="请选择状态"
                allowClear
                options={[
                  { label: '启用', value: true },
                  { label: '禁用', value: false },
                ]}
              />
            </Form.Item>
          </>
        }
        toolbar={
          <Permission permissions={BasisPermissions.Tenant.Create}>
            <Button color="primary" variant="solid" icon={<PlusOutlined />} onClick={() => handleOpenModal()}>
              新增
            </Button>
          </Permission>
        }
      />
      {/* 租户新增/编辑弹窗 */}
      <TenantForm ref={modalRef} refresh={() => tableRef?.current?.reload()} />
      
      {/* 功能编辑器 */}
      {featureEditorVisible && currentTenantId && (
        <FeatureEditor
          providerName="T"
          providerKey={currentTenantId}
          onClose={() => {
            setFeatureEditorVisible(false);
            setCurrentTenantId(null);
          }}
        />
      )}
    </>
  );
};

export default Tenant; 