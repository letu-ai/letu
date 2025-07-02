import { useEffect, useState } from 'react';
import { Card, Form, Input, Upload, message, Avatar, Divider, Row, Col, Typography, Menu, Radio, Button } from 'antd';
import { UserOutlined, CameraOutlined, LockOutlined } from '@ant-design/icons';
import './style/profile.scss';
import UserStore from '@/store/userStore.ts';
import { type PersonalInfoDto, updateInfo, updatePwd, type UserPwdDto } from '@/api/auth.ts';
import { Patterns } from '@/utils/globalValue.ts';

const { Title } = Typography;

const ProfilePage = () => {
  const { userName, nickName, avatar: userAvatar, sex } = UserStore.userInfo!;
  const [baseInfoForm] = Form.useForm();
  const [pwdForm] = Form.useForm();
  const [avatar, setAvatar] = useState(userAvatar);
  const [activeKey, setActiveKey] = useState<string>('baseInfo');
  const [loading, setLoading] = useState<boolean>(false);

  useEffect(() => {
    baseInfoForm.setFieldValue('nickName', nickName);
    baseInfoForm.setFieldValue('sex', sex);
  }, []);

  const profileMenuItems = [
    {
      key: 'baseInfo',
      label: '基本信息',
      icon: <UserOutlined />,
    },
    {
      key: 'updatePwd',
      label: '修改密码',
      icon: <LockOutlined />,
    },
  ];

  const beforeUpload = (file: File) => {
    const isJpgOrPng = file.type === 'image/jpeg' || file.type === 'image/png';
    if (!isJpgOrPng) {
      message.error('只能上传 JPG/PNG 格式的图片!');
    }
    const isLt2M = file.size / 1024 / 1024 < 2;
    if (!isLt2M) {
      message.error('图片大小不能超过 2MB!');
    }
    return isJpgOrPng && isLt2M;
  };

  const handleAvatarChange = (info: any) => {
    if (info.file.status === 'done') {
      const imageUrl = URL.createObjectURL(info.file.originFileObj);
      setAvatar(imageUrl);
      message.success('头像上传成功');
    }
  };

  const updateUserInfo = (info: PersonalInfoDto) => {
    setLoading(true);
    updateInfo(info)
      .then(() => {
        setLoading(false);
        message.success('修改成功');
      })
      .catch(() => setLoading(false));
  };

  const validateSurePassword = (_: any, value: string) => {
    const newPwd = pwdForm.getFieldValue('newPwd');
    if (newPwd && newPwd !== value) {
      return Promise.reject(new Error('两次密码不一致'));
    }
    return Promise.resolve();
  };

  const pwdPatternValidateItem = {
    pattern: Patterns.LoginPassword,
    message: '密码至少有一个字母和数字，长度6-16位，特殊字符 "~`!@#$%^&*()_-+={[}]|\\:;\\"\'<,>.?/',
  };

  return (
    <div className="profile-page">
      <Row gutter={24} className="full-height-row">
        {/* 左侧卡片 - 个人信息概览 */}
        <Col xs={24} md={6} className="card-col">
          <Card className="profile-card">
            <div className="avatar-section">
              <div className="avatar-upload">
                <Avatar size={128} src={avatar} icon={<UserOutlined />} />
                <Upload
                  name="avatar"
                  showUploadList={false}
                  beforeUpload={beforeUpload}
                  onChange={handleAvatarChange}
                  customRequest={({ file, onSuccess }) => {
                    console.log(file);
                    console.log(onSuccess);
                  }}
                >
                  <div className="avatar-upload-mask">
                    <CameraOutlined style={{ fontSize: 24 }} />
                    <div>更换头像</div>
                  </div>
                </Upload>
              </div>
            </div>

            <Divider />

            <div className="profile-summary">
              <div className="nickname-section">
                <Title level={5} style={{ margin: 0 }}>
                  {nickName}
                </Title>
              </div>
            </div>

            <div>
              <Menu
                items={profileMenuItems}
                selectedKeys={[activeKey]}
                onClick={({ key }) => {
                  setActiveKey(key);
                }}
              />
            </div>
          </Card>
        </Col>

        {/* 右侧卡片 - 详细信息 */}
        <Col xs={24} md={18} className="card-col">
          {activeKey === 'baseInfo' && (
            <Card className="detail-card">
              <Title level={5} className="detail-title">
                基本信息
              </Title>

              <Form
                form={baseInfoForm}
                layout="vertical"
                onFinish={(values) => {
                  updateUserInfo(values);
                }}
              >
                <Form.Item label="用户名" className="detail-form-item">
                  <Input value={userName} disabled />
                </Form.Item>
                <Form.Item label="昵称" className="detail-form-item" name="nickName">
                  <Input placeholder="请输入您的昵称" />
                </Form.Item>
                <Form.Item label="性别" className="detail-form-item" name="sex">
                  <Radio.Group
                    value={sex}
                    options={[
                      { label: '男', value: 1 },
                      { label: '女', value: 2 },
                    ]}
                  />
                </Form.Item>
                <Form.Item>
                  <Button type="primary" loading={loading} htmlType="submit">
                    确认修改
                  </Button>
                </Form.Item>
              </Form>
            </Card>
          )}
          {activeKey === 'updatePwd' && (
            <Card className="detail-card">
              <Title level={5} className="detail-title">
                修改密码
              </Title>

              <Form
                form={pwdForm}
                layout="vertical"
                onFinish={(values: UserPwdDto) => {
                  setLoading(true);
                  updatePwd(values)
                    .then(() => {
                      setLoading(false);
                      message.success('修改成功');
                      pwdForm.resetFields();
                    })
                    .catch(() => {
                      setLoading(false);
                    });
                }}
              >
                <Form.Item label="旧密码" className="detail-form-item" name="oldPwd" rules={[{ required: true }]}>
                  <Input.Password placeholder="请输入旧密码" />
                </Form.Item>
                <Form.Item
                  label="新密码"
                  className="detail-form-item"
                  name="newPwd"
                  rules={[{ required: true }, pwdPatternValidateItem]}
                >
                  <Input.Password placeholder="请输入新密码" />
                </Form.Item>
                <Form.Item
                  label="确认新密码"
                  className="detail-form-item"
                  name="surePwd"
                  rules={[{ required: true }, { validator: validateSurePassword }, pwdPatternValidateItem]}
                >
                  <Input.Password placeholder="请再次输入新密码" />
                </Form.Item>
                <Form.Item>
                  <Button type="primary" loading={loading} htmlType="submit">
                    确认修改
                  </Button>
                </Form.Item>
              </Form>
            </Card>
          )}
        </Col>
      </Row>
    </div>
  );
};

export default ProfilePage;
