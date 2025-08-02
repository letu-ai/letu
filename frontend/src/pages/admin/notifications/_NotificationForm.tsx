import { Form, Input, Modal, TreeSelect } from 'antd';
import { forwardRef, useEffect, useImperativeHandle, useState } from 'react';
import { addNotification, type NotificationDto, updateNotification } from './service';
import useApp from 'antd/es/app/useApp';
import { getDeptEmployeeTree, type DeptEmployeeTreeDto } from '../employees/service';
import TextArea from 'antd/es/input/TextArea';

interface ModalProps {
  refresh?: () => void;
}

export interface ModalRef {
  openModal: (row?: NotificationDto) => void;
}

const NotificationForm = forwardRef<ModalRef, ModalProps>((props, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [form] = Form.useForm();
  const [row, setRow] = useState<NotificationDto | null>();
  const { message } = useApp();
  const [treeData, setTreeData] = useState<DeptEmployeeTreeDto[]>([]);

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  useEffect(() => {
    if (isOpenModal) {
      fetchTreeData();
    }
  }, [isOpenModal]);

  const fetchTreeData = (employeeName?: string) => {
    getDeptEmployeeTree({ employeeName: employeeName }).then((data) => {
      setTreeData(data);
    });
  };

  const openModal = (row?: NotificationDto) => {
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

  const handleSuccess = (successMessage: string) => {
    message.success(successMessage);
    setIsOpenModal(false);
    form.resetFields();
    props?.refresh?.();
  };

  const onFinish = async (values: NotificationDto) => {
    if (row?.id) {
      await updateNotification(row.id, values);
      handleSuccess('编辑成功');
    } else {
      await addNotification(values);
      handleSuccess('新增成功');
    }
  };

  return (
    <Modal
      title={row?.id ? '编辑通知' : '新增通知'}
      open={isOpenModal}
      onCancel={onCancel}
      onOk={onOk}
      maskClosable={false}
    >
      <Form<NotificationDto>
        name="wrap"
        labelCol={{ flex: '90px' }}
        labelWrap
        form={form}
        wrapperCol={{ flex: 1 }}
        colon={false}
        onFinish={onFinish}
      >
        <Form.Item label="通知标题" name="title" rules={[{ required: true }, { max: 100 }]}>
          <Input placeholder="请输入通知标题" />
        </Form.Item>
        <Form.Item label="通知员工" name="employeeId" rules={[{ required: true }, { max: 500 }]}>
          <TreeSelect
            showSearch
            style={{ width: '100%' }}
            styles={{
              popup: {
                root: { maxHeight: 400, overflow: 'auto' },
              },
            }}
            placeholder="请选择通知员工"
            allowClear
            treeDefaultExpandAll
            treeData={treeData}
            filterTreeNode={false}
            onSearch={(value) => {
              fetchTreeData(value ? value : undefined);
            }}
          />
        </Form.Item>
        <Form.Item label="通知内容" name="content">
          <TextArea placeholder="请输入通知内容" autoSize={{ minRows: 2 }} maxLength={500} showCount />
        </Form.Item>
      </Form>
    </Modal>
  );
});

export default NotificationForm;
