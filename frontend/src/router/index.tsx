import { type RouteObject } from 'react-router-dom';
import Login from '@/pages/account/login';
import AdminLayout from '@/layout/admin';
import AppLayout from '@/layout/app';
import AccountLayout from '@/layout/account';
import Home from '@/pages/home';
import Profile from '@/pages/account/profile';
import ExternalWrapper from '@/components/ExternalWrapper';
import DynamicRouteHandler from '@/router/DynamicRouteHandler';
import NotFound from '@/pages/error/notFound';

const routes: RouteObject[] = [

    {
        path: '/',
        children: [
            {
                path: '',
                element: <AppLayout />,
                children: [
                    {
                        path: '',
                        element: <Home />,
                    },
                ]
            },
            {
                path: "account",
                element: <AccountLayout />,
                children: [
                    {
                        // 动态路由处理器 - 处理所有剩余的路径
                        path: '*',
                        element: <DynamicRouteHandler pathPrefix="account" />,
                    }
                ]
            },
            {
                path: "admin",
                element: <AdminLayout />,
                children: [
                    {
                        path: '',
                        element: <Home />,
                    },
                    {
                        path: 'profile',
                        element: <Profile />,
                    },
                    {
                        path: 'external/*',
                        element: <ExternalWrapper />,
                    },
                    {
                        // 动态路由处理器 - 处理所有剩余的路径
                        path: '*',
                        element: <DynamicRouteHandler pathPrefix="admin" />,
                    },
                ]
            },
            {
                path: "*",
                element: <NotFound />,
            }
        ]
    },
];

export { routes };
