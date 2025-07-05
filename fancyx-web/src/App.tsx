import { useRoutes } from 'react-router-dom';
import { routes } from '@/router';
import zhCN from 'antd/locale/zh_CN';
import { ConfigProvider, Spin, theme } from 'antd';
import { Suspense } from 'react';
import { generateDynamicRoutes } from './router/dynamic';
import UserStore from './store/userStore';
import { useSelector } from 'react-redux';
import { selectSize } from '@/store/themeStore.ts';
import { AuthProvider } from '@/components/AuthProvider';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import Application from "@/components/Application";

// 清爽紫色主题配置
const defaultTheme = {
  algorithm: theme.defaultAlgorithm,
  token: {
    colorPrimary: '#7E57C2',
    colorLink: '#7E57C2',
    colorSuccess: '#66BB6A',
    colorWarning: '#FFA726',
    colorError: '#FF7043',
    colorBgBase: '#FFFFFF',
    colorTextBase: '#4A4A4A',
    borderRadius: 4,
    fontSize: 14,
  },
  components: {
    Layout: {
      siderBg: '#FFFFFF',
      headerBg: '#FFFFFF',
    },
    Menu: {
      colorItemBg: '#FFFFFF',
      colorItemText: '#4A4A4A',
      colorItemBgSelected: '#EDE7F6',
      colorItemTextSelected: '#7E57C2',
      colorItemBgHover: '#F5F3FF',
      itemBorderRadius: 8,
    },
    Button: {
      colorPrimary: '#7E57C2',
      colorPrimaryHover: '#9575CD',
      colorPrimaryActive: '#673AB7',
    },
    Table: {
      headerBg: '#F5F3FF',
      headerColor: '#4A4A4A',
      borderColor: '#EDE7F6',
    },
  },
};

function App() {
  const size = useSelector(selectSize);
  const renderRoutes = routes;

  if (UserStore.isAuthenticated()) {
    const menus = UserStore.userInfo?.menus;
    if (Array.isArray(menus) && menus.length > 0) {
      const dyRoutes = generateDynamicRoutes(menus);
      dyRoutes.forEach((dy) => {
        renderRoutes[1].children?.push(dy);
      });
    }
  }

  const fallback = (
    <div
      style={{
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100vh',
      }}
    >
      <Spin />
    </div>
  );

  // 创建 QueryClient 实例（管理缓存和请求）
  const queryClient = new QueryClient();

  return (
    <>
      <AuthProvider>
        <ConfigProvider locale={zhCN} componentSize={size} theme={defaultTheme}>
          <Application>
            <QueryClientProvider client={queryClient}>
              <Suspense fallback={fallback}>{useRoutes(renderRoutes)}</Suspense>
            </QueryClientProvider>
          </Application>
        </ConfigProvider>
      </AuthProvider>
    </>
  );
}

export default App;
