import { type RequestLogDto, getRequestLogDetails } from '../service';
import { Button, Card, Descriptions, Divider, Modal, Spin, Tag, Tabs, Table, Space, Empty } from 'antd';
import React, { useEffect, useState } from 'react';

// 状态码标签
const getHttpStatusCodeTag = (code: number) => {
  if (code >= 200 && code < 300)
    return <Tag color="green">{code}</Tag>;
  else if (code >= 300 && code < 400)
    return <Tag color="cyan">{code}</Tag>;
  else if (code >= 400 && code < 500)
    return <Tag color="red">{code}</Tag>;
  else if (code >= 500 && code < 600)
    return <Tag color="magenta">{code}</Tag>;
  else
    return <Tag>{code}</Tag>;
};

// HTTP方法标签
const getHttpMethodTag = (method?: string) => {
  switch (method) {
    case "GET":
      return <Tag color="green">{method}</Tag>;
    case "POST":
      return <Tag color="cyan">{method}</Tag>;
    case "PUT":
      return <Tag color="blue">{method}</Tag>;
    case "DELETE":
      return <Tag color="red">{method}</Tag>;
    case "PATCH":
      return <Tag color="magenta">{method}</Tag>;
    default:
      return <Tag>{method}</Tag>;
  }
};

interface RequestDetailsProps {
  open: boolean;
  onClose: () => void;
  id?: string;
}

