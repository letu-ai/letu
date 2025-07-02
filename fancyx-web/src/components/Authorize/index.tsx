import { useAuthProvider } from '@/components/AuthProvider';
import { Navigate } from 'react-router';
import { useLocation } from 'react-router-dom';
import React from 'react';

const Authorize = ({ children }: { children: React.ReactNode }) => {
  const { isAuthenticated } = useAuthProvider();
  const location = useLocation();
  const whiteRoutes: string[] = []; //白名单路由

  if (!isAuthenticated) {
    //不在白名单，并且不是登录页，重定向登录页
    if (!whiteRoutes.includes(location.pathname) && location.pathname !== '/auth/login') {
      return <Navigate to="/auth/login" replace state={{ from: location }} />;
    }
  }

  return <>{children}</>;
};

export default Authorize;
