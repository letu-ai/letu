import Permission from '@/components/Permission';
import { deletePositionGroup, getPositionGroupList, type PositionGroupListDto } from '@/api/organization/positionGroup';
import { ExclamationCircleFilled, PlusOutlined } from '@ant-design/icons';
import { Button, Form, Input, message, Modal, Popconfirm, Space } from 'antd';
import React, { useRef } from 'react';
import PositionGroupForm, { type ModalRef } from '@/pages/org/components/PositionGroupForm.tsx';
import SmartTable from '@/components/SmartTable';
import type { SmartTableRef, SmartTableColumnType } from '@/components/SmartTable/type.ts';

const { confirm } = Modal;

const PositionGroupList: React.FC = () => {
  const modalRef = useRef<ModalRef>(null);
  const tableRef = useRef<SmartTableRef>(null);

  const columns: SmartTableColumnType[] = [
    {
      title: '职位分组名称',
      dataIndex: 'groupName',
    },
    {
      title: '备注',
      dataIndex: 'remark',
    },
    {
      title: '排序值',
      dataIndex: 'sort',
    },
    {
      title: '操作',
      dataIndex: 'option',
      render: (_: any, record: PositionGroupListDto) => [
        <Space>
          <Permission permissions={'Org.PositionGroup.Update'}>
            <a
              key="edit"
              onClick={() => {
                rowEdit(record);
              }}
            >
              编辑
            </a>
          </Permission>
          <Permission permissions={'Org.PositionGroup.Delete'}>
            <Popconfirm
              key="delete"
              title="确定删除吗？"
              description="删除后无法撤销"
              onConfirm={() => {
                rowDelete(record.id);
              }}
            >
              <a>删除</a>
            </Popconfirm>
          </Permission>
        </Space>,
      ],
    },
  ];

  const handleOpenModal = () => {
    if (modalRef.current) {
      modalRef.current.openModal();
    }
  };

  const rowDelete = (id: string) => {
    confirm({
      title: '确认删除？',
      icon: <ExclamationCircleFilled />,
      onOk() {
        deletePositionGroup(id).then(() => {
          message.success('删除成功');
          tableRef?.current?.reload();
        });
      },
    });
  };
  const rowEdit = (record: PositionGroupListDto) => {
    modalRef.current?.openModal(record);
  };

  return (
    <>
      <SmartTable
        ref={tableRef}
        columns={columns}
        rowKey="id"
        request={async (params) => {
          const { data } = await getPositionGroupList(params);
          return {
            items: data,
            totalCount: data.length,
          };
        }}
        searchItems={
          <Form.Item label="职位分组名称" name="groupName">
            <Input placeholder="请输入职位分组名称" />
          </Form.Item>
        }
        toolbar={
          <Button color="primary" variant="solid" icon={<PlusOutlined />} onClick={() => handleOpenModal()}>
            新增
          </Button>
        }
      />
      {/* 职位分组新增/编辑弹窗 */}
      <PositionGroupForm ref={modalRef} refresh={() => tableRef?.current?.reload()} />
    </>
  );
};

export default PositionGroupList;
