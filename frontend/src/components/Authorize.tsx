import React from 'react';
import { isTokenValid } from '@/utils/authUtils';

interface IAuthorizeProps {
    fallback?: React.ReactNode;
    children: React.ReactNode;
}

const Authorize = ({ fallback, children }: IAuthorizeProps) => {

    if (isTokenValid()) {
        return children;
    }
    else {
        return fallback ?? "未认证"
    }
}

export default Authorize;
