import { Form, Input, InputNumber, Modal, TreeSelect } from 'antd';
import { forwardRef, useEffect, useImperativeHandle, useState } from 'react';
import {
  addOrganizationUnit,
  excludeOrganizationSubtree,
  type OrganizationUnitCreateOrUpdateInput,
  type OrganizationUnitListOutput,
  type OrganizationUnitTreeNode,
  updateOrganizationUnit,
} from './-service';
import useApp from 'antd/es/app/useApp';

interface ModalProps {
  refresh?: () => void;
  tree: OrganizationUnitTreeNode[];
}

export interface OrganizationUnitModalRef {
  openModal: (row?: OrganizationUnitListOutput, defaultParentId?: string) => void;
}

const OrganizationUnitForm = forwardRef<OrganizationUnitModalRef, ModalProps>((props, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [form] = Form.useForm<OrganizationUnitCreateOrUpdateInput>();
  const [row, setRow] = useState<OrganizationUnitListOutput | null>();
  const [treeData, setTreeData] = useState<OrganizationUnitTreeNode[]>([]);
  const { message } = useApp();

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  useEffect(() => {
    if (!isOpenModal) return;
    let tree = props.tree;
    if (row?.id) {
      tree = excludeOrganizationSubtree(tree, row.id);
    }
    setTreeData(tree);
  }, [isOpenModal, row, props.tree]);

  // 不再从服务端获取树，直接使用来自列表页的树

  const openModal = (r?: OrganizationUnitListOutput, defaultParentId?: string) => {
    setIsOpenModal(true);
    if (r) {
      setRow(r);
      form.setFieldsValue({ name: r.name, sort: r.sort, parentId: r.parentId ?? undefined });
    } else {
      setRow(null);
      form.resetFields();
      form.setFieldValue('sort', 1);
      if (defaultParentId) {
        form.setFieldValue('parentId', defaultParentId);
      }
    }
  };

  const onCancel = () => {
    form.resetFields();
    setIsOpenModal(false);
  };

  const onOk = () => {
    form.submit();
  };

  const handleSuccess = (successMessage: string) => {
    message.success(successMessage);
    setIsOpenModal(false);
    form.resetFields();
    props?.refresh?.();
  };

  const onFinish = async (values: OrganizationUnitCreateOrUpdateInput) => {
    if (row?.id) {
      await updateOrganizationUnit(row.id, values);
      handleSuccess('编辑成功');
    } else {
      await addOrganizationUnit(values);
      handleSuccess('新增成功');
    }
  };

  return (
    <Modal
      width="50%"
      title={row?.id ? '编辑机构' : '新增机构'}
      open={isOpenModal}
      onCancel={onCancel}
      onOk={onOk}
      maskClosable={false}
    >
      <Form<OrganizationUnitCreateOrUpdateInput>
        name="wrap"
        labelCol={{ flex: '90px' }}
        labelWrap
        form={form}
        wrapperCol={{ flex: 1 }}
        colon={false}
        onFinish={onFinish}
      >
        <Form.Item label="上级机构" name="parentId">
          <TreeSelect
            showSearch
            style={{ width: '100%' }}
            styles={{
              popup: {
                root: { maxHeight: 400, overflow: 'auto' },
              },
            }}
            placeholder="请选择上级机构"
            allowClear
            treeDefaultExpandAll
            treeData={treeData}
            fieldNames={{
              label: 'name',
              value: 'id',
              children: 'children',
            }}
            // 前端本地过滤，依据名称模糊匹配
            filterTreeNode={(input, node: any) =>
              (node?.name as string)?.toLowerCase().includes((input as string).toLowerCase())}
          />
        </Form.Item>
        <Form.Item label="机构名称" name="name" rules={[{ required: true }, { max: 64 }]}>
          <Input placeholder="请输入机构名称" />
        </Form.Item>
        <Form.Item label="显示顺序" name="sort">
          <InputNumber min={1} max={999} placeholder="数值越小越靠前" />
        </Form.Item>
      </Form>
    </Modal>
  );
});

export default OrganizationUnitForm;
