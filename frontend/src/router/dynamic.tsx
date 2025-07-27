import type { RouteObject } from 'react-router-dom';
import React, { lazy } from 'react';
import type { FrontendMenu } from '@/pages/accounts/service';

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
动态路由的逻辑：
1. 搜索pages下所有tsx文件
2. 排除_开头的文件
3. 排除components目录下所有文件
4. layout.tsx 作为该目录下的布局页面
5. index.tsx作为默认页面
6. 如果目录中有route.ts文件，则直接使用route导出的路由，不再搜索这个目录

 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  */

// 获取所有页面文件
const PageKeys = Object.keys(import.meta.glob(['@/pages/**/index.tsx', '@/pages/**/*.tsx'], { eager: true }));
const PagesList = import.meta.glob(['@/pages/**/index.tsx', '@/pages/**/*.tsx']);

// 获取所有自定义路由文件
const RouteKeys = Object.keys(import.meta.glob(['@/pages/**/route.ts'], { eager: true }));
const RoutesList = import.meta.glob(['@/pages/**/route.ts']);

const createElementFromPath = (componentPath: string) => {
  if (!PageKeys.includes(componentPath)) return undefined;

  const LazyComponent = lazy(() => PagesList[componentPath]() as Promise<{ default: React.ComponentType<any> }>);
  
  // 为调试目的，在LazyComponent上添加原始路径信息
  (LazyComponent as any)._componentPath = componentPath;
  
  return React.createElement(LazyComponent);
};

/**
 * 从文件路径提取路由路径
 * @param filePath 文件路径
 * @returns 路由路径
 */
const extractRoutePathFromFile = (filePath: string): string => {
  // 移除各种可能的前缀和文件扩展名
  let routePath = filePath
    .replace('@/pages', '')
    .replace('/src/pages', '')
    .replace('src/pages', '')
    .replace(/\.(tsx|ts)$/, '');

  // 将 /index 替换为空字符串（作为默认页面）
  routePath = routePath.replace(/\/index$/, '');

  // 确保路径以 / 开头
  if (!routePath.startsWith('/')) {
    routePath = '/' + routePath;
  }

  // 如果是根路径，返回 /
  return routePath === '' ? '/' : routePath;
};

/**
 * 检查文件是否应该被排除
 * @param filePath 文件路径
 * @returns 是否应该排除
 */
const shouldExcludeFile = (filePath: string): boolean => {
  // 排除以 _ 开头的文件
  if (filePath.includes('/_')) {
    return true;
  }

  // 排除 components 目录下的文件
  if (filePath.includes('/components/')) {
    return true;
  }

  // 排除 layout.tsx 文件（布局文件单独处理）
  if (filePath.endsWith('/layout.tsx')) {
    return true;
  }

  return false;
};

/**
 * 获取目录的布局组件
 * @param dirPath 目录路径
 * @returns 布局组件路径或undefined
 */
const getLayoutForDirectory = (dirPath: string): string | undefined => {
  const layoutPath = `@/pages${dirPath}/layout.tsx`;
  return PageKeys.includes(layoutPath) ? layoutPath : undefined;
};

/**
 * 检查目录是否有自定义路由文件
 * @param dirPath 目录路径
 * @returns 是否有自定义路由
 */
const hasCustomRoute = (dirPath: string): boolean => {
  const routePath = `@/pages${dirPath}/route.ts`;
  return RouteKeys.includes(routePath);
};

/**
 * 加载自定义路由配置
 * @param dirPath 目录路径
 * @returns 自定义路由配置或undefined
 */
const loadCustomRoute = async (dirPath: string): Promise<RouteObject[] | undefined> => {
  const routePath = `@/pages${dirPath}/route.ts`;
  if (!RouteKeys.includes(routePath)) {
    return undefined;
  }
  
  try {
    const routeModule = await RoutesList[routePath]() as any;
    // 假设 route.ts 文件导出一个名为 routes 的数组或者默认导出
    return routeModule.routes || routeModule.default || [];
  } catch (error) {
    console.warn(`加载自定义路由失败: ${routePath}`, error);
    return undefined;
  }
};

/**
 * 获取目录的所有子目录
 * @param filePaths 文件路径数组
 * @returns 目录路径数组
 */
const getDirectories = (filePaths: string[]): string[] => {
  const directories = new Set<string>();
  
  filePaths.forEach(filePath => {
    const dirPath = filePath.replace('@/pages', '').replace(/\/[^/]+\.(tsx|ts)$/, '');
    if (dirPath) {
      // 添加所有层级的目录
      const parts = dirPath.split('/').filter(Boolean);
      for (let i = 1; i <= parts.length; i++) {
        const dir = '/' + parts.slice(0, i).join('/');
        directories.add(dir);
      }
    }
  });
  
  return Array.from(directories).sort();
};

/**
 * 根据文件路径生成路由对象
 * @param filePaths 文件路径数组
 * @returns 路由对象数组
 */
