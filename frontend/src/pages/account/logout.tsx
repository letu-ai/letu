import { useLocation, useNavigate } from '@tanstack/react-router';
import { Spin } from 'antd';
import { clearToken } from '@/utils/authUtils';
import useAppConfigStore from '@/application/appConfigStore';
import { logout } from './-service';
import { StaticRoutes } from '@/utils/globalValue';
import { createFileRoute } from '@tanstack/react-router';
import { z } from 'zod';
import { useAsyncEffect } from 'ahooks';

export const Route = createFileRoute('/account/logout')({
    component: LogoutPage,
    validateSearch: z.object({
        returnUrl: z.string().optional(),
    })
});

function LogoutPage() {
    const navigate = useNavigate();
    const clearConfiguration = useAppConfigStore(state => state.clearConfiguration);
    const location = useLocation();
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

            // 跳转到首页
            await navigate({ to: StaticRoutes.login, search: { returnUrl: location.search.returnUrl }, replace: true });
        }
    }, []);

    return (
        <div className="flex justify-center items-center h-screen flex-col gap-4">
            <Spin size="large" />
        </div>
    );
}
