import type { RouteObject } from "react-router-dom";
import React, { lazy } from "react";
import type { FrontendMenu } from "@/api/auth";

// 获取所有页面文件
const PageKeys = Object.keys(import.meta.glob([
  "@/pages/**/index.tsx",
  "@/pages/**/*.tsx"
], { eager: true }));
const PagesList = import.meta.glob([
  "@/pages/**/index.tsx",
  "@/pages/**/*.tsx"
]);

const getChildrenRoutes = (children: FrontendMenu[]) => {
  const newChildren: RouteObject[] = [];
  children?.forEach((route) => {
    const componentPath = `/src/pages/${route.component}.tsx`;
    const newRoute: RouteObject = {
      path: route.path,
    };
    if (PageKeys.includes(componentPath)) {
      newRoute.element = React.createElement(
        lazy(() => PagesList[componentPath]() as Promise<{ default: React.ComponentType<any> }>)
      );
    }
    if (route.children != null && route.children.length > 0) {
      newRoute.children = getChildrenRoutes(route.children);
    }
    newChildren.push(newRoute);
  });
  return newChildren;
};

export const generateDynamicRoutes = (apiRoutes: FrontendMenu[]) => {
  const dynamicRoutes: RouteObject[] = [];
  apiRoutes?.forEach((route) => {
    const componentPath = `/src/pages/${route.component}.tsx`;
    const newRoute: RouteObject = {
      path: route.path
    };

    if (PageKeys.includes(componentPath)) {
      newRoute.element = React.createElement(
        lazy(() => PagesList[componentPath]() as Promise<{ default: React.ComponentType<any> }>)
      );
    }
    if (route.children != null && route.children.length > 0) {
      newRoute.children = getChildrenRoutes(route.children);
    }
    dynamicRoutes.push(newRoute);
  });
  return dynamicRoutes;
};