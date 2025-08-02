import React, { useCallback, useEffect, useState } from "react";
import { Outlet, useNavigate, useLocation } from "react-router-dom";
import { Tabs, Card, Typography } from "antd";

const { Title } = Typography;

const getDefaultActivekey = () => {
    const path = window.location.pathname;
    if (path.includes('/admin/loggings/auditlog/request'))
        return "request"
    else
        return "entity"
}

const AuditLogPage: React.FC = () => {
    const [tabActiveKey, setTabActiveKey] = useState<string>(getDefaultActivekey())
    const navigate = useNavigate();
    const location = useLocation();

    const handleTabChange = useCallback((key: string) => {
        setTabActiveKey(key)
        if (key === "entity") {
            navigate('/admin/loggings/auditlog/entity')
        } else {
            navigate('/admin/loggings/auditlog/request')
        }
    }, [navigate])

    useEffect(() => {
        if (location.pathname.includes('/admin/loggings/auditlog/entity'))
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
};

export default AuditLogPage;
