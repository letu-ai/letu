import { Form, message, Modal, Select } from 'antd';
import { forwardRef, useEffect, useImperativeHandle, useState } from 'react';
import { bindUser, type EmployeeBindUserDto, type EmployeeListDto } from '@/api/organization/employee.ts';
import { getUserSimpleInfos } from '@/api/system/user.ts';

// eslint-disable-next-line @typescript-eslint/no-empty-object-type
interface ModalProps {}

export interface BindUserFormRef {
  openModal: (row: EmployeeListDto) => void; // 定义 ref 的类型
}

const BindUserForm = forwardRef<BindUserFormRef, ModalProps>((_, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [form] = Form.useForm();
  const [currentRow, setCurrentRow] = useState<EmployeeListDto>();
  const [userOptions, setUserOptions] = useState<{ label: string; value: string }[]>();

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  const fetchUserSimpleInfos = (key?: string) => {
    getUserSimpleInfos(key).then((res) => {
      if (res.data && res.data.length > 0) {
        setUserOptions(
          res.data.map((x) => {
            return {
              label: `${x.nickName}\t(${x.userName})`,
              value: x.id,
            };
          }),
        );
      }
    });
  };

  useEffect(() => {
    if (isOpenModal) {
      fetchUserSimpleInfos();
    }
  }, [isOpenModal]);

  const openModal = (row: EmployeeListDto) => {
    setCurrentRow(row);
    form.setFieldValue('userId', row.userId);
    setIsOpenModal(true);
  };

  const onCancel = () => {
    form.resetFields();
    setIsOpenModal(false);
  };

  const onOk = () => {
    form.submit();
  };

  const onFinish = (values: EmployeeBindUserDto) => {
    bindUser({ ...values, employeeId: currentRow!.id }).then(() => {
      message.success('绑定成功');
      setIsOpenModal(false);
      form.resetFields();
    });
  };

  return (
    <Modal title="绑定用户" open={isOpenModal} onCancel={onCancel} onOk={onOk} maskClosable={false} width="40%">
      <Form<EmployeeBindUserDto>
        name="wrap"
        labelCol={{ flex: '80px' }}
        labelWrap
        form={form}
        wrapperCol={{ flex: 1 }}
        colon={false}
        style={{ height: '120px' }}
        onFinish={onFinish}
      >
        <p className="mb-1">将员工"{currentRow?.name}"绑定到用户：</p>
        <Form.Item name="userId">
          <Select
            options={userOptions}
            placeholder="请选择一个用户进行绑定"
            allowClear
            showSearch
            filterOption={false}
            onSearch={(value: string) => {
              fetchUserSimpleInfos(value);
            }}
          />
        </Form.Item>
      </Form>
    </Modal>
  );
});

export default BindUserForm;
