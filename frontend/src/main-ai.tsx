import { StrictMode } from "react";
import ReactDOM from "react-dom/client";
import { RouterProvider, createRouter } from "@tanstack/react-router";
import { routeTree } from "./routeTree.gen";
import AppAi from "./App-ai";
import { tokenRefreshManager } from '@/utils/tokenRefreshManager';

// 创建路由实例
const router = createRouter({ routeTree });

declare module "@tanstack/react-router" {
    interface Register {
        router: typeof router;
    }
}

// 监听 token 刷新成功事件，自动重新获取页面数据
tokenRefreshManager.onTokenRefreshed(() => {
    console.log('Token 已刷新，正在重新获取页面数据...');
    router.invalidate();
});

const rootElement = document.getElementById("root")!;
if (!rootElement.innerHTML) {
    const root = ReactDOM.createRoot(rootElement);
    root.render(
        <StrictMode>
            <AppAi>
                <RouterProvider router={router} />
            </AppAi>
        </StrictMode>
    );
}
