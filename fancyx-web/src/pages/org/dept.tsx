import { deleteDept, getDeptList, type DeptListDto } from '@/api/organization/dept';
import { ExclamationCircleFilled, PlusOutlined } from '@ant-design/icons';
import { Button, Form, Input, message, Modal } from 'antd';
import React, { useRef } from 'react';
import Permission from '@/components/Permission';
import DeptForm, { type DeptModalRef } from '@/pages/org/components/DeptForm.tsx';
import type { SmartTableColumnType, SmartTableRef } from '@/components/SmartTable/type.ts';
import SmartTable from '@/components/SmartTable';

const { confirm } = Modal;

const DepartmentList: React.FC = () => {
  const modalRef = useRef<DeptModalRef>(null);
  const tableRef = useRef<SmartTableRef>(null);
  const columns: SmartTableColumnType[] = [
    {
      title: '部门名称',
      dataIndex: 'name',
    },
    {
      title: '部门编号',
      dataIndex: 'code',
    },
    {
      title: '部门邮箱',
      dataIndex: 'email',
    },
    {
      title: '部门电话',
      dataIndex: 'phone',
    },
    {
      title: '负责人',
      dataIndex: 'email',
    },
    {
      title: '操作',
      dataIndex: 'option',
      render: (_: any, record: DeptListDto) => [
        <Permission permissions={'Org.Dept.Update'}>
          <a
            key="edit"
            onClick={() => {
              rowEdit(record);
            }}
          >
            编辑
          </a>
        </Permission>,
        <Permission permissions={'Org.Dept.Delete'}>
          <Button type="link" danger onClick={() => rowDelete(record.id)}></Button>
        </Permission>,
      ],
    },
  ];

  const rowDelete = (id: string) => {
    confirm({
      title: '确认删除？',
      icon: <ExclamationCircleFilled />,
      onOk() {
        deleteDept(id).then(() => {
          message.success('删除成功');
          tableRef?.current?.reload();
        });
      },
    });
  };
  const rowEdit = (record: DeptListDto) => {
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
          const { data } = await getDeptList(params);
          return {
            items: data,
            totalCount: data.length,
          };
        }}
        searchItems={
          <>
            {' '}
            <Form.Item label="部门编码" name="code">
              <Input placeholder="请输入部门编码" />
            </Form.Item>
          </>
        }
        toolbar={
          <Button color="primary" variant="solid" icon={<PlusOutlined />} onClick={() => handleOpenModal()}>
            新增
          </Button>
        }
      />
      {/* 部门新增/编辑弹窗 */}
      <DeptForm ref={modalRef} refresh={() => tableRef?.current?.reload()} />
    </>
  );
};

export default DepartmentList;
