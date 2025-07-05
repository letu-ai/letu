import { Card, Row, Col, Typography, Timeline, Button, Space, Tooltip, Tag, Divider } from 'antd';
import {
  GithubOutlined,
  BookOutlined,
  CodeOutlined,
  HistoryOutlined,
  GiftOutlined,
  StarOutlined,
  ForkOutlined,
  EyeOutlined,
} from '@ant-design/icons';
import './index.scss';

const { Title, Text, Paragraph } = Typography;

const HomePage = () => {
  // 更新日志数据
  const changelog = [
    {
      version: 'v2.1.0',
      date: '2023-07-20',
      items: ['新增数据导出功能', '优化移动端适配体验', '修复权限管理模块的若干问题'],
    },
    {
      version: 'v2.0.3',
      date: '2023-06-28',
      items: ['重构通知中心模块', '增加多语言支持', '优化系统性能，提升响应速度'],
    },
    {
      version: 'v2.0.0',
      date: '2023-06-10',
      items: ['全新UI设计上线', '重构核心业务逻辑', '增加API文档中心'],
    },
  ];

  // 技术栈数据
  const techStack = [
    { name: 'React', icon: <CodeOutlined /> },
    { name: 'Ant Design', icon: <CodeOutlined /> },
    { name: 'Node.js', icon: <CodeOutlined /> },
    { name: 'Express', icon: <CodeOutlined /> },
    { name: 'MongoDB', icon: <CodeOutlined /> },
    { name: 'Webpack', icon: <CodeOutlined /> },
    { name: 'Sass/SCSS', icon: <CodeOutlined /> },
    { name: 'Git', icon: <CodeOutlined /> },
  ];

  // 仓库地址
  const repoLinks = [
    { name: 'GitHub', icon: <GithubOutlined />, url: 'https://github.com/your-repo' },
    { name: 'Gitee', icon: <GithubOutlined />, url: 'https://gitee.com/your-repo' },
    { name: '文档', icon: <BookOutlined />, url: 'https://docs.your-project.com' },
  ];

  return (
    <div className="home-page">
      {/* 主要内容区域 */}
      <Row gutter={[24, 24]} className="main-content">
        {/* 左侧列 - 项目介绍和技术栈 */}
        <Col xs={24} md={16}>
          <Row gutter={[24, 24]}>
            {/* 开源项目介绍 */}
            <Col span={24}>
              <Card
                title={
                  <Space>
                    <BookOutlined />
                    <Title level={5} style={{ margin: 0 }}>
                      项目介绍
                    </Title>
                  </Space>
                }
                className="dashboard-card"
              >
                <Paragraph>
                  本项目是一个基于React和Ant Design的开源管理系统，旨在为企业提供高效、美观的后台管理解决方案。
                  系统采用现代化的技术栈，具有良好的扩展性和可维护性，支持快速定制开发。
                </Paragraph>
                <Paragraph>
                  <Text strong>核心价值：</Text>
                  <ul className="project-features">
                    <li>简洁高效的用户界面</li>
                    <li>模块化的系统架构</li>
                    <li>完善的权限管理体系</li>
                    <li>丰富的组件库支持</li>
                    <li>响应式布局设计</li>
                  </ul>
                </Paragraph>

                <Divider dashed />

                <Space direction="vertical" style={{ width: '100%' }}>
                  <Text strong>仓库地址：</Text>
                  <div className="repo-buttons">
                    {repoLinks.map((link, index) => (
                      <Button
                        key={index}
                        icon={link.icon}
                        size="middle"
                        onClick={() => window.open(link.url, '_blank')}
                        className="repo-button"
                      >
                        {link.name}
                      </Button>
                    ))}
                  </div>
                  <div className="repo-stats">
                    <Tooltip title="Stars">
                      <Space>
                        <StarOutlined />
                        <Text strong>1.2k</Text>
                      </Space>
                    </Tooltip>
                    <Tooltip title="Forks">
                      <Space>
                        <ForkOutlined />
                        <Text strong>324</Text>
                      </Space>
                    </Tooltip>
                    <Tooltip title="Watchers">
                      <Space>
                        <EyeOutlined />
                        <Text strong>86</Text>
                      </Space>
                    </Tooltip>
                  </div>
                </Space>
              </Card>
            </Col>

            {/* 使用技术列表 */}
            <Col span={24}>
              <Card
                title={
                  <Space>
                    <CodeOutlined />
                    <Title level={5} style={{ margin: 0 }}>
                      使用技术列表
                    </Title>
                  </Space>
                }
                className="dashboard-card"
              >
                <div className="tech-stack">
                  {techStack.map((tech, index) => (
                    <Tag key={index} icon={tech.icon} className="tech-tag">
                      {tech.name}
                    </Tag>
                  ))}
                </div>
                <Paragraph type="secondary" style={{ marginTop: 16 }}>
                  前端基于React和Ant Design构建，后端使用Node.js和Express，数据库采用MongoDB，构建工具使用Webpack。
                </Paragraph>
              </Card>
            </Col>
          </Row>
        </Col>

        {/* 右侧列 - 更新日志和捐赠 */}
        <Col xs={24} md={8}>
          <Row gutter={[24, 24]}>
            {/* 更新日志 */}
            <Col span={24}>
              <Card
                title={
                  <Space>
                    <HistoryOutlined />
                    <Title level={5} style={{ margin: 0 }}>
                      更新日志
                    </Title>
                  </Space>
                }
                className="dashboard-card"
              >
                <Timeline
                  mode="left"
                  items={changelog.map((log, index) => {
                    return {
                      color: '#7E57C2',
                      children: (
                        <div className="changelog-item" key={index}>
                          <Space>
                            <Text strong>{log.version}</Text>
                            <Text type="secondary">{log.date}</Text>
                          </Space>
                          <ul className="changelog-list">
                            {log.items.map((item, i) => (
                              <li key={i}>{item}</li>
                            ))}
                          </ul>
                        </div>
                      ),
                    };
                  })}
                />
              </Card>
            </Col>

            {/* 打赏二维码 */}
            <Col span={24}>
              <Card
                title={
                  <Space>
                    <GiftOutlined />
                    <Title level={5} style={{ margin: 0 }}>
                      支持我们
                    </Title>
                  </Space>
                }
                className="dashboard-card"
              >
                <div className="donation-container">
                  <div className="qrcode-placeholder">
                    <div className="qrcode-icon">
                      <GiftOutlined />
                    </div>
                  </div>
                  <div className="donation-text">
                    <Paragraph type="secondary" style={{ textAlign: 'center' }}>
                      如果您觉得这个项目对您有帮助，欢迎打赏支持开发团队
                    </Paragraph>
                    <Paragraph style={{ textAlign: 'center' }}>
                      <Text strong>扫描二维码支持我们</Text>
                    </Paragraph>
                  </div>
                </div>
              </Card>
            </Col>
          </Row>
        </Col>
      </Row>
    </div>
  );
};

export default HomePage;
