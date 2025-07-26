import type { RouteObject } from 'react-router-dom';
import React, { lazy } from 'react';
import type { FrontendMenu } from '@/pages/accounts/service';

// 获取所有页面文件
const PageKeys = Object.keys(import.meta.glob(['@/pages/**/index.tsx', '@/pages/**/*.tsx'], { eager: true }));
const PagesList = import.meta.glob(['@/pages/**/index.tsx', '@/pages/**/*.tsx']);

const createElementFromPath = (componentPath: string) => {
  if (!PageKeys.includes(componentPath)) return undefined;

  const LazyComponent = lazy(() => PagesList[componentPath]() as Promise<{ default: React.ComponentType<any> }>);
  return React.createElement(LazyComponent);
};

const convertMenuToRoutes = (menus: FrontendMenu[]): RouteObject[] => {
  return menus.map((menu) => {
    const componentPath = `/src/pages/${menu.component}.tsx`;
    const route: RouteObject = {
      path: menu.path,
      element: !menu.isExternal ? createElementFromPath(componentPath) : undefined,
    };

    if (menu.children?.length) {
      route.children = convertMenuToRoutes(menu.children);
    }

    return route;
  });
};

export const generateDynamicRoutes = (apiRoutes: FrontendMenu[]) => {
  if (apiRoutes.length <= 0) return [];
  return convertMenuToRoutes(apiRoutes);
};
