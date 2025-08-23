import { Space, Form, Input, Button, Tag, Tabs } from 'antd';
import { useRef, useState, useEffect, useMemo } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { PlusOutlined, ExclamationCircleFilled, DeleteOutlined, EditOutlined, EyeInvisibleFilled, FolderFilled, SettingOutlined, DesktopOutlined } from '@ant-design/icons';
import MenuItemForm, { type ModalRef } from './_MenuItemForm';
import { deleteMenu, getMenuList, MenuType, type IMenuItemListOutput } from './service';
import type { SmartTableRef, SmartTableColumnType } from '@/components/SmartTable/type';
import SmartTable from '@/components/SmartTable';
import useApp from 'antd/es/app/useApp';
import Permission from '@/components/Permission';
import { BasisPermissions } from '@/application/permissions';
import ProIcon from '@/components/ProIcon';


const tabItems = [
  {
    key: 'admin',
    icon: <SettingOutlined />,
    label: '管理端菜单',
  },
  {
    key: 'app',
    icon: <DesktopOutlined />,
    label: '应用端菜单',
  },
];

const MenuTable = () => {
  const modalRef = useRef<ModalRef>(null);
  const tableRef = useRef<SmartTableRef>(null);
  const { appName = "admin" } = useParams<{ appName: string }>();
  const navigate = useNavigate();
  const { message, modal } = useApp();

  // 缓存 params 对象，避免每次渲染都创建新对象导致重复请求
  const tableParams = useMemo(() => ({ applicationName: appName }), [appName]);


  const columns: SmartTableColumnType[] = [
    {
      title: '菜单名称',
      dataIndex: 'title',
      key: 'title',
      render: (text: string, record: IMenuItemListOutput) => (
        <div>
          {record.menuType === MenuType.Folder && <FolderFilled className="mr-1" />}

          {record.icon && (
            <ProIcon icon={record.icon} className='mr-1' />
          )}
          <span>{text}</span>
          {!record.display && <EyeInvisibleFilled className="ml-1" />}
        </div>
      ),
    },
    {
      title: '路由地址',
      dataIndex: 'path',
      key: 'path',
    },
    {
      title: '依赖权限',
      dataIndex: 'permissions',
      key: 'permissions',
      render: (_: any, record: any) => {
        const list: string[] = (record as any).permissionDisplayNames || record.permissions || [];
        if (!list || list.length === 0)
          return '-';

        return (
          <div>
            {list.slice(0, 2).map((permission: string, index: number) => (
              <Tag key={index} color="blue" style={{ marginBottom: 4 }}>
                {permission}
              </Tag>
            ))}
            {list.length > 2 && (
              <Tag color="blue">+{list.length - 2}</Tag>
            )}
          </div>
        );
      },
    },
    {
      title: '依赖功能',
      dataIndex: 'features',
      key: 'features',
      render: (_: any, record: any) => {
        const list: string[] = (record as any).featureDisplayNames || record.features || [];
        if (!list || list.length === 0) return '-';
        return (
          <div>
            {list.slice(0, 2).map((feature: string, index: number) => (
              <Tag key={index} color="green" style={{ marginBottom: 4 }}>
                {feature}
              </Tag>
            ))}
            {list.length > 2 && (
              <Tag color="green">+{list.length - 2}</Tag>
            )}
          </div>
        );
      },
    },
    {
      title: '操作',
      key: 'action',
      width: 140,
      fixed: 'right',
      render: (_: any, record: IMenuItemListOutput) => (
        <div className="flex justify-end gap-1">
          {(record.menuType === MenuType.Folder) && (
            <Permission permissions={BasisPermissions.MenuItem.Create}>
              <Button type="link" icon={<PlusOutlined />} onClick={() => addSubItem(record)}>
                新增
              </Button>
            </Permission>
          )}
          <Permission permissions={BasisPermissions.MenuItem.Update}>
            <Button type="link" icon={<EditOutlined />} onClick={() => rowEdit(record)}>
              编辑
            </Button>
          </Permission>
          <Permission permissions={BasisPermissions.MenuItem.Delete}>
            <Button type="link" icon={<DeleteOutlined />} danger onClick={() => dataDelete([record.id])}>
              删除
            </Button>
          </Permission>
        </div>
      ),
    },
  ];

  const handleOpenModal = () => {
    if (modalRef.current) {
      modalRef.current.openModal(appName);
    }
  };
  const dataDelete = (ids: string[]) => {
    // TODO: 检查只能删除空文件夹
    modal.confirm({
      title: '确认删除？',
      icon: <ExclamationCircleFilled />,
      onOk() {
        deleteMenu(ids).then(() => {
          message.success('删除成功');
          tableRef?.current?.reload();
        });
      },
    });
  };
  const rowEdit = (record: IMenuItemListOutput) => {
    modalRef.current?.openModal(appName, record);
  };
  const addSubItem = (record: IMenuItemListOutput) => {
    modalRef.current?.openModal(appName, record, true);
  };

  const batchDelete = () => {
    const ids = tableRef?.current?.getSelectedKeys();
    if (!ids || !ids.length) {
      message.warning('请选择一条数据进行操作');
      return;
    }
    modal.confirm({
      title: `确认删除选中的${ids!.length}条数据？`,
      icon: <ExclamationCircleFilled />,
      onOk() {
        deleteMenu(ids as string[]).then(() => {
          message.success('删除成功');
          tableRef?.current?.reload();
        });
      },
    });
  };

  const handleTabChange = (key: string) => {
    navigate(`/admin/menus/${key}`);
  };

  return (
    <>
      {/* 菜单切换Tab */}


      <SmartTable
        columns={columns}
        ref={tableRef}
        rowKey="id"
        selection
        params={tableParams}
        request={async (params) => {
          const data = await getMenuList(params);
          return {
            items: data,
            totalCount: data.length,
          };
        }}
        searchItems={[
          <Form.Item label="菜单名称" name="title">
            <Input placeholder="请输入菜单名称" />
          </Form.Item>,
          <Form.Item label="菜单路由" name="path">
            <Input placeholder="请输入菜单路由" />
          </Form.Item>,
        ]}
        extraContent={
          <Tabs
            type='card'
            activeKey={appName}
            onChange={handleTabChange}
            items={tabItems}
          />
        }
        toolbar={
          <Space size="middle">
            <Permission permissions={BasisPermissions.MenuItem.Create}>
              <Button color="primary" variant="solid" icon={<PlusOutlined />} onClick={() => handleOpenModal()}>
                新增
              </Button>
            </Permission>
            <Permission permissions={BasisPermissions.MenuItem.Delete}>
              <Button color="danger" variant="solid" icon={<DeleteOutlined />} onClick={batchDelete}>
                删除
              </Button>
            </Permission>
          </Space>
        }
      />
      {/* 菜单新增/编辑弹窗 */}
      <MenuItemForm ref={modalRef} refresh={() => tableRef?.current?.reload()} />
    </>
  );
};
export default MenuTable;