const generateRoutesFromFiles = async (filePaths: string[]): Promise<RouteObject[]> => {
  const routes: RouteObject[] = [];
  const routeMap = new Map<string, RouteObject>();
  const processedDirs = new Set<string>();
  
  // 获取所有目录并检查是否有自定义路由
  const directories = getDirectories(filePaths);
  
  // 首先处理有自定义路由的目录
  for (const dirPath of directories) {
    if (hasCustomRoute(dirPath)) {
      const customRoutes = await loadCustomRoute(dirPath);
      if (customRoutes && customRoutes.length > 0) {
        routes.push(...customRoutes);
        processedDirs.add(dirPath);
        
        // 标记该目录的所有子目录也已处理（不再搜索）
        directories.forEach(dir => {
          if (dir.startsWith(dirPath + '/')) {
            processedDirs.add(dir);
          }
        });
      }
    }
  }
  
  // 过滤并处理文件路径
  const validFiles = filePaths.filter(path => {
    if (shouldExcludeFile(path)) {
      return false;
    }
    
    // 检查文件所在目录是否已被自定义路由处理
    const fileDirPath = path.replace('@/pages', '').replace(/\/[^/]+\.tsx$/, '');
    return !processedDirs.has(fileDirPath);
  });
  
  validFiles.forEach(filePath => {
    const routePath = extractRoutePathFromFile(filePath);
    const element = createElementFromPath(filePath);
    
    if (element) {
      const route: RouteObject = {
        path: routePath,
        element: element,
      };
      
      // 检查是否有布局文件
      const dirPath = filePath.replace('@/pages', '').replace(/\/[^/]+\.tsx$/, '');
      const layoutPath = getLayoutForDirectory(dirPath);
      
      if (layoutPath && !processedDirs.has(dirPath)) {
        const layoutElement = createElementFromPath(layoutPath);
        if (layoutElement) {
          // 如果有布局，将当前路由作为子路由
          const existingLayoutRoute = routeMap.get(dirPath);
          if (existingLayoutRoute) {
            if (!existingLayoutRoute.children) {
              existingLayoutRoute.children = [];
            }
            existingLayoutRoute.children.push(route);
          } else {
            const layoutRoute: RouteObject = {
              path: dirPath || '/',
              element: layoutElement,
              children: [route]
            };
            routeMap.set(dirPath, layoutRoute);
            routes.push(layoutRoute);
          }
        } else {
          routes.push(route);
        }
      } else {
        routes.push(route);
      }
    }
  });
  
  return routes;
};


/**
 * 从文件路径提取组件名称
 * @param filePath 文件路径
 * @returns 组件名称
 */
const extractComponentNameFromPath = (filePath: string): string => {
  if (!filePath) return 'Unknown';
  
  // 移除 @/pages 前缀
  let componentName = filePath.replace('@/pages', '');
  
  // 移除文件扩展名
  componentName = componentName.replace(/\.(tsx|ts)$/, '');
  
  // 处理 index 文件，使用目录名
  if (componentName.endsWith('/index')) {
    componentName = componentName.replace('/index', '');
  }
  
  // 移除开头的斜杠
  componentName = componentName.replace(/^\//, '');
  
  // 将路径转换为组件名格式
  componentName = componentName
    .split('/')
    .map(part => part.charAt(0).toUpperCase() + part.slice(1))
    .join('');
  
  return componentName || 'Root';
};

/**
 * 调试函数：打印路由结构
 * @param routes 路由对象数组
 * @param level 缩进级别
 */
const debugPrintRoutes = (routes: RouteObject[], level: number = 0): void => {
  const indent = '  '.repeat(level);
  
  routes.forEach(route => {
    const routePath = route.path || '/';
    
    if (route.element) {
      // 尝试获取文件路径
      const elementType = (route.element as any)?.type;
      
      if (elementType?._componentPath) {
        // 简化文件路径显示，移除 @/pages/ 前缀
        const filePath = elementType._componentPath.replace('@/pages/', '');
        console.log(`${indent}${routePath} (${filePath})`);
      } else {
        console.log(`${indent}${routePath}`);
      }
    } else {
      console.log(`${indent}${routePath}`);
    }
    
    if (route.children && route.children.length > 0) {
      debugPrintRoutes(route.children, level + 1);
    }
  });
};

/**
 * 生成动态路由
 * @returns 路由对象数组的Promise
 */
export const generateDynamicRoutes = async (): Promise<RouteObject[]> => {
  // 基于文件系统生成路由
  const routes = await generateRoutesFromFiles(PageKeys);
  
  // 调试模式下打印路由结构
  // if (process.env.NODE_ENV === 'development') {
  //   console.group('🚀 动态路由生成结果:');
  //   console.log(`📁 扫描到的页面文件数量: ${PageKeys.length}`);
  //   console.log(`📁 扫描到的自定义路由文件数量: ${RouteKeys.length}`);
  //   console.log(`🛣️  生成的路由数量: ${routes.length}`);
  //   console.log('🗂️  路由结构:');
  //   debugPrintRoutes(routes);
  //   console.groupEnd();
  // }
  
  return routes;
};

/**
 * 手动调试函数：随时打印当前路由结构
 */
export const debugRoutes = async (): Promise<void> => {
  const routes = await generateDynamicRoutes();
  console.group('🔍 手动调试 - 当前路由结构:');
  debugPrintRoutes(routes);
  console.groupEnd();
};
