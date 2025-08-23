import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Spin } from 'antd';
import { clearToken } from '@/application/authUtils';
import useAppConfigStore from '@/application/appConfigStore';
import { logout } from './service';
import { StaticRoutes } from '@/utils/globalValue';

const LogoutPage = () => {
  const navigate = useNavigate();
  const clearConfiguration = useAppConfigStore(state => state.clearConfiguration);

  useEffect(() => {
    const handleLogout = async () => {
      try {
        // 调用后端注销接口
        await logout();
      } catch (error) {
      } finally {
        // 清除identityStore中的token
        clearToken();
        
        // 清除configStore中的配置
        clearConfiguration();
        
        // 跳转到首页
        navigate(StaticRoutes.login, { replace: true });
      }
    };

    handleLogout();
  }, [navigate, clearConfiguration]);

  return (
    <div className="flex justify-center items-center h-screen flex-col gap-4">
      <Spin size="large" tip="正在注销..." />
    </div>
  );
};

export default LogoutPage;