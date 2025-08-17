import React, { useState, useEffect } from 'react';
import { useRoutes } from 'react-router-dom';
import { Spin } from 'antd';
import { generateDynamicRoutes } from '@/router/dynamic';
import NotFound from '@/pages/error/notFound';
import type { RouteObject } from 'react-router-dom';

interface DynamicRouteHandlerProps {
  /**
   * 路径前缀，用于限制动态路由的范围
   * 例如: "admin" 表示只处理 pages/admin 下的文件
   */
  pathPrefix?: string;
}

/**
 * 动态路由处理组件
 */
const DynamicRouteHandler: React.FC<DynamicRouteHandlerProps> = ({ pathPrefix }) => {
  const [dynamicRoutes, setDynamicRoutes] = useState<RouteObject[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [hasError, setHasError] = useState(false);

  useEffect(() => {
    const loadDynamicRoutes = async () => {
      try {
        setIsLoading(true);
        setHasError(false);
        
        const routes = await generateDynamicRoutes(pathPrefix);
        setDynamicRoutes(routes);
      } catch (error) {
        console.error('加载动态路由失败:', error);
        setHasError(true);
        setDynamicRoutes([]);
      } finally {
        setIsLoading(false);
      }
    };

    loadDynamicRoutes();
  }, [pathPrefix]);

  const routeElement = useRoutes(dynamicRoutes);

  if (isLoading) {
    return (
      <div
        style={{
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
          height: '200px',
        }}
      >
        <Spin size="large" />
        <span style={{ marginLeft: 12 }}>加载动态路由中...</span>
      </div>
    );
  }

  if (hasError) {
    return (
      <div
        style={{
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
          height: '200px',
          flexDirection: 'column',
        }}
      >
        <p>动态路由加载失败</p>
        <button 
          onClick={() => window.location.reload()}
          style={{
            padding: '8px 16px',
            border: '1px solid #d9d9d9',
            borderRadius: '4px',
            background: '#fff',
            cursor: 'pointer'
          }}
        >
          重新加载
        </button>
      </div>
    );
  }

  return routeElement || <NotFound />;
};

export default DynamicRouteHandler;