import { Form, Input, InputNumber, Modal, Switch } from 'antd';
import { forwardRef, useImperativeHandle, useState } from 'react';
import { addDictData, type DictDataDto, updateDictData } from './service';
import { useParams } from 'react-router-dom';
import useApp from 'antd/es/app/useApp';
import TextArea from 'antd/es/input/TextArea';

interface ModalProps {
  refresh?: () => void;
}

export interface ModalRef {
  openModal: (row?: DictDataDto) => void;
}

const DictDataForm = forwardRef<ModalRef, ModalProps>((props, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [form] = Form.useForm();
  const [row, setRow] = useState<DictDataDto | null>();
  const urlParams = useParams();
  const { message } = useApp();

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  const openModal = (row?: DictDataDto) => {
    setIsOpenModal(true);
    if (row) {
      setRow(row);
      form.setFieldsValue(row);
    } else {
      setRow(null);
      form.resetFields();
      form.setFieldValue('isEnabled', true);
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

  const onFinish = async (values: DictDataDto) => {
    if (!urlParams?.type) {
      message.error('字典类型不能为空');
      return;
    }

    values.dictType = urlParams.type;
    
    if (row?.id) {
      await updateDictData({ ...values, id: row.id });
      handleSuccess('编辑成功');
    } else {
      await addDictData(values);
      handleSuccess('新增成功');
    }
  };

  return (
    <Modal
      title={row?.id ? '编辑字典' : '新增字典'}
      open={isOpenModal}
      onCancel={onCancel}
      onOk={onOk}
      maskClosable={false}
    >
      <Form<DictDataDto>
        name="wrap"
        labelCol={{ flex: '90px' }}
        labelWrap
        form={form}
        wrapperCol={{ flex: 1 }}
        colon={false}
        onFinish={onFinish}
      >
        <Form.Item label="字典标签" name="label" rules={[{ required: true }, { max: 256 }]}>
          <Input placeholder="请输入字典标签" />
        </Form.Item>
        <Form.Item label="字典键值" name="value" rules={[{ required: true }, { max: 128 }]}>
          <Input placeholder="请输入字典键值" />
        </Form.Item>
        <Form.Item label="状态" name="isEnabled">
          <Switch />
        </Form.Item>
        <Form.Item label="显示排序" name="sort" rules={[{ required: true }]}>
          <InputNumber min={1} max={999} placeholder="排序值" />
        </Form.Item>
        <Form.Item label="备注" name="remark" rules={[{ max: 512 }]}>
          <TextArea placeholder="请输入备注" />
        </Form.Item>
      </Form>
    </Modal>
  );
});

export default DictDataForm;
