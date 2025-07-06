import { useAuthProvider } from '@/components/AuthProvider';
import { Navigate } from 'react-router';
import { useLocation } from 'react-router-dom';
import React from 'react';
import { StaticRoutes } from '@/utils/globalValue.ts';
import UserStore from '@/store/userStore.ts';

const Authorize = ({ children }: { children: React.ReactNode }) => {
  const { isAuth } = useAuthProvider();
  const location = useLocation();
  const whiteRoutes: string[] = [StaticRoutes.Login]; //白名单路由
  const loginRoute = StaticRoutes.Login;

  //hook存储的状态和localStorage存储的都无效时
  if (!isAuth() && !UserStore.isAuthenticated()) {
    //不在白名单，并且不是登录页，重定向登录页
    if (!whiteRoutes.includes(location.pathname) && location.pathname !== loginRoute) {
      return <Navigate to={loginRoute} replace state={{ from: location }} />;
    }
  }

  return <>{children}</>;
};

export default Authorize;
