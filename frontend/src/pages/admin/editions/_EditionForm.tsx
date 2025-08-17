import { Form, Input, Modal } from 'antd';
import { forwardRef, useImperativeHandle, useState } from 'react';
import { addEdition, type EditionCreateOrUpdateInput, updateEdition, type EditionListOutput } from './service';
import useApp from 'antd/es/app/useApp';

interface ModalProps {
  refresh?: () => void;
}

export interface ModalRef {
  openModal: (row?: EditionListOutput) => void;
}

const EditionForm = forwardRef<ModalRef, ModalProps>((props, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [form] = Form.useForm();
  const [row, setRow] = useState<EditionListOutput | null>();
  const { message } = useApp();

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  const openModal = (row?: EditionListOutput) => {
    setIsOpenModal(true);
    if (row) {
      setRow(row);
      form.setFieldsValue({
        ...row,
      });
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

  const execute = async (
    values: EditionCreateOrUpdateInput,
    isEdit: boolean,
    successMsg: string,
  ) => {
    try {
      if (isEdit && row?.id) {
        await updateEdition(row.id, values);
      } else {
        await addEdition(values);
      }
      message.success(successMsg);
      setIsOpenModal(false);
      form.resetFields();
      props?.refresh?.();
    } catch (error) {
      console.error('操作失败:', error);
    }
  };

  const onFinish = (values: EditionCreateOrUpdateInput) => {
    const isEdit = !!row?.id;
    execute(values, isEdit, isEdit ? '编辑成功' : '新增成功');
  };

  return (
    <Modal
      title={row?.id ? '编辑版本' : '新增版本'}
      open={isOpenModal}
      onCancel={onCancel}
      onOk={onOk}
      maskClosable={false}
      width={600}
    >
      <Form<EditionCreateOrUpdateInput>
        name="edition-form"
        labelCol={{ flex: '100px' }}
        labelWrap
        form={form}
        wrapperCol={{ flex: 1 }}
        colon={false}
        onFinish={onFinish}
      >
        <Form.Item label="版本名称" name="name" rules={[{ required: true, message: '请输入版本名称' }, { max: 64, message: '版本名称不能超过64个字符' }]}>
          <Input placeholder="请输入版本名称" />
        </Form.Item>
        
        <Form.Item label="描述" name="description" rules={[{ max: 512, message: '描述不能超过512个字符' }]}>
          <Input.TextArea placeholder="请输入描述" allowClear rows={4} />
        </Form.Item>
      </Form>
    </Modal>
  );
});

export default EditionForm; 