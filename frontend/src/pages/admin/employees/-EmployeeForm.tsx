import { Form, Input, Radio, Modal, Row, Col, DatePicker, App } from 'antd';
import { useImperativeHandle, useState } from 'react';
import {
    addEmployee,
    type EmployeeDto,
    type EmployeeInfoDto,
    type EmployeeListDto,
    getEmployeeInfo,
    updateEmployee,
} from '@/pages/admin/employees/-service';
import dayjs from 'dayjs';

interface IEmployeeFormProps {
    refresh?: () => void;
    ref: React.RefObject<IEmployeeFormRef>;
}

export interface IEmployeeFormRef {
    openModal: (row?: EmployeeListDto) => void;
}

const EmployeeForm = ({ refresh, ref }: IEmployeeFormProps) => {
    const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
    const [form] = Form.useForm();
    const [row, setRow] = useState<EmployeeInfoDto | null>();
    const [employeeStatus, setEmployeeStatus] = useState<number>();
    const [loading, setLoading] = useState(false);
    const { message } = App.useApp();


    const openModal = (row?: EmployeeListDto) => {
        setIsOpenModal(true);
        if (row) {
            setLoading(true);
            getEmployeeInfo(row.id).then((data) => {
                setLoading(false);
                setRow(data);
                // 转换日期字段为 dayjs 对象
                const formData = {
                    ...data,
                    inTime: data.inTime ? dayjs(data.inTime) : null,
                    outTime: data.outTime ? dayjs(data.outTime) : null,
                };
                form.setFieldsValue(formData);
                setEmployeeStatus(data.status);
            });
        } else {
            setRow(null);
            form.resetFields();
            form.setFieldValue('status', 1);
            setEmployeeStatus(1);
        }
    };

    useImperativeHandle(ref, () => ({
        openModal,
    }));

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
        refresh?.();
    };

    const onFinish = async (values: EmployeeDto) => {

        values.inTime = values.inTime ? dayjs(values.inTime).format('YYYY-MM-DD') : null;
        values.outTime = values.outTime ? dayjs(values.outTime).format('YYYY-MM-DD') : null;

        if (row?.id) {
            await updateEmployee(row.id, values);
            handleSuccess('编辑成功');
        } else {
            await addEmployee(values);
            handleSuccess('新增成功');
        }
    };

    return (
        <Modal
            width="60%"
            title={row?.id ? '编辑员工' : '新增员工'}
            open={isOpenModal}
            onCancel={onCancel}
            onOk={onOk}
            maskClosable={false}
            loading={loading}
        >
            <Form<EmployeeDto>
                name="wrap"
                labelCol={{ flex: '90px' }}
                labelWrap
                form={form}
                wrapperCol={{ flex: 1 }}
                colon={false}
                onFinish={onFinish}
            >
                <Row>
                    <Col span={12}>
                        <Form.Item label="姓名" name="name" rules={[{ required: true }, { max: 64 }]}>
                            <Input placeholder="请输入姓名" />
                        </Form.Item>
                    </Col>
                    <Col span={12}>
                        <Form.Item label="工号" name="code" rules={[{ required: true }, { max: 64 }]}>
                            <Input placeholder="请输入工号" />
                        </Form.Item>
                    </Col>
                </Row>
                <Row>
                    <Col span={12}>
                        <Form.Item label="性别" name="sex" rules={[{ required: true, message: '请选择性别' }]}>
                            <Radio.Group
                                options={[
                                    { label: '男', value: 1 },
                                    { label: '女', value: 2 },
                                ]}
                            />
                        </Form.Item>
                    </Col>
                    <Col span={12}>
                        <Form.Item label="身份证号" name="idNo" rules={[{ max: 32 }]}>
                            <Input placeholder="请输入身份证号" />
                        </Form.Item>
                    </Col>
                </Row>
                <Row>
                    <Col span={12}>
                        <Form.Item label="状态" name="status" rules={[{ required: true }]}>
                            <Radio.Group
                                options={[
                                    { label: '在职', value: 1 },
                                    { label: '离职', value: 2 },
                                ]}
                                onChange={(e) => {
                                    setEmployeeStatus(e.target.value);
                                }}
                            />
                        </Form.Item>
                    </Col>
                    <Col span={12}>
                        {employeeStatus === 1 && (
                            <Form.Item label="入职时间" name="inTime">
                                <DatePicker placeholder="请选择入职时间" type="date" />
                            </Form.Item>
                        )}
                        {employeeStatus === 2 && (
                            <Form.Item label="离职时间" name="outTime">
                                <DatePicker placeholder="请选择离职时间" type="date" />
                            </Form.Item>
                        )}
                    </Col>
                </Row>
                <Row>
                    <Col span={12}>
                        <Form.Item label="生日" name="birthday">
                            <Input placeholder="输入身份证号后自动填入" disabled />
                        </Form.Item>
                    </Col>
                    <Col span={12}>
                        <Form.Item label="现住址" name="address" rules={[{ max: 512 }]}>
                            <Input placeholder="请输入现住址" maxLength={512} />
                        </Form.Item>
                    </Col>
                </Row>
            </Form>
        </Modal>
    );
};

export default EmployeeForm;