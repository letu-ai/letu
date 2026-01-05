/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */
import "./src/global.css"

import { StatusBar, useColorScheme } from 'react-native';
import {
    SafeAreaProvider,
} from 'react-native-safe-area-context';
import { GluestackUIProvider } from '@/components/ui/gluestack-ui-provider';
import { useToast, Toast, ToastTitle, ToastDescription } from '@/components/ui/toast';
import React, { useEffect } from 'react';
import RootNavigator from '@/navigation/RootNavigator';
import httpClient from '@/api/httpClient';

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
