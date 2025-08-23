import { Outlet } from 'react-router-dom';
import ErrorFallback from '@/components/ErrorFallback';
import { ErrorBoundary } from 'react-error-boundary';
import { Layout } from 'antd';
import Application from '@/components/Application';
import { App } from 'antd';
import httpClient from '@/utils/httpClient';
import ResponseErrorMessage from '@/utils/ResponseErrorMessage';
import { useEffect } from 'react';

function Index() {
    const { message } = App.useApp();

    useEffect(() => {
        httpClient.setErrorHandler((errorInfo) => {
            message.error(<ResponseErrorMessage error={errorInfo} />, 3);
        });
    }, [message]);

    return (
        <Application>
            <ErrorBoundary FallbackComponent={ErrorFallback}>
                <Layout.Content>
                    <Outlet />
                </Layout.Content>
            </ErrorBoundary>
        </Application>
    );
}

export default Index;
