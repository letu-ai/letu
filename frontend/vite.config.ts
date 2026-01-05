import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';
import tailwindcss from '@tailwindcss/vite'
import { tanstackRouter } from '@tanstack/router-plugin/vite'

// https://vite.dev/config/
export default defineConfig({
    plugins: [
        tanstackRouter({
            routesDirectory: "./src/pages",
            generatedRouteTree: "./src/routeTree.gen.ts",
            target: 'react',
            autoCodeSplitting: true,
        }),
        react(),
        tailwindcss(),
        {
            name: 'ai-route-rewrite',
            configureServer(server) {
                server.middlewares.use((req, _res, next) => {
                    // 将 /ai 开头的路由重写到 ai.html
                    if (req.url?.startsWith('/ai')) {
                        req.url = '/ai.html';
                    }
                    next();
                });
            },
        },
    ],
    resolve: {
        alias: {
            '@': path.resolve(__dirname, './src'),
        },
    },
    build: {
        sourcemap: false, // 生产环境禁用 sourcemap
        minify: 'esbuild', // 启用代码压缩
        rollupOptions: {
            input: {
                admin: path.resolve(__dirname, 'index.html'),
                ai: path.resolve(__dirname, 'ai.html'),
            },
        },
    },
    // 开发环境下的 sourcemap 配置（仅用于开发调试）
    esbuild: {
        sourcemap: true, // 开发环境启用 sourcemap 便于调试
    },
    server: {
        host: '0.0.0.0',
        port: 8080,
        open: false,
        hmr: {
            overlay: false,
        },
        allowedHosts: true,
    }
});
