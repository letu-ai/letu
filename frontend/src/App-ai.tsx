import { type ReactNode, useEffect } from "react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { Toaster } from "@/components/ui/sonner";
import httpClient from "./utils/httpClient";
import { StaticRoutes } from "./utils/globalValue";
import { toast } from "sonner";
import ResponseErrorMessage from "./utils/ResponseErrorMessage";

interface IAppAiProps {
    children: ReactNode;
}

const queryClient = new QueryClient({
    defaultOptions: {
        queries: {
            staleTime: 1000 * 60 * 5,
            retry: 1,
        },
    },
});

export default function AppAi({ children }: IAppAiProps) {
    useEffect(() => {
        httpClient.setErrorHandler((errorInfo) => {
            if (errorInfo.jumpTenantError && window.location.pathname !== StaticRoutes.tenantError) {
                window.location.href = StaticRoutes.tenantError;
                return;
            }

            if (errorInfo.showGlobalErrorMessage || errorInfo.jumpLogin) {
                toast.error(<ResponseErrorMessage error={errorInfo} />, {
                    duration: 3000,
                    onAutoClose: () => {
                        if (errorInfo.jumpLogin && window.location.pathname !== StaticRoutes.login) {
                            window.location.href = StaticRoutes.logout;
                        }
                    },
                });
            }
        });
    }, []);

    return (
        <QueryClientProvider client={queryClient}>
            {children}
            <Toaster position="top-center" richColors />
        </QueryClientProvider>
    );
}
