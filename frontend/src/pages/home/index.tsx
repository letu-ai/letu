import { Card, Row, Col, Statistic, Button, Table, Tag, Avatar, List } from 'antd';
import {
    UserOutlined,
    TeamOutlined,
    BellOutlined,
    ClockCircleOutlined,
    SettingOutlined,
    SafetyOutlined,
    DatabaseOutlined,
    ScheduleOutlined,
    FileTextOutlined,
    AppstoreOutlined,
    ApartmentOutlined,
    IdcardOutlined,
    HistoryOutlined,
    NotificationOutlined,
    ArrowUpOutlined,
    ArrowDownOutlined,
} from '@ant-design/icons';
import { createFileRoute, Link } from '@tanstack/react-router';
import { LineChart, Line, AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, PieChart, Pie, Cell } from 'recharts';

export const Route = createFileRoute('/home/')({
    component: HomePage
});

// 模拟数据 - 统计指标
const statisticsData = {
    totalUsers: 1286,
    onlineUsers: 45,
    todayNotifications: 23,
    pendingTasks: 8,
    userGrowth: 12.5,
    onlineChange: -3.2,
};

// 模拟数据 - 访问趋势（最近7天）
const visitTrendData = [
    { date: '10-03', visits: 245, activeUsers: 186 },
    { date: '10-04', visits: 312, activeUsers: 223 },
    { date: '10-05', visits: 289, activeUsers: 198 },
    { date: '10-06', visits: 356, activeUsers: 267 },
    { date: '10-07', visits: 423, activeUsers: 312 },
    { date: '10-08', visits: 398, activeUsers: 289 },
    { date: '10-09', visits: 467, activeUsers: 334 },
];

// 模拟数据 - 用户分布
const userDistributionData = [
    { name: '管理员', value: 12, color: '#1890ff' },
    { name: '员工', value: 856, color: '#52c41a' },
    { name: '访客', value: 418, color: '#faad14' },
];

// 模拟数据 - 最近登录记录
const recentLogins = [
    { id: 1, user: '张三', role: '管理员', ip: '192.168.1.100', time: '2025-10-09 14:23:12', status: 'success' },
    { id: 2, user: '李四', role: '员工', ip: '192.168.1.101', time: '2025-10-09 14:15:32', status: 'success' },
    { id: 3, user: '王五', role: '员工', ip: '192.168.1.102', time: '2025-10-09 13:58:45', status: 'failed' },
    { id: 4, user: '赵六', role: '访客', ip: '192.168.1.103', time: '2025-10-09 13:42:18', status: 'success' },
    { id: 5, user: '钱七', role: '员工', ip: '192.168.1.104', time: '2025-10-09 13:28:56', status: 'success' },
];

// 模拟数据 - 系统通知
const systemNotifications = [
    { id: 1, title: '系统维护通知', content: '系统将于今晚22:00进行例行维护', time: '2小时前', type: 'warning' },
    { id: 2, title: '新功能上线', content: '用户标签功能已上线，欢迎体验', time: '5小时前', type: 'info' },
    { id: 3, title: '安全提醒', content: '检测到异常登录尝试，请注意账号安全', time: '1天前', type: 'error' },
    { id: 4, title: '数据备份完成', content: '数据库备份任务已成功完成', time: '1天前', type: 'success' },
];

// 常用功能入口配置
const quickActions = [
    {
        title: '用户管理',
        icon: <UserOutlined className="text-2xl" />,
        color: 'bg-blue-500',
        items: [
            { name: '用户列表', path: '/admin/users', icon: <UserOutlined /> },
            { name: '角色管理', path: '/admin/roles', icon: <SafetyOutlined /> },
            { name: '部门管理', path: '/admin/departments', icon: <ApartmentOutlined /> },
            { name: '职位管理', path: '/admin/positions', icon: <IdcardOutlined /> },
        ],
    },
    {
        title: '系统配置',
        icon: <SettingOutlined className="text-2xl" />,
        color: 'bg-green-500',
        items: [
            { name: '系统设置', path: '/admin/settings', icon: <SettingOutlined /> },
            { name: '菜单管理', path: '/admin/menus', icon: <AppstoreOutlined /> },
            { name: '租户管理', path: '/admin/tenants', icon: <TeamOutlined /> },
            { name: '数据字典', path: '/admin/data-dictionaries', icon: <DatabaseOutlined /> },
        ],
    },
    {
        title: '日志监控',
        icon: <FileTextOutlined className="text-2xl" />,
        color: 'bg-orange-500',
        items: [
            { name: '访问日志', path: '/admin/loggings/auditLog/request', icon: <HistoryOutlined /> },
            { name: '实体日志', path: '/admin/loggings/auditLog/entity', icon: <FileTextOutlined /> },
            { name: '业务日志', path: '/admin/loggings/business', icon: <FileTextOutlined /> },
            { name: '在线用户', path: '/admin/online-users', icon: <TeamOutlined /> },
        ],
    },
    {
        title: '通知任务',
        icon: <BellOutlined className="text-2xl" />,
        color: 'bg-purple-500',
        items: [
            { name: '通知管理', path: '/admin/notifications', icon: <BellOutlined /> },
            { name: '定时任务', path: '/admin/scheduled-tasks', icon: <ScheduleOutlined /> },
            { name: '我的通知', path: '/my/notifications', icon: <NotificationOutlined /> },
        ],
    },
];

