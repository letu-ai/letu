import { Form, Modal, Select, Tag } from 'antd';
import SmartTable from '@/components/SmartTable';
import type { SmartTableColumnType, SmartTableRef } from '@/components/SmartTable/type.ts';
import { getExecutionLogList } from '@/api/system/scheduledTask.ts';
import { useEffect, useRef } from 'react';

const TaskExecutionLogModal = ({
  visible,
  taskKey,
  onCancel,
}: {
  visible: boolean;
  taskKey: string;
  onCancel: () => void;
}) => {
  const columns: SmartTableColumnType[] = [
    {
      title: '执行时间',
      dataIndex: 'executionTime',
    },
    {
      title: '执行状态',
      dataIndex: 'status',
      render: (status: number) => (status === 1 ? <Tag color="green">成功</Tag> : <Tag color="red">失败</Tag>),
    },
    {
      title: '执行结果',
      dataIndex: 'result',
    },
    {
      title: '耗时',
      dataIndex: 'cost',
      render: (cost: number) => {
        return cost + 'ms';
      },
    },
  ];
  const logTableRef = useRef<SmartTableRef>(null);

  useEffect(() => {
    if (visible) {
      logTableRef?.current?.reload();
    }
  }, [visible]);

  return (
    <Modal open={visible} title={`任务【${taskKey}】执行日志`} width="65%" onCancel={onCancel} footer={null}>
      <SmartTable
        columns={columns}
        rowKey="id"
        ref={logTableRef}
        request={async (params) => {
          const { data } = await getExecutionLogList({ ...params, taskKey });
          return data;
        }}
        searchItems={
          <Form.Item label="执行状态" name="status">
            <Select
              placeholder="请选择执行状态"
              options={[
                { label: '成功', value: 1 },
                { label: '失败', value: 2 },
              ]}
              allowClear
            />
          </Form.Item>
        }
      />
    </Modal>
  );
};

export default TaskExecutionLogModal;
