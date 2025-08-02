import type { RouteObject } from 'react-router-dom';
import React, { lazy } from 'react';

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
动态路由的逻辑：
1. 搜索pages下所有tsx文件
2. 排除_开头的文件
3. 排除components目录下所有文件
4. layout.tsx 作为该目录下的布局页面
5. index.tsx作为默认页面
6. 如果目录中有route.tsx文件，则直接使用route导出的路由，不再搜索这个目录
7. 文件名中包含$的文件，作为动态路由，例如items.$dictType.tsx，则作为动态路由，路径为/items/:dictType

 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  */

// 获取所有页面文件
const PageKeys = Object.keys(import.meta.glob(['/src/pages/**/index.tsx', '/src/pages/**/*.tsx'], { eager: true }));
const PagesList = import.meta.glob(['/src/pages/**/index.tsx', '/src/pages/**/*.tsx']);

// 获取所有自定义路由文件
const RouteKeys = Object.keys(import.meta.glob(['/src/pages/**/route.tsx'], { eager: true }));
const RoutesList = import.meta.glob(['/src/pages/**/route.tsx']);

const createElementFromPath = (componentPath: string) => {
  if (!PageKeys.includes(componentPath)) return undefined;

  const LazyComponent = lazy(() => PagesList[componentPath]() as Promise<{ default: React.ComponentType<any> }>);
  
  // 为调试目的，在LazyComponent上添加原始路径信息
  (LazyComponent as any)._componentPath = componentPath;
  
  return React.createElement(LazyComponent);
};

/**
 * 处理动态路由段，将$符号转换为:符号
 * @param segment 路径段
 * @returns 处理后的路径段
 */
const processDynamicRouteSegment = (segment: string): string => {
  // 如果段不包含$，则保持不变
  if (!segment.includes('$')) {
    return segment;
  }
  
  // 情况1: 纯$paramName格式，如$dictType
  if (segment.startsWith('$')) {
    return ':' + segment.substring(1);
  }
  
  // 情况2: 包含$的复合格式，如items.$dictType
  const parts = segment.split('.');
  let result = '';
  
  parts.forEach((part, index) => {
    if (part.startsWith('$')) {
      // $paramName部分转为/:paramName
      result += '/:' + part.substring(1);
    } else if (index === 0) {
      // 第一部分直接使用
      result = part;
    } else {
      // 其他非动态部分，添加为子路径
      result += '/' + part;
    }
  });
  
  return result;
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
    .replace(/\.tsx$/, '');

  // 将 /index 替换为空字符串（作为默认页面）
  routePath = routePath.replace(/\/index$/, '');

  // 处理动态路由：将文件名中的 $paramName 转换为 :paramName
  const segments = routePath.split('/');
  const processedSegments = segments.map(processDynamicRouteSegment);
  
  // 重新组合路径
  routePath = processedSegments.join('/');

  // 确保路径以 / 开头
  if (!routePath.startsWith('/')) {
    routePath = '/' + routePath;
  }

  // 如果是根路径，返回 /
  return routePath === '' ? '/' : routePath;
}

/**
 * 检查文件是否应该被排除（用于初始过滤）
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

  // 排除 route.tsx 文件（自定义路由文件）
  if (filePath.endsWith('/route.tsx')) {
    return true;
  }

  return false;
};

/**
 * 检查文件是否应该作为页面路由（排除layout文件）
 * @param filePath 文件路径
 * @returns 是否应该作为页面路由
 */
const shouldBePageRoute = (filePath: string): boolean => {
  // layout.tsx 文件不作为页面路由，但需要用于构建layout结构
  if (filePath.endsWith('/layout.tsx')) {
    return false;
  }
  
  return true;
};



/**
 * 检查目录是否有自定义路由文件
 * @param dirPath 目录路径
 * @returns 是否有自定义路由
 */
const hasCustomRoute = (dirPath: string): boolean => {
  const routePath = `/src/pages${dirPath}/route.tsx`;
  return RouteKeys.includes(routePath);
};

/**
 * 加载自定义路由配置
 * @param dirPath 目录路径
 * @returns 自定义路由配置或undefined
 */