function HomePage() {
    const loginColumns = [
        {
            title: '用户',
            dataIndex: 'user',
            key: 'user',
            render: (text: string, record: any) => (
                <div className="flex items-center gap-2">
                    <Avatar size="small" icon={<UserOutlined />} />
                    <div>
                        <div className="font-medium">{text}</div>
                        <div className="text-xs text-gray-500">{record.role}</div>
                    </div>
                </div>
            ),
        },
        {
            title: 'IP地址',
            dataIndex: 'ip',
            key: 'ip',
        },
        {
            title: '登录时间',
            dataIndex: 'time',
            key: 'time',
        },
        {
            title: '状态',
            dataIndex: 'status',
            key: 'status',
            render: (status: string) => (
                <Tag color={status === 'success' ? 'success' : 'error'}>
                    {status === 'success' ? '成功' : '失败'}
                </Tag>
            ),
        },
    ];

    return (
        <div className="p-6 bg-gray-50 min-h-full">
            {/* 顶部统计卡片 */}
            <Row gutter={[16, 16]} className="mb-6">
                <Col xs={24} sm={12} lg={6}>
                    <Card variant="borderless" className="shadow-sm hover:shadow-md transition-shadow">
                        <Statistic
                            title="总用户数"
                            value={statisticsData.totalUsers}
                            prefix={<UserOutlined />}
                            suffix={
                                <span className="text-sm ml-2">
                                    <ArrowUpOutlined className="text-green-500" />
                                    <span className="text-green-500">{statisticsData.userGrowth}%</span>
                                </span>
                            }
                        />
                    </Card>
                </Col>
                <Col xs={24} sm={12} lg={6}>
                    <Card variant="borderless" className="shadow-sm hover:shadow-md transition-shadow">
                        <Statistic
                            title="在线用户"
                            value={statisticsData.onlineUsers}
                            prefix={<TeamOutlined />}
                            valueStyle={{ color: '#52c41a' }}
                            suffix={
                                <span className="text-sm ml-2">
                                    <ArrowDownOutlined className="text-red-500" />
                                    <span className="text-red-500">{Math.abs(statisticsData.onlineChange)}%</span>
                                </span>
                            }
                        />
                    </Card>
                </Col>
                <Col xs={24} sm={12} lg={6}>
                    <Card variant="borderless" className="shadow-sm hover:shadow-md transition-shadow">
                        <Statistic
                            title="今日通知"
                            value={statisticsData.todayNotifications}
                            prefix={<BellOutlined />}
                            valueStyle={{ color: '#faad14' }}
                        />
                    </Card>
                </Col>
                <Col xs={24} sm={12} lg={6}>
                    <Card variant="borderless" className="shadow-sm hover:shadow-md transition-shadow">
                        <Statistic
                            title="待办任务"
                            value={statisticsData.pendingTasks}
                            prefix={<ClockCircleOutlined />}
                            valueStyle={{ color: '#f5222d' }}
                        />
                    </Card>
                </Col>
            </Row>

            {/* 常用功能入口 */}
            <Row gutter={[16, 16]} className="mb-6">
                {quickActions.map((action, index) => (
                    <Col xs={24} sm={12} lg={6} key={index}>
                        <Card
                            variant="borderless"
                            className="shadow-sm hover:shadow-md transition-all h-full"
                            title={
                                <div className="flex items-center gap-3">
                                    <div className={`${action.color} text-white p-2 rounded-lg`}>
                                        {action.icon}
                                    </div>
                                    <span className="font-semibold">{action.title}</span>
                                </div>
                            }
                        >
                            <div className="space-y-2">
                                {action.items.map((item, idx) => (
                                    <Link key={idx} to={item.path}>
                                        <Button
                                            type="text"
                                            icon={item.icon}
                                            block
                                            className="text-left hover:bg-blue-50 hover:text-blue-600 transition-colors"
                                        >
                                            {item.name}
                                        </Button>
                                    </Link>
                                ))}
                            </div>
                        </Card>
                    </Col>
                ))}
            </Row>

            {/* 数据可视化区域 */}
            <Row gutter={[16, 16]} className="mb-6">
                <Col xs={24} lg={16}>
                    <Card
                        variant="borderless"
                        className="shadow-sm"
                        title={
                            <div className="flex items-center gap-2">
                                <HistoryOutlined />
                                <span className="font-semibold">访问趋势（最近7天）</span>
                            </div>
                        }
                    >
                        <ResponsiveContainer width="100%" height={300}>
                            <AreaChart data={visitTrendData}>
                                <defs>
                                    <linearGradient id="colorVisits" x1="0" y1="0" x2="0" y2="1">
                                        <stop offset="5%" stopColor="#1890ff" stopOpacity={0.8} />
                                        <stop offset="95%" stopColor="#1890ff" stopOpacity={0} />
                                    </linearGradient>
                                    <linearGradient id="colorActive" x1="0" y1="0" x2="0" y2="1">
                                        <stop offset="5%" stopColor="#52c41a" stopOpacity={0.8} />
                                        <stop offset="95%" stopColor="#52c41a" stopOpacity={0} />
                                    </linearGradient>
                                </defs>
                                <CartesianGrid strokeDasharray="3 3" />
                                <XAxis dataKey="date" />
                                <YAxis />
                                <Tooltip />
                                <Area type="monotone" dataKey="visits" stroke="#1890ff" fillOpacity={1} fill="url(#colorVisits)" name="访问量" />
                                <Area type="monotone" dataKey="activeUsers" stroke="#52c41a" fillOpacity={1} fill="url(#colorActive)" name="活跃用户" />
                            </AreaChart>
                        </ResponsiveContainer>
                    </Card>
                </Col>
                <Col xs={24} lg={8}>
                    <Card
                        variant="borderless"
                        className="shadow-sm"
                        title={
                            <div className="flex items-center gap-2">
                                <TeamOutlined />
                                <span className="font-semibold">用户分布</span>
                            </div>
                        }
                    >
                        <ResponsiveContainer width="100%" height={300}>
                            <PieChart>
                                <Pie
                                    data={userDistributionData}
                                    cx="50%"
                                    cy="50%"
                                    labelLine={false}
                                    label={(entry) => `${entry.name}: ${entry.value}`}
                                    outerRadius={80}
                                    fill="#8884d8"
                                    dataKey="value"
                                >
                                    {userDistributionData.map((entry, index) => (
                                        <Cell key={`cell-${index}`} fill={entry.color} />
                                    ))}
                                </Pie>
                                <Tooltip />
                            </PieChart>
                        </ResponsiveContainer>
                    </Card>
                </Col>
            </Row>

            {/* 最近活动 */}
            <Row gutter={[16, 16]}>
                <Col xs={24} lg={14}>
                    <Card
                        variant="borderless"
                        className="shadow-sm"
                        title={
                            <div className="flex items-center gap-2">
                                <HistoryOutlined />
                                <span className="font-semibold">最近登录记录</span>
                            </div>
                        }
                    >
                        <Table
                            columns={loginColumns}
                            dataSource={recentLogins}
                            pagination={false}
                            size="small"
                            rowKey="id"
                        />
                    </Card>
                </Col>
                <Col xs={24} lg={10}>
                    <Card
                        variant="borderless"
                        className="shadow-sm"
                        title={
                            <div className="flex items-center gap-2">
                                <BellOutlined />
                                <span className="font-semibold">系统通知</span>
                            </div>
                        }
                    >
                        <List
                            dataSource={systemNotifications}
                            renderItem={(item) => (
                                <List.Item className="hover:bg-gray-50 transition-colors cursor-pointer">
                                    <List.Item.Meta
                                        avatar={
                                            <Avatar
                                                icon={<BellOutlined />}
                                                style={{
                                                    backgroundColor:
                                                        item.type === 'warning'
                                                            ? '#faad14'
                                                            : item.type === 'error'
                                                            ? '#f5222d'
                                                            : item.type === 'success'
                                                            ? '#52c41a'
                                                            : '#1890ff',
                                                }}
                                            />
                                        }
                                        title={<span className="font-medium">{item.title}</span>}
                                        description={
                                            <div>
                                                <div className="text-sm text-gray-600">{item.content}</div>
                                                <div className="text-xs text-gray-400 mt-1">{item.time}</div>
                                            </div>
                                        }
                                    />
                                </List.Item>
                            )}
                        />
                    </Card>
                </Col>
            </Row>
        </div>
    );
}
