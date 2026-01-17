/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */
import "./src/global.css"

import { StatusBar, useColorScheme, Platform } from 'react-native';
import {
    SafeAreaProvider,
} from 'react-native-safe-area-context';
import { GluestackUIProvider } from '@/components/ui/gluestack-ui-provider';
import { useToast, Toast, ToastTitle, ToastDescription } from '@/components/ui/toast';
import React, { useEffect } from 'react';
import RootNavigator from '@/navigation/RootNavigator';
import httpClient from '@/api/httpClient';
import { initPush, setupMessageListener, createEventChannel } from '@/lib/aliyun-push';

function App() {
    const isDarkMode = useColorScheme() === 'dark';
    const toast = useToast();

    useEffect(() => {
        // 设置HTTP客户端的错误处理器
        httpClient.setErrorHandler((errorInfo) => {
            if (errorInfo.showGlobalErrorMessage !== false) {
                toast.show({
                    placement: 'top',
                    duration: 3000,
                    render: ({ id }) => {
                        return (
                            <Toast nativeID={`toast-${id}`} action="error" variant="solid">
                                <ToastTitle>{errorInfo.message}</ToastTitle>
                                {errorInfo.details && (
                                    <ToastDescription>
                                        {Array.isArray(errorInfo.details)
                                            ? errorInfo.details.join(', ')
                                            : errorInfo.details}
                                    </ToastDescription>
                                )}
                            </Toast>
                        );
                    },
                });
            }
        });
    }, [toast]);

    // App启动时初始化推送服务（无论是否已登录）
    useEffect(() => {
        const initializePush = async () => {
            console.log('App启动，初始化推送服务...');

            // 创建通知渠道（仅Android，需在初始化前创建）
            if (Platform.OS === 'android') {
                await createEventChannel();
            }

            // 设置消息监听
            setupMessageListener();

            // 初始化推送（如果已初始化会直接返回，并自动处理用户绑定）
            await initPush();
        };

        initializePush().catch((error) => {
            console.error('推送服务初始化失败:', error);
        });
    }, []);

    return (
        <GluestackUIProvider>
            <SafeAreaProvider>
                <StatusBar barStyle={isDarkMode ? 'light-content' : 'dark-content'} />
                <RootNavigator />
            </SafeAreaProvider>
        </GluestackUIProvider>
    );
}

export default App;
