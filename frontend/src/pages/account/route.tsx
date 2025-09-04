
import ErrorFallback from '@/components/ErrorFallback';
import { createFileRoute, Outlet, useRouter } from '@tanstack/react-router'
import { Layout } from 'antd';
import { AppConfigProvider, loadConfiguration } from '@/components/AppConfigProvider';
import { ErrorBoundary } from 'react-error-boundary';

export const Route = createFileRoute("/account")({
    component: AccountLayout,
    loader: async () => {
        const config = await loadConfiguration()
        return {
            config
        }
    },
    staleTime: 1000 * 60 * 30, // 30分钟过期
    errorComponent: ({ error }) => {
        const router = useRouter();
        
        const handleRetry = () => {
            router.invalidate();
        };

        return (
            <div className='h-screen'>
                <ErrorFallback error={error} resetErrorBoundary={handleRetry} />
            </div>
        )
    }
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