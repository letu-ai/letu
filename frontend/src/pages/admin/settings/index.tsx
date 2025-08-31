import { createFileRoute, Navigate } from "@tanstack/react-router";

export const Route = createFileRoute('/admin/settings/')({
    component: () => <Navigate to="/admin/settings/account" replace />
});
