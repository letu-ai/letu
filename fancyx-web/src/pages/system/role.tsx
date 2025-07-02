import { Space, Form, Input, Button, Modal, message } from 'antd'
import { useRef } from 'react'
import { PlusOutlined, ExclamationCircleFilled } from '@ant-design/icons'
import { deleteRole, getRoleList, type RoleListDto } from '@/api/system/role'
import RoleForm, { type ModalRef } from '@/pages/system/components/RoleForm.tsx'
import AssignMenuForm, {
  type AssignMenuModalRef,
} from '@/pages/system/components/AssignMenuForm.tsx'
import SmartTable from '@/components/SmartTable'
import type { SmartTableRef } from '@/components/SmartTable/type.ts'

const { confirm } = Modal
const Role = () => {
  const modalRef = useRef<ModalRef>(null)
  const assignMenuForRef = useRef<AssignMenuModalRef>(null)
  const tableRef = useRef<SmartTableRef>(null)
  const columns = [
    {
      title: '角色名',
      dataIndex: 'roleName',
      key: 'roleName',
    },
    {
      title: '备注',
      dataIndex: 'remark',
      key: 'remark',
    },
    {
      title: '操作',
      key: 'action',
      render: (_: any, record: RoleListDto) => (
        <Space>
          <Button type="link" onClick={() => rowEdit(record)}>
            编辑
          </Button>
          <Button type="link" onClick={() => openAssignModal(record.id)}>
            分配功能
          </Button>
          <Button type="link" danger onClick={() => rowDelete(record.id)}>
            删除
          </Button>
        </Space>
      ),
    },
  ]

  const openAssignModal = (id: string) => {
    assignMenuForRef?.current?.openModal(id)
  }

  const handleOpenModal = () => {
    if (modalRef.current) {
      modalRef.current.openModal()
    }
  }

  const rowDelete = (id: string) => {
    confirm({
      title: '确认删除？',
      icon: <ExclamationCircleFilled />,
      onOk() {
        deleteRole(id).then(() => {
          message.success('删除成功')
          tableRef?.current?.reload()
        })
      },
    })
  }
  const rowEdit = (record: RoleListDto) => {
    modalRef.current?.openModal(record)
  }

  return (
    <>
      <SmartTable
        ref={tableRef}
        rowKey="id"
        columns={columns}
        request={async (params) => {
          const { data } = await getRoleList(params)
          return data
        }}
        searchItems={
          <Form.Item label="角色" name="roleName">
            <Input placeholder="请输入角色名" />
          </Form.Item>
        }
        toolbar={
          <Button
            color="primary"
            variant="solid"
            icon={<PlusOutlined />}
            onClick={() => handleOpenModal()}
          >
            新增
          </Button>
        }
      />
      {/* 角色新增/编辑弹窗 */}
      <RoleForm ref={modalRef} refresh={() => tableRef?.current?.reload()} />
      {/* 分配菜单 */}
      <AssignMenuForm ref={assignMenuForRef} />
    </>
  )
}
export default Role
