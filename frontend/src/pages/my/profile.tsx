import { useState, useEffect, useCallback } from 'react';
import { Card, Form, Input, Select, Button, Avatar, Upload, Row, Col, App, Spin } from 'antd';
import { UserOutlined, UploadOutlined } from '@ant-design/icons';
import { createFileRoute } from '@tanstack/react-router';
import { getPersonalInfo, updatePersonalInfo, uploadAvatar, type PersonalInfoDto, type PersonalInfoUpdateDto } from './-service';

export const Route = createFileRoute('/my/profile')({
    component: ProfilePage
});

function ProfilePage() {
    const [form] = Form.useForm();
    const { message } = App.useApp();
    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);
    const [uploading, setUploading] = useState(false);
    const [personalInfo, setPersonalInfo] = useState<PersonalInfoDto>({});

    const loadPersonalInfo = useCallback(async () => {
        try {
            setLoading(true);
            const data = await getPersonalInfo();
            setPersonalInfo(data);
            form.setFieldsValue({
                nickName: data.nickName || '',
                sex: data.sex || 0,
            });
        } catch {
            message.error('获取个人信息失败');
        } finally {
            setLoading(false);
        }
    }, [form, message]);

    useEffect(() => {
        loadPersonalInfo();
    }, [loadPersonalInfo]);

    const handleAvatarUpload = async (file: File) => {
        try {
            setUploading(true);
            const result = await uploadAvatar(file);
            const newPersonalInfo = { ...personalInfo, avatar: result.url };
            setPersonalInfo(newPersonalInfo);
            
            await updatePersonalInfo({ avatar: result.url });
            message.success('头像上传成功');
            return result.url;
        } catch {
            message.error('头像上传失败');
            throw error;
        } finally {
            setUploading(false);
        }
    };

    const onFinish = async (values: PersonalInfoUpdateDto) => {
        try {
            setSubmitting(true);
            await updatePersonalInfo(values);
            message.success('个人信息修改成功');
            
            setPersonalInfo(prev => ({ ...prev, ...values }));
        } catch {
            message.error('个人信息修改失败');
        } finally {
            setSubmitting(false);
        }
    };

    const uploadProps = {
        name: 'file',
        showUploadList: false,
        beforeUpload: (file: File) => {
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
            
            handleAvatarUpload(file);
            return false;
        },
    };

    if (loading) {
        return (
            <div className="flex justify-center items-center h-64">
                <Spin size="large" />
            </div>
        );
    }

    return (
        <div className="max-w-4xl">
            <Card title="个人资料" className=" rounded-lg" >
                <Form
                    form={form}
                    layout="horizontal"
                    labelCol={{ span: 4 }}
                    wrapperCol={{ span: 20 }}
                    onFinish={onFinish}
                >
                    {/* 头像上传区域 */}
                    <div className="text-center mb-8">
                        <div className="inline-block relative">
                            <Upload {...uploadProps}>
                                <div className="cursor-pointer">
                                    <Avatar
                                        size={120}
                                        src={personalInfo.avatar ? `ossDomain${personalInfo.avatar}` : undefined}
                                        icon={<UserOutlined />}
                                        className="mb-2"
                                    />
                                    {uploading && (
                                        <div className="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center rounded-full">
                                            <Spin size="large" />
                                        </div>
                                    )}
                                </div>
                            </Upload>
                        </div>
                        <div className="mt-3">
                            <Upload {...uploadProps}>
                                <Button icon={<UploadOutlined />} loading={uploading}>
                                    {uploading ? '上传中...' : '更换头像'}
                                </Button>
                            </Upload>
                        </div>
                        <div className="text-gray-500 text-sm mt-2">
                            支持JPG、PNG格式，文件大小不超过2MB
                        </div>
                    </div>

                    {/* 基本信息表单 */}
                    <Row gutter={48}>
                        <Col span={12}>
                            <Form.Item label="用户名">
                                <Input value={personalInfo.userName} disabled />
                            </Form.Item>
                            
                            <Form.Item
                                label="昵称"
                                name="nickName"
                                rules={[
                                    { max: 50, message: '昵称长度不能超过50个字符' }
                                ]}
                            >
                                <Input placeholder="请输入昵称" />
                            </Form.Item>
                            
                            <Form.Item
                                label="性别"
                                name="sex"
                            >
                                <Select placeholder="请选择性别">
                                    <Select.Option value={0}>保密</Select.Option>
                                    <Select.Option value={1}>男</Select.Option>
                                    <Select.Option value={2}>女</Select.Option>
                                </Select>
                            </Form.Item>
                        </Col>
                        
                        <Col span={12}>
                            <Form.Item label="邮箱">
                                <Input value={personalInfo.email || '未设置'} disabled />
                            </Form.Item>
                            
                            <Form.Item label="手机号">
                                <Input value={personalInfo.phone || '未绑定'} disabled />
                            </Form.Item>
                        </Col>
                    </Row>

                    {/* 操作按钮 */}
                    <Form.Item wrapperCol={{ offset: 4, span: 20 }}>
                        <div className="flex justify-end space-x-3 mt-8">
                            <Button onClick={() => form.resetFields()}>
                                重置
                            </Button>
                            <Button 
                                type="primary" 
                                htmlType="submit"
                                loading={submitting}
                            >
                                保存修改
                            </Button>
                        </div>
                    </Form.Item>
                </Form>
            </Card>
        </div>
    );
}