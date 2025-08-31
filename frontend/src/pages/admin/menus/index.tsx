import { createFileRoute, Navigate } from "@tanstack/react-router";

export const Route = createFileRoute('/admin/menus/')({
    component: () => <Navigate to="/admin/menus/$appName" params={{appName: "admin"}} replace />
});
