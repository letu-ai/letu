import ErrorFallback from '@/components/ErrorFallback';
import { createFileRoute, Outlet } from '@tanstack/react-router'
import { Layout } from 'antd';
import { ErrorBoundary } from 'react-error-boundary';

export const Route = createFileRoute("/account")({
    component: AccountLayout,
})

function AccountLayout() {

    return (
        <ErrorBoundary FallbackComponent={ErrorFallback}>
            <Layout.Content>
                <Outlet />
            </Layout.Content>
        </ErrorBoundary>
    );
}