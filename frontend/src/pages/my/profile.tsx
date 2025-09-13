import { useState } from 'react';
import { Card, Form, Input, Button, Avatar, Upload, App, Spin } from 'antd';
import { UserOutlined, UploadOutlined } from '@ant-design/icons';
import { createFileRoute } from '@tanstack/react-router';
import { getProfile, updateProfile, uploadAvatar, type IProfileUpdateInput } from './-service';
import { useAsyncEffect } from 'ahooks';
import { getOssBaseUrl } from '@/utils/urlUtils';

export const Route = createFileRoute('/my/profile')({
    component: ProfilePage
});

const baseUrl = getOssBaseUrl();

function ProfilePage() {
    const [form] = Form.useForm();
    const { message } = App.useApp();
    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);
    const [uploading, setUploading] = useState(false);
    const [avatarSrc, setAvatarSrc] = useState<string>(`${baseUrl}/api/my/profile/avatar`);

    const loadProfile = async () => {
        try {
            setLoading(true);
            const data = await getProfile();
            form.setFieldsValue({
                nickName: data.nickName || '',
                avatar: data.avatar || '', // 设置头像字段值
            });
        } catch {
            message.error('获取个人信息失败');
        } finally {
            setLoading(false);
        }
    };

    useAsyncEffect(async () => {
        await loadProfile();
    }, []);

    const handleAvatarUpload = async (file: File) => {
        try {
            setUploading(true);
            // 上传时显示选择的图片
            const fileUrl = URL.createObjectURL(file);
            setAvatarSrc(fileUrl);

            const avatar = await uploadAvatar(file);
            // 只更新表单值，不立即保存到服务器
            form.setFieldValue('avatar', avatar);

            // 上传完成后显示新头像（添加时间戳避免缓存）
            setAvatarSrc(`${baseUrl}/api/my/profile/avatar?t=${Date.now()}`);
            message.success('头像上传成功，');

            // 清理临时URL
            URL.revokeObjectURL(fileUrl);
            return avatar;
        } catch {
            message.error('头像上传失败');
            // 上传失败时恢复原头像
            setAvatarSrc(`${baseUrl}/api/my/profile/avatar`);
        } finally {
            setUploading(false);
        }
    };

    const onFinish = async (values: IProfileUpdateInput) => {
        try {
            setSubmitting(true);
            await updateProfile(values);
            message.success('个人信息修改成功');
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


    return (
        <div className="max-w-4xl mx-auto">
            <Spin size="large" spinning={loading} >
                <Card title="个人资料" >
                    <Form
                        className="max-w-md mx-auto"
                        form={form}
                        layout="vertical"
                        onFinish={onFinish}
                    >
                        {/* 头像上传区域 */}
                        <div className="text-center mb-8">
                            <div className="inline-block relative">
                                <Upload {...uploadProps}>
                                    <div className="cursor-pointer">
                                        <Avatar
                                            size={120}
                                            src={avatarSrc}
                                            icon={<UserOutlined />}
                                            className=""
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

                        {/* 隐藏的头像字段 */}
                        <Form.Item name="avatar" hidden>
                            <Input />
                        </Form.Item>

                        <Form.Item
                            label="昵称"
                            name="nickName"
                            rules={[
                                { max: 32, message: '昵称长度不能超过32个字符' }
                            ]}
                        >
                            <Input placeholder="请输入昵称" />
                        </Form.Item>

                        <div className="flex justify-center space-x-3 mt-8">
                            <Button
                                type="primary"
                                htmlType="submit"
                                loading={submitting}
                                size="large"
                            >
                                保存
                            </Button>
                        </div>
                    </Form>
                </Card>
            </Spin>
        </div>
    );
}