const loadCustomRoute = async (dirPath: string): Promise<RouteObject[] | undefined> => {
  const routePath = `/src/pages${dirPath}/route.tsx`;
  if (!RouteKeys.includes(routePath)) {
    return undefined;
  }
  
  try {
    const routeModule = await RoutesList[routePath]() as any;
    // 假设 route.tsx 文件导出一个名为 routes 的数组或者默认导出
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
    const dirPath = filePath
      .replace('/src/pages', '')
      .replace('@/pages', '')
      .replace(/\/[^/]+\.(tsx|ts)$/, '');
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
 * 构建层级结构的路由树
 * @param filePaths 文件路径数组
 * @returns 路由对象数组
 */
const generateRoutesFromFiles = async (filePaths: string[]): Promise<RouteObject[]> => {
  const finalRoutes: RouteObject[] = [];
  const customRouteDirs = new Set<string>();

  // 1. Load all custom routes first and mark their directories.
  const directories = getDirectories(filePaths);
  for (const dirPath of directories) {
    if (hasCustomRoute(dirPath)) {
      customRouteDirs.add(dirPath);
      const customRoutes = await loadCustomRoute(dirPath);
      if (customRoutes) {
        finalRoutes.push(...customRoutes);
      }
    }
  }

  // 2. Filter out files handled by custom routes or should be excluded
  const routableFiles = filePaths.filter(path => {
    if (shouldExcludeFile(path)) {
      return false;
    }

    const fileDir = path.substring(0, path.lastIndexOf('/'));
    for (const customDir of customRouteDirs) {
      const customDirPath = `/src/pages${customDir}`;
      if (fileDir.startsWith(customDirPath)) {
        return false;
      }
    }
    
    return true;
  });

  // 3. Build hierarchical route structure
  const routeTree = buildRouteTree(routableFiles);
  finalRoutes.push(...routeTree);

  return finalRoutes;
};

/**
 * 构建层级路由树
 * @param filePaths 文件路径数组
 * @returns 路由树
 */
const buildRouteTree = (filePaths: string[]): RouteObject[] => {
  // 按目录分组文件
  const dirToFileMap = new Map<string, string[]>();
  filePaths.forEach(path => {
    const dir = path.substring(0, path.lastIndexOf('/'));
    if (!dirToFileMap.has(dir)) {
      dirToFileMap.set(dir, []);
    }
    dirToFileMap.get(dir)!.push(path);
  });

  // 收集所有layout信息
  const layoutInfo = new Map<string, {
    layoutPath: string;
    dirPath: string;
    depth: number;
  }>();

  dirToFileMap.forEach((files, dir) => {
    const layoutPath = files.find(f => f.endsWith('/layout.tsx'));
    if (layoutPath) {
      const dirPath = dir.replace('/src/pages', '') || '/';
      const depth = dirPath === '/' ? 0 : dirPath.split('/').length - 1;
      layoutInfo.set(dir, {
        layoutPath,
        dirPath,
        depth
      });
    }
  });

  // 按深度排序，确保父layout先处理
  const sortedLayouts = Array.from(layoutInfo.entries())
    .sort(([, a], [, b]) => a.depth - b.depth);

  // 构建层级结构
  const routeMap = new Map<string, RouteObject>();
  const rootRoutes: RouteObject[] = [];

  // 处理所有layout，建立层级关系
  sortedLayouts.forEach(([dir, info]) => {
    const layoutElement = createElementFromPath(info.layoutPath);
    if (!layoutElement) return;

    // 找到父layout
    const parentDir = findParentLayoutDir(dir, layoutInfo);
    
    // 计算layout的路径
    let layoutRoutePath: string;
    if (!parentDir) {
      // 没有父layout，使用完整路径（作为根layout）
      layoutRoutePath = info.dirPath;
    } else {
      // 有父layout，计算相对路径（作为子layout）
      const parentDirPath = layoutInfo.get(parentDir)!.dirPath;
      layoutRoutePath = calculateRelativePath(info.dirPath, parentDirPath);
    }

    const route: RouteObject = {
      path: layoutRoutePath,
      element: layoutElement,
      children: []
    };

    routeMap.set(dir, route);
    if (parentDir && routeMap.has(parentDir)) {
      // 添加到父layout的children中
      routeMap.get(parentDir)!.children!.push(route);
    } else {
      // 根level的layout
      rootRoutes.push(route);
    }
  });

  // 处理非layout文件，分配到对应的layout下
  dirToFileMap.forEach((files, dir) => {
    const pageFiles = files.filter(f => shouldBePageRoute(f));
    
    pageFiles.forEach(filePath => {
      const targetDir = findNearestLayoutDir(dir, layoutInfo);
      const routePath = extractRoutePathFromFile(filePath);

      if (targetDir && routeMap.has(targetDir)) {
        // 计算相对于目标layout的相对路径
        const layoutDirPath = layoutInfo.get(targetDir)!.dirPath;
        const relativePath = calculateRelativePath(routePath, layoutDirPath);
        
        routeMap.get(targetDir)!.children!.push({
          path: relativePath,
          element: createElementFromPath(filePath)
        });
      } else {
        // 没有layout的页面，添加到根级别
        rootRoutes.push({
          path: routePath,
          element: createElementFromPath(filePath)
        });
      }
    });
  });

  return rootRoutes;
};



/**
 * 查找最近的父layout目录
 * @param currentDir 当前目录
 * @param layoutInfo layout信息映射
 * @returns 父layout目录或undefined
 */
const findParentLayoutDir = (
  currentDir: string, 
  layoutInfo: Map<string, any>
): string | undefined => {
  const currentDirPath = currentDir.replace('/src/pages', '');
  const currentSegments = currentDirPath.split('/').filter(Boolean);

  // 从当前目录向上查找，寻找父layout
  for (let i = currentSegments.length - 1; i >= 0; i--) {
    const parentPath = '/' + currentSegments.slice(0, i).join('/');
    const parentDir = `/src/pages${parentPath === '/' ? '' : parentPath}`;
    
    if (layoutInfo.has(parentDir) && parentDir !== currentDir) {
      return parentDir;
    }
  }

  return undefined;
};

/**
 * 查找最近的layout目录（包括当前目录和父目录）
 * @param currentDir 当前目录
 * @param layoutInfo layout信息映射
 * @returns layout目录或undefined
 */
const findNearestLayoutDir = (
  currentDir: string,
  layoutInfo: Map<string, any>
): string | undefined => {
  // 首先检查当前目录是否有layout
  if (layoutInfo.has(currentDir)) {
    return currentDir;
  }

  // 向上查找父目录的layout
  const currentDirPath = currentDir.replace('/src/pages', '');
  const currentSegments = currentDirPath.split('/').filter(Boolean);

  for (let i = currentSegments.length - 1; i >= 0; i--) {
    const parentPath = '/' + currentSegments.slice(0, i).join('/');
    const parentDir = `/src/pages${parentPath === '/' ? '' : parentPath}`;
    
    if (layoutInfo.has(parentDir)) {
      return parentDir;
    }
  }

  return undefined;
};

/**
 * 计算相对于layout的相对路径
 * @param fullPath 完整路径
 * @param layoutPath layout路径
 * @returns 相对路径
 */
const calculateRelativePath = (fullPath: string, layoutPath: string): string => {
  if (layoutPath === '/') {
    return fullPath.substring(1); // 去掉开头的 /
  }

  if (fullPath.startsWith(layoutPath + '/')) {
    return fullPath.substring(layoutPath.length + 1);
  }

  if (fullPath === layoutPath) {
    return '';
  }

  return fullPath;
};

/**
 * 调试函数：打印路由结构
 * @param routes 路由对象数组
 * @param level 缩进级别
 */
const debugPrintRoutes = (routes: RouteObject[], level: number = 0, parentPath: string = ''): void => {
  const indent = '  '.repeat(level);

  routes.forEach(route => {
    const currentPathSegment = route.path || '';
    
    let fullPath: string;
    if (level === 0) {
      // 根级路由，直接使用当前路径段
      fullPath = currentPathSegment;
    } else {
      // 子路由，需要拼接
      const basePath = parentPath === '/' ? '' : parentPath;
      fullPath = currentPathSegment ? `${basePath}/${currentPathSegment}` : basePath;
    }
    
    // 清理多余的斜杠，例如 '//' 或者结尾的 '/' (根路径除外)
    fullPath = fullPath.replace(/\/+/g, '/');
    if (fullPath !== '/' && fullPath.endsWith('/')) {
      fullPath = fullPath.slice(0, -1);
    }
    
    // 检查是否是layout路由
    const isLayoutRoute = route.children && route.children.length > 0;
    const layoutIndicator = isLayoutRoute ? ' 📁' : '';
    
    let logMessage = `${indent}${fullPath || '/'}${layoutIndicator}`;

    if (route.element) {
      const elementType = (route.element as any)?.type;
      
      if (elementType?._componentPath) {
        // 文件约定路由: 显示源文件路径
        const filePath = elementType._componentPath.replace('/src/pages/', '');
        logMessage += ` (${filePath})`;
      } else if (elementType) {
        // 自定义路由: 显示组件名称
        const componentName = elementType.displayName || elementType.name || 'Component';
        logMessage += ` (${componentName})`;
      }
    }
    
    console.log(logMessage);
    
    if (route.children && route.children.length > 0) {
      // 传递当前计算出的完整路径给子节点
      debugPrintRoutes(route.children, level + 1, fullPath);
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
  if (process.env.NODE_ENV === 'development') {
    console.group('🚀 动态路由生成结果:');
    console.log(`📁 扫描到的页面文件数量: ${PageKeys.length}`);
    console.log(`📁 扫描到的自定义路由文件数量: ${RouteKeys.length}`);
    console.log(`🛣️  生成的路由数量: ${routes.length}`);
    console.log('🗂️  路由结构:');
    debugPrintRoutes(routes);
    console.groupEnd();
  }
  
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
