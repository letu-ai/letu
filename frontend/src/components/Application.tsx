import React, { useEffect } from 'react';
import useAppConfigStore from '@/application/appConfigStore';
import ErrorFallback from '@/components/ErrorFallback';
import LoadingFallback from './LoadingFallback';

interface IApplicationProps {
  app?: string, // 应用名称,用于获取菜单。如果为空表示不需要获取对应app的菜单。
  fallback?: React.ReactNode;
  errorFallback?: React.ReactNode;
  children: React.ReactNode;
}

const Application = ({
  app,
  fallback,
  errorFallback,
  children
}: IApplicationProps) => {
  const loadConfiguration = useAppConfigStore(state => state.loadConfiguration);
  const isReady = useAppConfigStore(state => state.isReady);
  const isLoading = useAppConfigStore(state => state.isLoading);
  const error = useAppConfigStore(state => state.error);

  // 确保配置已加载
  useEffect(() => {
    loadConfiguration(app);
  }, [loadConfiguration, app]);


  // 如果配置加载失败，显示错误状态
  if (error) {
    return errorFallback || (
      <ErrorFallback
        error={error || new Error('应用程序信息加载失败，请刷新重试')}
        resetErrorBoundary={() => loadConfiguration(app)}
      />
    );
  }

  // 如果配置正在加载中，显示加载状态
  if (isLoading) {
    return fallback ?? <LoadingFallback />;
  }

  // 配置加载完成后再检查认证状态
  if (isReady) {
    return children;
  }

  // 默认显示加载状态
  return fallback ?? <LoadingFallback />;
}

export default Application;
