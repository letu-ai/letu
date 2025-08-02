import { Form, Input, Modal, Switch, TreeSelect } from 'antd';
import { forwardRef, useEffect, useImperativeHandle, useState } from 'react';
import { addPosition, type PositionDto, type PositionListDto, updatePosition } from './service';
import { getPositionGroupList, type PositionGroupListDto } from './service';
import DataDictionarySelect from '@/components/DataDictionarySelect';
import { DictType } from '@/utils/globalValue';
import useApp from 'antd/es/app/useApp';
import TextArea from 'antd/es/input/TextArea';

interface ModalProps {
    refresh?: () => void;
}

export interface PositionModalRef {
    openModal: (row?: PositionListDto) => void;
}

const PositionForm = forwardRef<PositionModalRef, ModalProps>((props, ref) => {
    const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
    const [form] = Form.useForm();
    const [row, setRow] = useState<PositionDto | null>();
    const [treeData, setTreeData] = useState<PositionGroupListDto[]>([]);
    const [positionLevel, setPositionLevel] = useState<number>(0);
    const { message } = useApp();

    useImperativeHandle(ref, () => ({
        openModal,
    }));

    const fetchTreeData = (groupName?: string) => {
        getPositionGroupList({ groupName }).then((data) => {
            setTreeData(data);
        });
    };

    useEffect(() => {
        if (isOpenModal) {
            fetchTreeData();
        }
    }, [isOpenModal]);

    const openModal = (row?: PositionListDto) => {
        setIsOpenModal(true);
        if (row) {
            setRow(row as PositionDto);
            form.setFieldsValue(row);
            form.setFieldValue('level', row.level.toString());
            setPositionLevel(row.level);
        } else {
            setRow(null);
            form.resetFields();
            form.setFieldValue('status', 1);
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

    const onFinish = async (values: PositionDto) => {
        if (row?.id) {
            await updatePosition(row.id!, values);
            handleSuccess('编辑成功');
        } else {
            await addPosition(values);
            handleSuccess('新增成功');
        }
    };
    
    const positionLevelChange = (value: any) => {
        form.setFieldValue('positionLevel', value);
        setPositionLevel(value);
    };

    return (
        <Modal
            width="40%"
            title={row?.id ? '编辑职位' : '新增职位'}
            open={isOpenModal}
            onCancel={onCancel}
            onOk={onOk}
            maskClosable={false}
        >
            <Form<PositionDto>
                name="wrap"
                labelCol={{ flex: '90px' }}
                labelWrap
                form={form}
                wrapperCol={{ flex: 1 }}
                colon={false}
                onFinish={onFinish}
            >
                <Form.Item label="职位分组" name="groupId">
                    <TreeSelect
                        showSearch
                        style={{ width: '100%' }}
                        styles={{
                            popup: {
                                root: { maxHeight: 400, overflow: 'auto' },
                            },
                        }}
                        placeholder="请选择职位分组"
                        allowClear
                        treeDefaultExpandAll
                        treeData={treeData}
                        fieldNames={{
                            label: 'groupName',
                            value: 'id',
                            children: 'children',
                        }}
                        filterTreeNode={false}
                        onSearch={(value) => {
                            fetchTreeData(value ? value : undefined);
                        }}
                    />
                </Form.Item>
                <Form.Item label="职位名称" name="name" rules={[{ required: true }, { max: 64 }]}>
                    <Input placeholder="请输入职位名称" />
                </Form.Item>
                <Form.Item label="职位编号" name="code" rules={[{ required: true }, { max: 32 }]}>
                    <Input placeholder="请输入职位编号" />
                </Form.Item>
                <Form.Item label="职位职级" name="level" rules={[{ required: true, message: '请选择职位职级' }]}>
                    <DataDictionarySelect
                        dictType={DictType.PositionLevel}
                        value={positionLevel.toString()}
                        onChange={positionLevelChange}
                        placeholder="请选择职位职级"
                    />
                </Form.Item>
                <Form.Item label="状态" name="status" rules={[{ required: true }]}>
                    <Switch
                        value={row?.status === 1}
                        unCheckedChildren="停用"
                        checkedChildren="正常"
                        onChange={(val) => {
                            form.setFieldValue('status', val ? 1 : 2);
                        }}
                    />
                </Form.Item>
                <Form.Item label="描述" name="description" rules={[{ max: 500 }]}>
                    <TextArea placeholder="请输入描述" />
                </Form.Item>
            </Form>
        </Modal>
    );
});

export default PositionForm;
