import { type EntityChangeLogDto, getEntityChangeLogDetails } from '../service';
import { Button, Card, Descriptions, Divider, Space, Spin, Table, Tag } from 'antd';
import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { ArrowLeftOutlined } from '@ant-design/icons';
import type { ColumnsType } from 'antd/es/table';

// 变更类型标签
const getChangeTypeTag = (type: number) => {
  switch (type) {
    case 0:
      return <Tag color="success">新增</Tag>;
    case 1:
      return <Tag color="processing">修改</Tag>;
    case 2:
      return <Tag color="error">删除</Tag>;
    default:
      return <Tag>未知</Tag>;
  }
};

// 获取实体类型显示名称
const getEntityTypeDisplayName = (fullName: string) => {
  if (!fullName) return '';
  
  // 简化显示，去掉命名空间
  const parts = fullName.split('.');
  return parts[parts.length - 1];
};

// 属性变更列定义
interface PropertyChangeColumn {
  propertyName: string;
  originalValue?: string;
  newValue?: string;
}

const EntityChangeLogDetails: React.FC = () => {
  const params = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [details, setDetails] = useState<EntityChangeLogDto | null>(null);

  // 返回列表
  const handleBack = () => {
    navigate('/admin/loggings/auditlog/entity');
  };

  useEffect(() => {
    const fetchDetails = async () => {
      try {
        if (params.id) {
          setLoading(true);
          const data = await getEntityChangeLogDetails(params.id);
          setDetails(data);
        }
      } catch (error) {
        console.error('获取实体变更日志详情失败:', error);
      } finally {
        setLoading(false);
      }
    };
    
    fetchDetails();
  }, [params.id]);

  // 属性变更列
  const propertyColumns: ColumnsType<PropertyChangeColumn> = [
    {
      title: '属性名',
      dataIndex: 'propertyName',
      key: 'propertyName',
      width: '30%',
    },
    {
      title: '原始值',
      dataIndex: 'originalValue',
      key: 'originalValue',
      width: '35%',
      render: (text) => (
        <div style={{ whiteSpace: 'pre-wrap', wordBreak: 'break-word' }}>
          {text === undefined || text === null ? <span style={{ color: '#999999' }}>空值</span> : text}
        </div>
      ),
    },
    {
      title: '新值',
      dataIndex: 'newValue',
      key: 'newValue',
      width: '35%',
      render: (text) => (
        <div style={{ whiteSpace: 'pre-wrap', wordBreak: 'break-word' }}>
          {text === undefined || text === null ? <span style={{ color: '#999999' }}>空值</span> : text}
        </div>
      ),
    },
  ];

  return (
    <Spin spinning={loading}>
      <Card 
        title={
          <Space>
            <Button type="link" icon={<ArrowLeftOutlined />} onClick={handleBack}>返回</Button>
            <span>实体变更日志详情</span>
          </Space>
        }
      >
        {details && (
          <>
            <Descriptions bordered column={2}>
              <Descriptions.Item label="变更时间">{details.changeTime}</Descriptions.Item>
              <Descriptions.Item label="变更类型">{getChangeTypeTag(details.changeType)}</Descriptions.Item>
              <Descriptions.Item label="实体类型">
                {getEntityTypeDisplayName(details.entityTypeFullName)}
                <div>
                  <small style={{ color: '#666666' }}>{details.entityTypeFullName}</small>
                </div>
              </Descriptions.Item>
              <Descriptions.Item label="实体ID">{details.entityId}</Descriptions.Item>
              <Descriptions.Item label="操作用户" span={2}>{details.userName}</Descriptions.Item>
            </Descriptions>
            
            <Divider orientation="left">属性变更</Divider>
            <Table 
              columns={propertyColumns} 
              dataSource={details.propertyChanges.map(p => ({
                key: p.id,
                propertyName: p.propertyName,
                originalValue: p.originalValue,
                newValue: p.newValue,
              }))} 
              pagination={false}
              bordered
              size="small"
            />
          </>
        )}
      </Card>
    </Spin>
  );
};

export default EntityChangeLogDetails; 