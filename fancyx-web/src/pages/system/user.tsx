import { Button, Modal, Switch, Image, Space, Form, Input } from 'antd';
import { useRef } from 'react';
import { DeleteOutlined, ExclamationCircleFilled, KeyOutlined, PlusOutlined } from '@ant-design/icons';
import useApp from 'antd/es/app/useApp';
import {
  deleteUser,
  getUserList,
  switchUserEnabledStatus,
  type UserListDto,
  type UserQueryDto,
} from '@/api/system/user';
import UserEditForm, { type ModalRef } from '@/pages/system/components/UserForm.tsx';
import AssignRoleForm, { type AssignRoleFormRef } from '@/pages/system/components/AssignRoleForm.tsx';
import SmartTable from '@/components/SmartTable';
import type { SmartTableRef, SmartTableColumnType } from '@/components/SmartTable/type.ts';
import ResetUserPwdForm, { type ResetUserPwdFormRef } from '@/pages/system/components/ResetUserPwdForm.tsx';
import ProIcon from '@/components/ProIcon';
import { useApplication } from '@/components/Application';

const { confirm } = Modal;
const UserTable = () => {
  const tableRef = useRef<SmartTableRef>(null);
  const { message } = useApp();
  const userEditModalRef = useRef<ModalRef>(null);
  const assignRoleRef = useRef<AssignRoleFormRef>(null);
  const resetUserPwdFormRef = useRef<ResetUserPwdFormRef>(null);
  const { ossDomain } = useApplication();
  const columns: SmartTableColumnType[] = [
    {
      key: 'index',
      render: (_: any, __: any, index: number) => index + 1,
    },
    {
      title: '头像',
      dataIndex: 'avatar',
      render: (text: string) => {
        return <Image width={50} src={ossDomain + text} />;
      },
    },
    {
      title: '昵称',
      dataIndex: 'nickName',
    },
    {
      title: '账号',
      dataIndex: 'userName',
      key: 'userName',
    },
    {
      title: '性别',
      dataIndex: 'sex',
      key: 'sex',
      render: (text: number) => (text === 1 ? '男' : '女'),
    },
    {
      title: '状态',
      dataIndex: 'isEnabled',
      key: 'isEnabled',
      render: (text: boolean, record: UserListDto) => (
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
      render: (_: any, record: UserListDto) => (
        <Space>
          <Button
            type="link"
            icon={<KeyOutlined />}
            onClick={() => {
              resetUserPwdFormRef?.current?.openModal(record);
            }}
          >
            重置密码
          </Button>
          <Button
            type="link"
            onClick={() => {
              assignRoleRef?.current?.openModal(record);
            }}
          >
            <ProIcon icon="iconify:simple-line-icons:check" />
            分配角色
          </Button>
          <Button type="link" icon={<DeleteOutlined />} danger onClick={() => rowDelete(record.id)}>
            删除
          </Button>
        </Space>
      ),
    },
  ];

  const rowDelete = (id: string) => {
    confirm({
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
  const onUserStatusChange = (record: UserListDto) => {
    switchUserEnabledStatus(record.id).then(() => {
      message.success('状态更改成功');
      tableRef?.current?.reload();
    });
  };

  return (
    <>
      <SmartTable
        rowKey="id"
        columns={columns}
        ref={tableRef}
        request={async (params) => {
          const { data } = await getUserList(params);
          return data;
        }}
        searchItems={
          <Form.Item<UserQueryDto> label="账号" name="userName">
            <Input placeholder="请输入账号" />
          </Form.Item>
        }
        toolbar={
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
        }
      />
      {/* 新增/编辑弹窗 */}
      <UserEditForm ref={userEditModalRef} refresh={() => tableRef?.current?.reload()} />
      {/* 分配角色弹窗 */}
      <AssignRoleForm ref={assignRoleRef} />
      {/* 重置密码弹窗 */}
      <ResetUserPwdForm ref={resetUserPwdFormRef} />
    </>
  );
};
export default UserTable;
