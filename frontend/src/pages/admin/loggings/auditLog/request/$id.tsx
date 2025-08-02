import { type RequestLogDto, getRequestLogDetails } from '../service';
import { Button, Card, Descriptions, Divider, Space, Spin, Tag } from 'antd';
import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { ArrowLeftOutlined } from '@ant-design/icons';

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

const RequestLogDetails: React.FC = () => {
  const params = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [details, setDetails] = useState<RequestLogDto | null>(null);

  // 返回列表
  const handleBack = () => {
    navigate('/admin/loggings/auditlog/request');
  };

  useEffect(() => {
    const fetchDetails = async () => {
      try {
        if (params.id) {
          setLoading(true);
          const data = await getRequestLogDetails(params.id);
          setDetails(data);
        }
      } catch (error) {
        console.error('获取审计日志详情失败:', error);
      } finally {
        setLoading(false);
      }
    };
    
    fetchDetails();
  }, [params.id]);

  return (
    <Spin spinning={loading}>
      <Card 
        title={
          <Space>
            <Button type="link" icon={<ArrowLeftOutlined />} onClick={handleBack}>返回</Button>
            <span>请求审计日志详情</span>
          </Space>
        }
      >
        {details && (
          <>
            <Descriptions bordered column={2}>
              <Descriptions.Item label="请求时间">{details.executionTime}</Descriptions.Item>
              <Descriptions.Item label="响应耗时">{details.executionDuration} ms</Descriptions.Item>
              <Descriptions.Item label="请求地址" span={2}>
                <Space>
                  {getHttpStatusCodeTag(details.httpStatusCode)}
                  {getHttpMethodTag(details.httpMethod)}
                  {details.url}
                </Space>
              </Descriptions.Item>
              <Descriptions.Item label="操作用户">{details.userName}</Descriptions.Item>
              <Descriptions.Item label="客户端IP">{details.clientIpAddress}</Descriptions.Item>
              <Descriptions.Item label="应用名称">{details.applicationName}</Descriptions.Item>
              <Descriptions.Item label="关联ID">{details.correlationId}</Descriptions.Item>
              <Descriptions.Item label="浏览器信息" span={2}>{details.browserInfo}</Descriptions.Item>
            </Descriptions>
            
            {details.exceptions && (
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
        )}
      </Card>
    </Spin>
  );
};

export default RequestLogDetails; 