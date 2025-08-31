import { useCallback, useEffect, useState } from "react";
import { Outlet, useNavigate, useLocation, createFileRoute } from '@tanstack/react-router';
import { Tabs, Card, Typography } from "antd";

const { Title } = Typography;

const getDefaultActivekey = () => {
    const path = window.location.pathname;
    if (path.includes('/admin/loggings/auditlog/request'))
        return "request"
    else
        return "entity"
}

export const Route = createFileRoute('/admin/loggings/auditlog')({
    component: AuditLogPage,
  });

  
function AuditLogPage() {
    const [tabActiveKey, setTabActiveKey] = useState<string>(getDefaultActivekey())
    const navigate = useNavigate();
    const location = useLocation();

    const handleTabChange = useCallback((key: string) => {
        setTabActiveKey(key)
        if (key === "entity") {
            navigate({ to: '/admin/loggings/auditLog/entity'})
        } else {
            navigate({ to: '/admin/loggings/auditLog/request'})
        }
    }, [navigate])

    useEffect(() => {
        if (location.pathname.includes('/admin/loggings/auditLog/entity'))
            setTabActiveKey("entity")
        else
            setTabActiveKey("request")
    }, [location.pathname])

    return (
        <Card className="page-container">
            <Title level={4}>审计日志</Title>
            <Tabs
                activeKey={tabActiveKey}
                onChange={handleTabChange}
                items={[
                    {
                        key: 'request',
                        label: '访问审计',
                    },
                    {
                        key: 'entity',
                        label: '数据审计',
                    }
                ]}
            />
            <div className="content-container">
                <Outlet />
            </div>
        </Card>
    )
}
