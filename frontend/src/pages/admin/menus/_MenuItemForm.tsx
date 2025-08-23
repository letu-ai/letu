import { Form, Input, InputNumber, Modal, Radio, Switch, TreeSelect } from 'antd';
import { forwardRef, useEffect, useImperativeHandle, useState } from 'react';
import {
  addMenu,
  getMenuOptions,
  type IMenuItemCreateOrOutput,
  type IMenuItemListOutput,
  type IMenuTreeSelectOption,
  updateMenu,
  MenuType,
} from './service';
import useApp from 'antd/es/app/useApp';
import PermisionSelect from '@/components/Permission/PermisionTreeSelect';
import FeatureSelect from '@/components/Feature/FeatureSelect';

interface ModalProps {
  refresh?: () => void;
}

export interface ModalRef {
  openModal: (appName: string, row?: IMenuItemListOutput, isAddSub?: boolean) => void;
}

const MenuItemForm = forwardRef<ModalRef, ModalProps>((props, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [form] = Form.useForm();
  const [row, setRow] = useState<IMenuItemListOutput | null>();
  const [appName, setAppName] = useState<string>('');

  const [treeData, setTreeData] = useState<IMenuTreeSelectOption[]>([]);
  const [menuType, setMenuType] = useState<MenuType>(MenuType.Menu);
  const { message } = useApp();
  const isEdit = row?.id !== undefined;

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  const fetchMenuOptions = (appName: string) => {
    getMenuOptions(appName, true).then((data) => {
      setTreeData(data);
    });
  };

  useEffect(() => {
    if (isOpenModal) {
      fetchMenuOptions(appName);
      form.setFieldValue('applicationName', appName);
    }
  }, [isOpenModal, appName]);

  const openModal = (appName: string, row?: IMenuItemListOutput, isAddSub?: boolean) => {
    setIsOpenModal(true);
    setAppName(appName);
    if (row && !isAddSub) {
      setRow(row);
      setMenuType(row.menuType);
      form.setFieldsValue(row);
    } else {
      setRow(null);
      const _menuType = isAddSub ? MenuType.Menu : MenuType.Folder;
      setMenuType(_menuType);
      form.setFieldsValue({
        menuType: _menuType,
        sort: 0,
        display: true,
        parentId: isAddSub ? row?.id : null,
      });
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

  const onFinish = async (values: IMenuItemCreateOrOutput) => {
    if (isEdit) {
      await updateMenu(row.id, values);
      handleSuccess('编辑成功');
    } else {
      await addMenu(values);
      handleSuccess('新增成功');
    }
  };

  return (
    <Modal
      title={isEdit ? '编辑菜单' : '新增菜单'}
      open={isOpenModal}
      onCancel={onCancel}
      onOk={onOk}
      width="50%"
      maskClosable={false}
    >
      <Form<IMenuItemCreateOrOutput>
        name="wrap"
        labelCol={{ flex: '90px' }}
        labelWrap
        form={form}
        wrapperCol={{ flex: 1 }}
        colon={false}
        onFinish={onFinish}
      >
        {isEdit ?
          <Form.Item label="菜单类型" name="menuType" hidden>
            <Input type="hidden" />
          </Form.Item>
          :
          <Form.Item label="菜单类型" name="menuType" rules={[{ required: true, message: '请选择菜单类型' }]}>
            <Radio.Group
              buttonStyle="solid"
              onChange={(e) => {
                setMenuType(e.target.value);
              }}
            >
              <Radio.Button value={1}>目录</Radio.Button>
              <Radio.Button value={2}>菜单</Radio.Button>
            </Radio.Group>
          </Form.Item>
        }
        <Form.Item name="applicationName" hidden initialValue={appName}>
          <Input type="hidden" />
        </Form.Item>
        <Form.Item label="上级菜单" name="parentId">
          <TreeSelect
            showSearch
            style={{ width: '100%' }}
            styles={{
              popup: {
                root: { maxHeight: 400, overflow: 'auto' },
              },
            }}
            placeholder="请选择上级目录"
            allowClear
            treeData={treeData}
            filterTreeNode={false}
          />
        </Form.Item>

        <Form.Item label="菜单名称" name="title" rules={[{ required: true }, { max: 32 }]}>
          <Input placeholder="请输入菜单名称" />
        </Form.Item>

        <Form.Item label="菜单图标" name="icon" rules={[{ max: 64 }]}>
          <Input placeholder="请输入菜单图标" />
        </Form.Item>

        <Form.Item label="显示排序" name="sort">
          <InputNumber min={1} max={999} placeholder="0~999" />
        </Form.Item>

        <Form.Item label="显示状态" name="display">
          <Switch checkedChildren="显示" unCheckedChildren="隐藏" />
        </Form.Item>

        {menuType === MenuType.Menu && (
          <>
            <Form.Item label="地址" name="path" rules={[{ required: true }, { max: 256 }]}>
              <Input placeholder="请输入路由地址" />
            </Form.Item>
            <Form.Item label="是否外链" name="isExternal">
              <Switch checkedChildren="外链" unCheckedChildren="内部" />
            </Form.Item>
            <Form.Item name="permissions" label="所需权限" >
              <PermisionSelect
                placeholder="不限制"
                style={{ width: '100%' }}
              />
            </Form.Item>
            <Form.Item name="features" label="功能开关" >
              <FeatureSelect
                featureValueType="BOOLEAN"
                placeholder="不限制"
                style={{ width: '100%' }}
              />
            </Form.Item>
          </>
        )}
      </Form>
    </Modal>
  );
});

export default MenuItemForm;