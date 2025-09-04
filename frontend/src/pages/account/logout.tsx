import { useLocation, createFileRoute, useNavigate } from '@tanstack/react-router';
import { Spin } from 'antd';
import { clearToken } from '@/utils/authUtils';
import { useAppConfig } from '@/components/AppConfigProvider';
import { logout } from './-service';
import { StaticRoutes } from '@/utils/globalValue';
import { z } from 'zod';
import { useAsyncEffect } from 'ahooks';

export const Route = createFileRoute('/account/logout')({
    component: LogoutPage,
    validateSearch: z.object({
        returnUrl: z.string().optional(),
    })
});

function LogoutPage() {
    const { clearConfiguration } = useAppConfig();
    const location = useLocation();
    const navigate = useNavigate();
    
    useAsyncEffect(async () => {
        try {
            // 调用后端注销接口
            await logout();
        }
        finally {
            // 清除identityStore中的token
            clearToken();

            // 清除configStore中的配置
            clearConfiguration();

            // 跳转到登录页面
            const loginUrl = StaticRoutes.login;
            const returnUrl = location.search?.returnUrl;
            
            if (returnUrl) {
                // 如果有返回URL，则带上returnUrl参数
                navigate({ to: `${loginUrl}?returnUrl=${encodeURIComponent(returnUrl)}` });
            } else {
                // 直接跳转到登录页面
                navigate({ to: loginUrl });
            }
        }
    }, []);

    return (
        <div className="flex justify-center items-center h-screen flex-col gap-4">
            <Spin size="large" />
        </div>
    );
}
