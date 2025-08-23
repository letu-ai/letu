import { Navigate, useLocation } from 'react-router-dom';
import React from 'react';
import { StaticRoutes } from '@/utils/globalValue.ts';
import { isTokenValid } from '@/application/authUtils';

interface IAuthorizeProps {
  fallback?: React.ReactNode;
  children: React.ReactNode;
}

const Authorize = ({ fallback, children }: IAuthorizeProps) => {
  const location = useLocation();
  
  if(isTokenValid()) {
    return children;
  }

  if (fallback) {
    return fallback
  }
  else {
    const returnUrl = encodeURIComponent(location.pathname + location.search);
    return <Navigate to={`${StaticRoutes.login}?returnUrl=${returnUrl}`} replace={true} />
  }
}

export default Authorize;
