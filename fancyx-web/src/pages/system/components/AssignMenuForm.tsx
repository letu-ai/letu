import { Form, message, Modal, TreeSelect } from 'antd';
import { forwardRef, useImperativeHandle, useState } from 'react';
import { assignMenu, type AssignMenuDto, getRoleMenuIds } from '@/api/system/role.ts';
import { getMenuOptions, type MenuOptionTreeDto } from '@/api/system/menu.ts';

// eslint-disable-next-line @typescript-eslint/no-empty-object-type
interface ModalProps {}

export interface AssignMenuModalRef {
  openModal: (id: string) => void; // 定义 ref 的类型
}

const AssignMenuForm = forwardRef<AssignMenuModalRef, ModalProps>((_, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [form] = Form.useForm();
  const [menuOptions, setMenuOptions] = useState<MenuOptionTreeDto[]>([]);
  const [roleId, setRoleId] = useState<string>();

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  const openModal = (id: string) => {
    setRoleId(id);
    getMenuOptions(false).then(async (menuRes) => {
      setMenuOptions(menuRes.data);
      const { data } = await getRoleMenuIds(id);
      form.setFieldsValue({
        menuIds: data,
      });
      setIsOpenModal(true);
    });
  };

  const onCancel = () => {
    form.resetFields();
    setIsOpenModal(false);
  };

  const onOk = () => {
    form.submit();
  };

  const onFinish = (values: AssignMenuDto) => {
    assignMenu({
      menuIds: values.menuIds,
      roleId: roleId!,
    }).then(() => {
      message.success('分配成功');
      setIsOpenModal(false);
      form.resetFields();
    });
  };

  return (
    <Modal title="分配功能" open={isOpenModal} onCancel={onCancel} onOk={onOk} maskClosable={false}>
      <Form
        name="wrap"
        labelCol={{ flex: '80px' }}
        labelWrap
        form={form}
        wrapperCol={{ flex: 1 }}
        colon={false}
        style={{ maxWidth: 600 }}
        onFinish={onFinish}
      >
        <Form.Item<AssignMenuDto> label="功能" name="menuIds">
          <TreeSelect
            showSearch
            style={{ width: '100%' }}
            dropdownStyle={{ maxHeight: 400, overflow: 'auto' }}
            placeholder="请选择功能"
            allowClear
            treeDefaultExpandAll
            treeData={menuOptions}
            treeCheckable
          />
        </Form.Item>
      </Form>
    </Modal>
  );
});

export default AssignMenuForm;