const RequestDetails: React.FC<RequestDetailsProps> = ({ open, onClose, id }) => {
  const [loading, setLoading] = useState(false);
  const [details, setDetails] = useState<RequestLogDto | null>(null);

  useEffect(() => {
    const fetchDetails = async () => {
      if (!id) return;
      
      try {
        setLoading(true);
        const data = await getRequestLogDetails(id);
        setDetails(data);
      } catch (error) {
        console.error('获取审计日志详情失败:', error);
      } finally {
        setLoading(false);
      }
    };

    if (open && id) {
      fetchDetails();
    }
  }, [open, id]);

  // 基本信息标签页
  const BasicInfoTab = () => (
    <>
      <Descriptions bordered column={2}>
        <Descriptions.Item label="请求时间">{details?.executionTime}</Descriptions.Item>
        <Descriptions.Item label="响应耗时">{details?.executionDuration} ms</Descriptions.Item>
        <Descriptions.Item label="请求地址" span={2}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
            {details && getHttpStatusCodeTag(details.httpStatusCode)}
            {getHttpMethodTag(details?.httpMethod)}
            {details?.url}
          </div>
        </Descriptions.Item>
        <Descriptions.Item label="操作用户">{details?.userName}</Descriptions.Item>
        <Descriptions.Item label="客户端IP">{details?.clientIpAddress}</Descriptions.Item>
        <Descriptions.Item label="应用名称">{details?.applicationName}</Descriptions.Item>
        <Descriptions.Item label="关联ID">{details?.correlationId}</Descriptions.Item>
        <Descriptions.Item label="浏览器信息" span={2}>{details?.browserInfo}</Descriptions.Item>
      </Descriptions>
      
      {details?.exceptions && (
        <>
          <Divider orientation="left">异常信息</Divider>
          <Card type="inner" title="异常详情" bordered={false}>
            <pre style={{ whiteSpace: 'pre-wrap', wordWrap: 'break-word' }}>
              {details.exceptions}
            </pre>
          </Card>
        </>
      )}
    </>
  );

  // 操作记录标签页
  const ActionsTab = () => {
    return (
      <>
        {details?.actions && details.actions.length > 0 ? (
          <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
            {details.actions.map((action) => (
              <Card 
                key={action.id}
                type="inner"
                title={
                  <Space>
                    <span style={{ fontWeight: 'bold' }}>{action.serviceName}</span>
                    <Tag color="blue">{action.methodName}</Tag>
                  </Space>
                }
                extra={
                  <Space>
                    <span>执行时间：{action.executionTime}</span>
                    <span>耗时：{action.executionDuration} ms</span>
                  </Space>
                }
              >
                <div>
                  {action.parameters ? (
                    <Card 
                      styles={{ 
                        body: { 
                          maxHeight: '200px', 
                          overflow: 'auto',
                          padding: '12px' 
                        }
                      }}
                    >
                      <pre style={{ 
                        whiteSpace: 'pre-wrap', 
                        wordWrap: 'break-word', 
                        margin: 0 
                      }}>
                        {action.parameters}
                      </pre>
                    </Card>
                  ) : (
                    <Empty description="无参数信息" />
                  )}
                </div>
              </Card>
            ))}
          </div>
        ) : (
          <Empty description="无操作记录" />
        )}
      </>
    );
  };

  // 实体变更标签页
  const EntityChangesTab = () => {
    // 获取变更类型标签
    const getChangeTypeTag = (changeType: number) => {
      let color = '';
      let text = '';
      
      switch (changeType) {
        case 0:
          color = 'green';
          text = '创建';
          break;
        case 1:
          color = 'blue';
          text = '更新';
          break;
        case 2:
          color = 'red';
          text = '删除';
          break;
        default:
          text = '未知';
      }
      
      return <Tag color={color}>{text}</Tag>;
    };
    
    // 获取简化的实体类型名称
    const getSimplifiedTypeName = (fullName: string) => {
      const parts = fullName.split('.');
      return parts[parts.length - 1];
    };

    return (
      <>
        {details?.entityChanges && details.entityChanges.length > 0 ? (
          <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
            {details.entityChanges.map((entityChange) => (
              <Card 
                key={entityChange.id}
                type="inner"
                title={
                  <Space>
                    {getChangeTypeTag(entityChange.changeType)}
                    <span style={{ fontWeight: 'bold' }}>
                      {getSimplifiedTypeName(entityChange.entityTypeFullName)}
                    </span>
                  </Space>
                }
                extra={
                  <Space>
                    <span>实体ID：{entityChange.entityId}</span>
                    <span>变更时间：{entityChange.changeTime}</span>
                  </Space>
                }
              >
                {entityChange.propertyChanges && entityChange.propertyChanges.length > 0 ? (
                  <div style={{ marginTop: '8px' }}>
                    <Divider orientation="left">属性变更</Divider>
                    <Table
                      dataSource={entityChange.propertyChanges}
                      columns={[
                        {
                          title: '属性名称',
                          dataIndex: 'propertyName',
                          key: 'propertyName',
                          width: '20%',
                        },
                        {
                          title: '原始值',
                          dataIndex: 'originalValue',
                          key: 'originalValue',
                          width: '40%',
                          render: (text: string) => (
                            <div style={{ 
                              maxHeight: '100px', 
                              overflowY: 'auto',
                              wordBreak: 'break-all' 
                            }}>
                              {text || '(空)'}
                            </div>
                          ),
                        },
                        {
                          title: '新值',
                          dataIndex: 'newValue',
                          key: 'newValue',
                          width: '40%',
                          render: (text: string) => (
                            <div style={{ 
                              maxHeight: '100px', 
                              overflowY: 'auto',
                              wordBreak: 'break-all' 
                            }}>
                              {text || '(空)'}
                            </div>
                          ),
                        }
                      ]}
                      rowKey="id"
                      pagination={false}
                      size="small"
                      bordered
                    />
                  </div>
                ) : (
                  <Empty description="无属性变更" />
                )}
              </Card>
            ))}
          </div>
        ) : (
          <Empty description="无实体变更记录" />
        )}
      </>
    );
  };

  const tabItems = [
    {
      key: 'basic',
      label: '基本信息',
      children: <BasicInfoTab />,
    },
    {
      key: 'actions',
      label: '操作记录',
      children: <ActionsTab />,
    },
    {
      key: 'entityChanges',
      label: '实体变更',
      children: <EntityChangesTab />,
    }
  ];

  return (
    <Modal
      title="请求审计日志详情"
      open={open}
      width="80%"
      footer={null}
      onCancel={() => {
        onClose();
        setDetails(null);
      }}
    >
      <Spin spinning={loading}>
        {details && (
          <Tabs defaultActiveKey="basic" items={tabItems} />
        )}
      </Spin>
    </Modal>
  );
};

export default RequestDetails; 