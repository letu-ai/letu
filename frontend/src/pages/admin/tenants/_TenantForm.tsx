import { Form, Input, Modal, Switch, DatePicker, Select, Upload, Avatar } from 'antd';
import { forwardRef, useImperativeHandle, useState, useEffect } from 'react';
import { addTenant, type TenantCreateOrUpdateInput, updateTenant, getEditionOptions, type IEditionOption, type TenantListOutput } from './service';
import useApp from 'antd/es/app/useApp';
import { UploadOutlined } from '@ant-design/icons';
import { uploadFile } from '@/api/oss';
import dayjs from 'dayjs';

interface ModalProps {
  refresh?: () => void;
}

export interface ModalRef {
  openModal: (row?: TenantListOutput) => void;
}

const TenantForm = forwardRef<ModalRef, ModalProps>((props, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [form] = Form.useForm();
  const [row, setRow] = useState<TenantListOutput | null>();
  const { message } = useApp();
  const [editionOptions, setEditionOptions] = useState<IEditionOption[]>([]);
  const [logoUrl, setLogoUrl] = useState<string | null>(null);

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  useEffect(() => {
    if (isOpenModal) {
      getEditionOptions().then((data) => {
        // 确保数据格式正确
        setEditionOptions(data || []);
      }).catch((error) => {
        console.error('获取版本选项失败:', error);
        setEditionOptions([]);
      });
    }
  }, [isOpenModal]);

  const openModal = (row?: TenantListOutput) => {
    setIsOpenModal(true);
    if (row) {
      setRow(row);
      setLogoUrl(row.logo || null);
      form.setFieldsValue({
        ...row,
        expireDate: row.expireDate ? dayjs(row.expireDate) : undefined
      });
    } else {
      setRow(null);
      setLogoUrl(null);
      form.resetFields();
      form.setFieldValue('isActive', true);
    }
  };

  const onCancel = () => {
    form.resetFields();
    setIsOpenModal(false);
    setLogoUrl(null);
  };

  const onOk = () => {
    form.submit();
  };

  const execute = async (
    values: TenantCreateOrUpdateInput,
    isEdit: boolean,
    successMsg: string,
  ) => {
    // 处理日期格式
    const formattedValues = {
      ...values,
      expireDate: values.expireDate ? dayjs(values.expireDate).format('YYYY-MM-DD HH:mm:ss') : null,
      logo: logoUrl
    };

    try {
      if (isEdit && row?.id) {
        await updateTenant(row.id, formattedValues);
      } else {
        await addTenant(formattedValues);
      }
      message.success(successMsg);
      setIsOpenModal(false);
      form.resetFields();
      props?.refresh?.();
    } catch (error) {
      console.error('操作失败:', error);
    }
  };

  const onFinish = (values: TenantCreateOrUpdateInput) => {
    const isEdit = !!row?.id;
    execute(values, isEdit, isEdit ? '编辑成功' : '新增成功');
  };

  // Logo上传相关函数
  const beforeUpload = (file: File) => {
    const isJpgOrPng = file.type === 'image/jpeg' || file.type === 'image/png';
    if (!isJpgOrPng) {
      message.error('只能上传 JPG/PNG 格式的图片!');
      return false;
    }
    const isLt2M = file.size / 1024 / 1024 < 2;
    if (!isLt2M) {
      message.error('图片大小不能超过 2MB!');
      return false;
    }
    return isJpgOrPng && isLt2M;
  };

  const handleLogoUpload = async (options: any) => {
    const { file, onSuccess, onError } = options;
    
    if (!beforeUpload(file)) {
      onError('文件验证失败');
      return;
    }
    
    try {
      const logo = await uploadFile(file);
      setLogoUrl(logo);
      onSuccess(logo);
      message.success('Logo上传成功');
    } catch (error) {
      onError('上传失败');
      message.error('Logo上传失败');
    }
  };

  return (
    <Modal
      title={row?.id ? '编辑租户' : '新增租户'}
      open={isOpenModal}
      onCancel={onCancel}
      onOk={onOk}
      maskClosable={false}
      width={700}
    >
      <Form<TenantCreateOrUpdateInput>
        name="tenant-form"
        labelCol={{ flex: '100px' }}
        labelWrap
        form={form}
        wrapperCol={{ flex: 1 }}
        colon={false}
        onFinish={onFinish}
      >
        <Form.Item label="租户名称" name="name" rules={[{ required: true, message: '请输入租户名称' }, { max: 64, message: '租户名称不能超过64个字符' }]}>
          <Input placeholder="请输入租户名称" />
        </Form.Item>
        
        <Form.Item label="版本" name="editionId">
          <Select 
            placeholder="请选择版本" 
            allowClear 
            options={editionOptions.map(item => ({ label: item.name, value: item.id }))} 
          />
        </Form.Item>

        <Form.Item label="绑定域名" name="bindDomain" rules={[{ max: 128, message: '域名不能超过128个字符' }]}>
          <Input placeholder="请输入绑定域名" allowClear />
        </Form.Item>

        <Form.Item label="失效日期" name="expireDate">
          <DatePicker showTime placeholder="请选择失效日期" style={{ width: '100%' }} />
        </Form.Item>

        <Form.Item label="联系人姓名" name="contactName" rules={[{ max: 64, message: '联系人姓名不能超过64个字符' }]}>
          <Input placeholder="请输入联系人姓名" allowClear />
        </Form.Item>

        <Form.Item label="联系电话" name="contactPhone" rules={[{ max: 32, message: '联系电话不能超过32个字符' }]}>
          <Input placeholder="请输入联系电话" allowClear />
        </Form.Item>

        <Form.Item label="管理员邮箱" name="adminEmail" rules={[
          { max: 128, message: '管理员邮箱不能超过128个字符' },
          { type: 'email', message: '请输入有效的邮箱地址' }
        ]}>
          <Input placeholder="请输入管理员邮箱" allowClear />
        </Form.Item>

        <Form.Item label="网站名称" name="websiteName" rules={[{ max: 128, message: '网站名称不能超过128个字符' }]}>
          <Input placeholder="请输入网站名称" allowClear />
        </Form.Item>

        <Form.Item label="Logo" name="logo">
          <div style={{ display: 'flex', alignItems: 'center' }}>
            {logoUrl && (
              <Avatar 
                size={64} 
                src={logoUrl} 
                style={{ marginRight: 16 }}
              />
            )}
            <Upload
              customRequest={handleLogoUpload}
              showUploadList={false}
            >
              <div style={{ cursor: 'pointer', padding: '8px 16px', border: '1px solid #d9d9d9', borderRadius: '6px' }}>
                <UploadOutlined /> 上传Logo
              </div>
            </Upload>
          </div>
        </Form.Item>

        <Form.Item label="ICP备案号" name="icpNumber" rules={[{ max: 64, message: 'ICP备案号不能超过64个字符' }]}>
          <Input placeholder="请输入ICP备案号" allowClear />
        </Form.Item>

        <Form.Item label="备注" name="remark" rules={[{ max: 512, message: '备注不能超过512个字符' }]}>
          <Input.TextArea placeholder="请输入备注" allowClear rows={3} />
        </Form.Item>

        <Form.Item label="状态" name="isActive" valuePropName="checked" rules={[{ required: true, message: '请选择状态' }]}>
          <Switch checkedChildren="启用" unCheckedChildren="禁用" />
        </Form.Item>
      </Form>
    </Modal>
  );
});

export default TenantForm; 