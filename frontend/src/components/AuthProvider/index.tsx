import React, { createContext, useContext } from 'react';
import UserStore from '@/store/userStore.ts';
import { getUserAuth, login, type ILoginInput, smsLogin, type SmsLoginDto } from '@/pages/accounts/service';
import { clearTabs } from '@/store/tabStore.ts';
import { useDispatch } from 'react-redux';

export interface AuthProviderType {
    pwdLogin?: (values: ILoginInput) => Promise<void>;
    smsLogin?: (values: SmsLoginDto) => Promise<void>;
    clearToken: () => void;
    refreshUserAuthInfo?: () => Promise<void>;
}

const AuthContext = createContext<AuthProviderType>({
    clearToken: () => { },
});

export const AuthProvider = ({ children }: { children: React.ReactNode }) => {
    const dispatch = useDispatch();

    const pwdLogin = async (values: ILoginInput) => {
        const data = await login(values);
        if (data) {
            UserStore.setToken({
                accessToken: data.accessToken,
                refreshToken: data.refreshToken,
                expiredTime: data.expiredTime,
            });
            await setOrRefreshUserAuthInfo();
        }
    };
    const clearToken = () => {
        UserStore.logout();
        dispatch(clearTabs());
    };

    const setOrRefreshUserAuthInfo = async () => {
        if (UserStore.isAuthenticated()) {
            const authInfo = await getUserAuth();
            const _authInfo = {
                sessionId: authInfo.sessionId,
                userId: authInfo.user.userId,
                userName: authInfo.user.userName,
                nickName: authInfo.user.nickName,
                avatar: authInfo.user.avatar,
                sex: authInfo.user.sex,
                menus: authInfo.menus,
                permissions: authInfo.permissions,
            };
            UserStore.setUserInfo(_authInfo);
        }
    };

    return (
        <AuthContext.Provider
            value={{
                pwdLogin,
                clearToken,
                refreshUserAuthInfo: setOrRefreshUserAuthInfo,
            }}
        >
            {children}
        </AuthContext.Provider>
    );
};

// eslint-disable-next-line react-refresh/only-export-components
export const useAuthProvider = () => useContext(AuthContext);
