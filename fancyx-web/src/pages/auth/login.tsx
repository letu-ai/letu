import { Card, Form, Input, Button, Checkbox, ConfigProvider } from 'antd';
import { UserOutlined, LockOutlined } from '@ant-design/icons';
import './style/login.scss';
import { type LoginDto } from '@/api/auth.ts';
import { useState } from 'react';
import { useNavigate } from 'react-router';
import LoginBg from '@/assets/login-bg.png';
import { useAuthProvider } from '@/components/AuthProvider';

const LoginPage = () => {
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();
  const { pwdLogin } = useAuthProvider();

  const onFinish = (values: LoginDto) => {
    setLoading(true);
    pwdLogin!(values)
      .then(() => {
        setLoading(false);
        navigate('/');
      })
      .catch(() => {
        setLoading(false);
      });
  };

  return (
    <ConfigProvider
      theme={{
        token: {
          colorPrimary: '#7E57C2',
          borderRadius: 8,
        },
      }}
    >
      <div className="login-container">
        <Card className="login-card" variant="borderless">
          <div className="login-layout">
            {/* 左侧背景图 */}
            <div className="login-bg-side" style={{ backgroundImage: `url(${LoginBg})` }}>
              <div className="bg-overlay">
                <h2>欢迎使用风汐管理系统</h2>
                <p>基于.NET9+React18打造的通用权限管理平台</p>
              </div>
            </div>

            {/* 右侧登录表单 */}
            <div className="login-form-side">
              <div className="form-container">
                <h3 className="form-title">用户登录</h3>

                <Form name="login_form" initialValues={{ remember: true }} onFinish={onFinish} size="large">
                  <Form.Item name="username" rules={[{ required: true, message: '请输入用户名' }]}>
                    <Input prefix={<UserOutlined />} placeholder="用户名" />
                  </Form.Item>

                  <Form.Item name="password" rules={[{ required: true, message: '请输入密码' }]}>
                    <Input.Password prefix={<LockOutlined />} placeholder="密码" />
                  </Form.Item>

                  <Form.Item>
                    <Form.Item name="remember" valuePropName="checked" noStyle>
                      <Checkbox>记住密码</Checkbox>
                    </Form.Item>
                  </Form.Item>

                  <Form.Item>
                    <Button type="primary" htmlType="submit" block loading={loading}>
                      登 录
                    </Button>
                  </Form.Item>
                </Form>
              </div>
            </div>
          </div>
        </Card>
      </div>
    </ConfigProvider>
  );
};

export default LoginPage;
