import { createFileRoute } from '@tanstack/react-router';
import { buildOrganizationUnitTree, deleteOrganizationUnit, getOrganizationUnitList, ORGANIZATION_UNIT_CATEGORY_DICT, type OrganizationUnitListOutput, type OrganizationUnitTreeNode } from './-service';
import { DeleteOutlined, EditOutlined, ExclamationCircleFilled, PlusOutlined } from '@ant-design/icons';
import { App, Button, Form, Input, Space, Tabs } from 'antd';
import { useRef, useState, useEffect } from 'react';
import Permission from '@/components/Permission';
import OrganizationUnitForm, { type OrganizationUnitModalRef } from './-OrganizationUnitForm';
import { BasisPermissions } from '@/application/permissions';
import type { SmartTableColumnType, SmartTableRef } from '@/components/SmartTable/type';
import SmartTable from '@/components/SmartTable';
import useDictionaryStore from '@/components/DataDictionarySelect/dictionaryStore';
import type { SelectOption } from '@/types/api';

export const Route = createFileRoute('/admin/organization-units/')({
  component: OrganizationUnitList,
});

function OrganizationUnitList() {
  const modalRef = useRef<OrganizationUnitModalRef>(null);
  const tableRef = useRef<SmartTableRef>(null);
  const { message, modal } = App.useApp();
  const [ouTree, setOuTree] = useState<OrganizationUnitTreeNode[]>([]);
  const [categoryOptions, setCategoryOptions] = useState<SelectOption[]>([]);
  const [selectedCategory, setSelectedCategory] = useState<string>('0');
  const getDictionary = useDictionaryStore(state => state.getDictionary);

  // 加载分类字典
  useEffect(() => {
    const loadCategoryOptions = async () => {
      try {
        const options = await getDictionary(ORGANIZATION_UNIT_CATEGORY_DICT);
        setCategoryOptions(options);
      } catch (error) {
        console.error('加载分类字典失败:', error);
        setCategoryOptions([]);
      }
    };
    loadCategoryOptions();
  }, [getDictionary]);

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
      width: 140,
      fixed: 'right',
      render: (_: any, record: OrganizationUnitListOutput) => (
        <Space>
          <Permission permissions={BasisPermissions.OrganizationUnit.Create}>
            <Button
              type="link"
              icon={<PlusOutlined />}
              key="addChild"
              onClick={() => modalRef.current?.openModal(undefined, record.id, selectedCategory || undefined)}
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
      modalRef.current.openModal(undefined, undefined, selectedCategory);
    }
  };

  // 处理分类切换
  const handleCategoryChange = (category: string) => {
    setSelectedCategory(category);
    // params 变化会自动触发 SmartTable 重新加载，无需手动调用 reload
  };

  // 构建 Tabs 项
  const tabItems = categoryOptions.length > 0
    ? 
        categoryOptions.map((option) => ({
          key: option.value as string,
          label: option.label,
        }))
    : [];

  return (
    <>
      {categoryOptions.length > 1 && (
        <Tabs
          activeKey={selectedCategory || '0'}
          onChange={handleCategoryChange}
          items={tabItems}
          style={{ marginBottom: 16 }}
        />
      )}
      <SmartTable
        ref={tableRef}
        columns={columns}
        rowKey="id"
        params={{
          category: selectedCategory,
        }}
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
