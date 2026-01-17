/**
 * 全局导航服务
 * 用于在非组件上下文中进行导航（如pushService）
 */
import { createNavigationContainerRef, StackActions } from '@react-navigation/native';

export const navigationRef = createNavigationContainerRef();

/**
 * 导航到指定页面
 */
export function navigate(name: string, params?: any) {
  if (navigationRef.isReady()) {
    navigationRef.navigate(name, params);
  } else {
    console.warn('导航未就绪，无法导航到:', name);
  }
}

/**
 * Push到指定页面（确保每次都创建新实例）
 */
export function push(name: string, params?: any) {
  if (navigationRef.isReady()) {
    navigationRef.dispatch(StackActions.push(name, params));
  } else {
    console.warn('导航未就绪，无法Push到:', name);
  }
}

/**
 * 返回上一页
 */
export function goBack() {
  if (navigationRef.isReady() && navigationRef.canGoBack()) {
    navigationRef.goBack();
  }
}
