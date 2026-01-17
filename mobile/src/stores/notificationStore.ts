/**
 * 通知状态管理（Zustand）
 */
import { create } from 'zustand';
import { getMyNotificationNavbarInfo } from '@/api/notification';

interface NotificationState {
  unreadCount: number;
  isLoading: boolean;
  shouldRefresh: boolean; // 标记是否需要刷新列表

  // Actions
  fetchUnreadCount: () => Promise<void>;
  setUnreadCount: (count: number) => void;
  decreaseUnreadCount: (count: number) => void;
  markShouldRefresh: () => void;
  clearShouldRefresh: () => void;
}

export const useNotificationStore = create<NotificationState>((set, get) => ({
  unreadCount: 0,
  isLoading: false,
  shouldRefresh: false,

  /**
   * 从后端获取未读计数
   */
  fetchUnreadCount: async () => {
    try {
      set({ isLoading: true });
      const data = await getMyNotificationNavbarInfo();
      set({ unreadCount: data.unreadCount, isLoading: false });
    } catch (error) {
      console.error('获取未读计数失败:', error);
      set({ isLoading: false });
    }
  },

  /**
   * 设置未读计数
   */
  setUnreadCount: (count: number) => {
    set({ unreadCount: Math.max(0, count) });
  },

  /**
   * 减少未读计数（乐观更新）
   */
  decreaseUnreadCount: (count: number = 1) => {
    const currentCount = get().unreadCount;
    set({ unreadCount: Math.max(0, currentCount - count) });
  },

  /**
   * 标记需要刷新列表
   */
  markShouldRefresh: () => {
    set({ shouldRefresh: true });
  },

  /**
   * 清除刷新标记
   */
  clearShouldRefresh: () => {
    set({ shouldRefresh: false });
  },
}));
