import { type RouteObject } from 'react-router-dom';
import Login from '@/pages/accounts/login';
import AdminLayout from '@/layout/admin';
import AppLayout from '@/layout/app';
import Home from '@/pages/home';
import Profile from '@/pages/accounts/profile';
import { StaticRoutes } from '@/utils/globalValue.ts';
import ExternalWrapper from '@/components/ExternalWrapper';
import DynamicRouteHandler from '@/router/DynamicRouteHandler';
import NotFound from '@/pages/error/notFound';

const routes: RouteObject[] = [
    {
        path: StaticRoutes.Login,
        element: <Login />,
    },
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
