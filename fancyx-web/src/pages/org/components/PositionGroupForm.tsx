import { Form, Input, InputNumber, Modal, TreeSelect } from 'antd';
import { forwardRef, useEffect, useImperativeHandle, useState } from 'react';
import {
  addPositionGroup,
  getPositionGroupList,
  type PositionGroupDto,
  type PositionGroupListDto,
  updatePositionGroup,
} from '@/api/organization/positionGroup';
import type { AppResponse } from '@/types/api';
import useApp from 'antd/es/app/useApp';

interface ModalProps {
  refresh?: () => void;
}

export interface ModalRef {
  openModal: (row?: PositionGroupDto) => void;
}

const RoleForm = forwardRef<ModalRef, ModalProps>((props, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [form] = Form.useForm();
  const [row, setRow] = useState<PositionGroupDto | null>();
  const [treeData, setTreeData] = useState<PositionGroupListDto[]>([]);
  const { message } = useApp();

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  useEffect(() => {
    if (isOpenModal) {
      fetchTreeData();
    }
  }, [isOpenModal]);

  const fetchTreeData = () => {
    getPositionGroupList().then((res) => {
      setTreeData(res.data!);
    });
  };

  const openModal = (row?: PositionGroupDto) => {
    setIsOpenModal(true);
    if (row) {
      setRow(row);
      form.setFieldsValue(row);
    } else {
      setRow(null);
      form.resetFields();
    }
  };

  const onCancel = () => {
    form.resetFields();
    setIsOpenModal(false);
  };

  const onOk = () => {
    form.submit();
  };

  const execute = (
    values: PositionGroupDto,
    apiAction: (params: PositionGroupDto) => Promise<AppResponse<boolean>>,
    successMsg: string,
  ) => {
    apiAction({ ...values, id: row?.id }).then(() => {
      message.success(successMsg);
      setIsOpenModal(false);
      form.resetFields();
      props?.refresh?.();
    });
  };
  const onFinish = (values: PositionGroupDto) => {
    const isEdit = !!row?.id;

    execute(values, isEdit ? updatePositionGroup : addPositionGroup, isEdit ? '编辑成功' : '新增成功');
  };

  return (
    <Modal
      title={row?.id ? '编辑职位分组' : '新增职位分组'}
      open={isOpenModal}
      onCancel={onCancel}
      onOk={onOk}
      maskClosable={false}
    >
      <Form<PositionGroupDto>
        name="wrap"
        labelCol={{ flex: '90px' }}
        labelWrap
        form={form}
        wrapperCol={{ flex: 1 }}
        colon={false}
        style={{ maxWidth: 600 }}
        onFinish={onFinish}
      >
        <Form.Item label="分组名称" name="groupName" rules={[{ required: true }]}>
          <Input placeholder="请输入分组名称" />
        </Form.Item>
        <Form.Item label="上级分组" name="parentId">
          <TreeSelect
            showSearch
            style={{ width: '100%' }}
            styles={{
              popup: {
                root: { maxHeight: 400, overflow: 'auto' },
              },
            }}
            placeholder="请选择上级分组"
            allowClear
            treeDefaultExpandAll
            treeData={treeData}
            fieldNames={{
              label: 'groupName',
              value: 'id',
              children: 'children',
            }}
          />
        </Form.Item>
        <Form.Item label="显示排序" name="sort">
          <InputNumber min={1} max={999} placeholder="排序值" />
        </Form.Item>
        <Form.Item label="备注" name="remark">
          <Input placeholder="请输入备注" />
        </Form.Item>
      </Form>
    </Modal>
  );
});

export default RoleForm;
