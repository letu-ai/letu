/**
 * 测试入口 - 用于排查启动问题
 * 如果主应用无法启动，可以临时使用这个文件测试
 */
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';

export default function TestApp() {
    console.log('[TestApp] 应用启动');
    
    return (
        <SafeAreaProvider>
            <View style={styles.container}>
                <Text style={styles.title}>测试应用</Text>
                <Text style={styles.subtitle}>如果您看到这个界面，说明基础配置正常</Text>
            </View>
        </SafeAreaProvider>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#FFFFFF',
        padding: 20,
    },
    title: {
        fontSize: 24,
        fontWeight: 'bold',
        marginBottom: 10,
        color: '#1F2937',
    },
    subtitle: {
        fontSize: 16,
        color: '#6B7280',
        textAlign: 'center',
    },
});

