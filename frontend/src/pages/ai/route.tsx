import { createFileRoute, Outlet } from '@tanstack/react-router'
import { requireAuth } from '@/utils/authUtils'
import { Navbar } from '@/pages/ai/-components/Header'
import Sidebar from '@/pages/ai/-components/Sidebar'
import { ErrorBoundary } from 'react-error-boundary'
import ErrorFallback from '@/components/ErrorFallback'
import { AppConfigProvider, loadConfiguration } from '@/components/AppConfigProvider'
import { SidebarProvider, SidebarInset } from '@/components/ui/sidebar'
import RouteErrorComponent from '@/components/RouteErrorComponent';

export const Route = createFileRoute('/ai')({
    component: AiLayout,
    beforeLoad: async ({ location }) => {
        requireAuth(location)
    },
    loader: async () => {
        const config = await loadConfiguration()
        return {
            config
        }
    },
    staleTime: 1000 * 60 * 30, // 30分钟过期
    errorComponent: RouteErrorComponent
})

function AiLayout() {
    const { config } = Route.useLoaderData()

    return (
        <AppConfigProvider config={config}>
            <SidebarProvider>
                <Sidebar />
                <SidebarInset className="flex flex-col h-screen">
                    <Navbar />
                    <ErrorBoundary FallbackComponent={ErrorFallback}>
                        <main className="flex-1 overflow-auto bg-background p-4 sm:p-6">
                            <Outlet />
                        </main>
                    </ErrorBoundary>
                </SidebarInset>
            </SidebarProvider>
        </AppConfigProvider>
    );
}
