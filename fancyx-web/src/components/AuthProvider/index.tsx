import React, { createContext, useContext, useState } from 'react';
import UserStore, { type TokenInfo } from '@/store/userStore.ts';
import { getUserAuth, login, type LoginDto } from '@/api/auth.ts';
import dayjs from 'dayjs';

export interface AuthProviderType {
  isAuth: () => boolean;
  pwdLogin?: (values: LoginDto) => Promise<void>;
  tokenInfo?: TokenInfo | null;
  clearToken?: () => void;
}

const AuthContext = createContext<AuthProviderType>({ isAuth: () => false });

export const AuthProvider = ({ children }: { children: React.ReactNode }) => {
  const [tokenInfo, setTokenInfo] = useState<TokenInfo | null>(null);

  const isAuth = () => {
    if (!tokenInfo || !tokenInfo.accessToken) return false;
    return dayjs(tokenInfo.expiredTime).isAfter(new Date());
  };

  const pwdLogin = async (values: LoginDto) => {
    const res = await login(values);
    if (res.data) {
      const _tokenInfo = {
        sessionId: res.data.sessionId,
        accessToken: res.data.accessToken,
        refreshToken: res.data.refreshToken,
        expiredTime: res.data.expiredTime,
      };
      setTokenInfo(_tokenInfo);
      UserStore.setToken(_tokenInfo);
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
  const clearToken = () => {
    setTokenInfo(null);
  };

  return <AuthContext.Provider value={{ isAuth, pwdLogin, tokenInfo, clearToken }}>{children}</AuthContext.Provider>;
};

// eslint-disable-next-line react-refresh/only-export-components
export const useAuthProvider = () => useContext(AuthContext);
