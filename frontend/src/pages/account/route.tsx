import ErrorFallback from '@/components/ErrorFallback';
import { createFileRoute, Outlet } from '@tanstack/react-router'
import { Layout } from 'antd';
import { AppConfigProvider, loadConfiguration } from '@/components/AppConfigProvider';
import { ErrorBoundary } from 'react-error-boundary';
import RouteErrorComponent from '@/components/RouteErrorComponent';

export const Route = createFileRoute("/account")({
    component: AccountLayout,
    loader: async () => {
        const config = await loadConfiguration()
        return {
            config
        }
    },
    staleTime: 1000 * 60 * 30, // 30分钟过期
    errorComponent: RouteErrorComponent
})

function AccountLayout() {
    const { config } = Route.useLoaderData()

    return (
        <AppConfigProvider config={config}>
            <ErrorBoundary FallbackComponent={ErrorFallback}>
                <Layout.Content>
                    <Outlet />
                </Layout.Content>
            </ErrorBoundary>
        </AppConfigProvider>
    );
}