/**
 * 认证状态管理（Zustand + AsyncStorage）
 */
import { create } from 'zustand';
import { storage } from '../utils/storage';
import type { IUserTokenOutput } from '@/pages/auth/service';

interface AuthState {
  isAuthenticated: boolean;
  accessToken: string | null;
  refreshToken: string | null;
  tokenExpiredTime: Date | null;
  user: {
    userName?: string;
    nickName?: string;
    avatar?: string;
  } | null;

  // Actions
  login: (tokenData: IUserTokenOutput, rememberMe?: boolean) => Promise<void>;
  logout: () => Promise<void>;
  setUser: (user: AuthState['user']) => void;
  initialize: () => Promise<void>;
}

export const useAuthStore = create<AuthState>((set, get) => ({
  isAuthenticated: false,
  accessToken: null,
  refreshToken: null,
  tokenExpiredTime: null,
  user: null,

  login: async (tokenData: IUserTokenOutput, rememberMe = false) => {
    await storage.setAccessToken(tokenData.accessToken);
    if (tokenData.refreshToken) {
      await storage.setRefreshToken(tokenData.refreshToken);
    }
    if (tokenData.expiredTime) {
      await storage.setTokenExpiredTime(new Date(tokenData.expiredTime));
    }

    set({
      isAuthenticated: true,
      accessToken: tokenData.accessToken,
      refreshToken: tokenData.refreshToken || null,
      tokenExpiredTime: tokenData.expiredTime ? new Date(tokenData.expiredTime) : null,
    });
  },

  logout: async () => {
    await storage.clearTokens();
    await storage.clearRememberMe();

    set({
      isAuthenticated: false,
      accessToken: null,
      refreshToken: null,
      tokenExpiredTime: null,
      user: null,
    });
  },

  setUser: (user) => {
    set({ user });
  },

  initialize: async () => {
    const accessToken = await storage.getAccessToken();
    const refreshToken = await storage.getRefreshToken();
    const expiredTime = await storage.getTokenExpiredTime();

    if (accessToken) {
      set({
        isAuthenticated: true,
        accessToken,
        refreshToken,
        tokenExpiredTime: expiredTime,
      });
    }
  },
}));

