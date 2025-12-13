import { Card, Button, Result, Divider, Alert } from 'antd';
import { ExclamationCircleTwoTone } from '@ant-design/icons';
import { useState } from 'react';
import { createFileRoute, useNavigate } from '@tanstack/react-router';
import { clearToken, setTenantId } from '@/utils/authUtils';
import SwitchTenantModel from './-SwitchTenantModel';

export const Route = createFileRoute('/account/tenant-error')({
    component: TenantInvalidPage,
});

function TenantInvalidPage() {
    const navigate = useNavigate();
    const [switchTenantModelVisible, setSwitchTenantModelVisible] = useState(false);

    const handleSwitchTenant = () => {
        setSwitchTenantModelVisible(true);
    }

    const handleSwitchTenantClose = () => {
        setSwitchTenantModelVisible(false);
    }
    
    const handleSwitchTenantOk = () => {
        setSwitchTenantModelVisible(false);
    }

    const handleClearTenant = () => {
        // 清空当前认证信息
        clearToken();
        setTenantId(null, '');
        // 跳转到登录页
        navigate({ to: '/account/login', search: { returnUrl: '/' } });
    }

    const handleBackToLogin = () => {
        navigate({ to: '/account/login', search: { returnUrl: '/' } });
    }

    return (
        <div className="container mx-auto h-screen flex items-center justify-center">
            <Card className="max-w-lg mx-auto">
                <Result
                    icon={<ExclamationCircleTwoTone twoToneColor='red' />}
                    title="租户错误"
                    subTitle="当前访问的租户被禁用或不存在，请重新选择租户或联系管理员。"
                    extra={[
                        <Button type="primary" key="switch" onClick={handleSwitchTenant}>
                            切换租户
                        </Button>,
                        <Button key="clear" onClick={handleClearTenant}>
                            清空租户信息
                        </Button>,
                        <Button key="back" onClick={handleBackToLogin}>
                            返回登录
                        </Button>
                    ]}
                />

                <Divider />

                <Alert
                    type="info"
                    title="可能的解决方案："
                    description={
                        <ul>
                            <li>点击"切换租户"选择正确的租户</li>
                            <li>点击"清空租户信息"清除错误的租户配置</li>
                            <li>联系系统管理员确认租户配置是否正确</li>
                        </ul>
                    }
                />
            </Card>


            <SwitchTenantModel
                visible={switchTenantModelVisible}
                onClose={handleSwitchTenantClose}
                onOk={handleSwitchTenantOk}
            />
        </div>
    );
}