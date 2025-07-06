import React, { createContext, useContext } from 'react';
import UserStore, { type TokenInfo } from '@/store/userStore.ts';
import { getUserAuth, login, type LoginDto } from '@/api/auth.ts';

export interface AuthProviderType {
  isAuthenticated: boolean;
  pwdLogin?: (values: LoginDto) => Promise<void>;
  tokenInfo?: TokenInfo | null;
}

const AuthContext = createContext<AuthProviderType>({ isAuthenticated: false });

export const AuthProvider = ({ children }: { children: React.ReactNode }) => {
  const isAuthenticated = UserStore.isAuthenticated();
  const tokenInfo = UserStore.token;

  const pwdLogin = async (values: LoginDto) => {
    const res = await login(values);
    if (res.data) {
      UserStore.setToken({
        sessionId: res.data.sessionId,
        accessToken: res.data.accessToken,
        refreshToken: res.data.refreshToken,
        expiredTime: res.data.expiredTime,
      });
      const { data: authInfo } = await getUserAuth();
      UserStore.setUserInfo({
        userId: authInfo.user.userId,
        userName: authInfo.user.userName,
        nickName: authInfo.user.nickName,
        avatar: authInfo.user.avatar,
        sex: authInfo.user.sex,
        menus: authInfo.menus,
        permissions: authInfo.permissions,
      });
    }
  };

  return <AuthContext.Provider value={{ isAuthenticated, pwdLogin, tokenInfo }}>{children}</AuthContext.Provider>;
};

// eslint-disable-next-line react-refresh/only-export-components
export const useAuthProvider = () => useContext(AuthContext);
