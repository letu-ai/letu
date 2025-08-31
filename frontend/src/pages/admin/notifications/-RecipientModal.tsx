import { forwardRef, useImperativeHandle, useState } from "react";
import { Modal, Table, Tag, Form, Input, Select, Button } from "antd";
import { CheckOutlined, CloseOutlined } from "@ant-design/icons";
import type { ColumnsType } from "antd/es/table";
import {
  getNotificationRecipients,
  type NotificationRecipientDto,
} from "./-service";
import dayjs from "dayjs";

interface RecipientModalProps {
  [key: string]: unknown;
}

export interface RecipientModalRef {
  openModal: (notificationId: string, notificationTitle: string) => void;
}

const RecipientModal = forwardRef<RecipientModalRef, RecipientModalProps>(
  (_props, ref) => {
    const [isOpen, setIsOpen] = useState(false);
    const [loading, setLoading] = useState(false);
    const [notificationId, setNotificationId] = useState<string>("");
    const [notificationTitle, setNotificationTitle] = useState<string>("");
    const [dataSource, setDataSource] = useState<NotificationRecipientDto[]>([]);
    const [pagination, setPagination] = useState({
      current: 1,
      pageSize: 10,
      total: 0,
    });
    const [searchParams, setSearchParams] = useState<{
      userName?: string;
      isRead?: boolean;
    }>({});

    useImperativeHandle(ref, () => ({
      openModal,
    }));

    const openModal = (id: string, title: string) => {
      setNotificationId(id);
      setNotificationTitle(title);
      setIsOpen(true);
      setSearchParams({});
      setPagination({ current: 1, pageSize: 10, total: 0 });
      loadData(id, 1, 10, {});
    };

    const loadData = async (
      id: string,
      current: number,
      pageSize: number,
      params: any
    ) => {
      try {
        setLoading(true);
        const result = await getNotificationRecipients(id, {
          current,
          pageSize,
          ...params,
        });
        setDataSource(result.items);
        setPagination({
          current: current,
          pageSize: pageSize,
          total: result.totalCount,
        });
      } catch (error) {
        console.error("Failed to load recipients:", error);
      } finally {
        setLoading(false);
      }
    };

    const handleTableChange = (paginationConfig: any) => {
      const { current, pageSize } = paginationConfig;
      loadData(notificationId, current, pageSize, searchParams);
    };

    const handleSearch = (values: any) => {
      const params = {
        userName: values.userName,
        isRead: values.isRead,
      };
      setSearchParams(params);
      loadData(notificationId, 1, pagination.pageSize, params);
    };

    const columns: ColumnsType<NotificationRecipientDto> = [
      {
        title: "用户姓名",
        dataIndex: "userName",
        key: "userName",
        width: 120,
      },
      {
        title: "部门",
        dataIndex: "departmentName",
        key: "departmentName",
        width: 150,
        render: (text) => text || "-",
      },
      {
        title: "职位",
        dataIndex: "positionName", 
        key: "positionName",
        width: 120,
        render: (text) => text || "-",
      },
      {
        title: "阅读状态",
        dataIndex: "isRead",
        key: "isRead",
        width: 100,
        render: (isRead: boolean) => (
          <Tag
            color={isRead ? "success" : "default"}
            icon={isRead ? <CheckOutlined /> : <CloseOutlined />}
          >
            {isRead ? "已读" : "未读"}
          </Tag>
        ),
      },
      {
        title: "通知时间",
        dataIndex: "creationTime",
        key: "creationTime",
        width: 160,
        render: (time: string) => dayjs(time).format("YYYY-MM-DD HH:mm:ss"),
      },
      {
        title: "阅读时间",
        dataIndex: "readTime",
        key: "readTime",
        width: 160,
        render: (time?: string) =>
          time ? dayjs(time).format("YYYY-MM-DD HH:mm:ss") : "-",
      },
    ];

    return (
      <Modal
        title={`通知接收人 - ${notificationTitle}`}
        open={isOpen}
        onCancel={() => setIsOpen(false)}
        footer={null}
        width={1000}
        destroyOnHidden
      >
        {/* 搜索表单 */}
        <Form
          layout="inline"
          onFinish={handleSearch}
          style={{ marginBottom: 16 }}
        >
          <Form.Item name="userName" label="用户姓名">
            <Input placeholder="请输入用户姓名" style={{ width: 200 }} />
          </Form.Item>
          <Form.Item name="isRead" label="阅读状态">
            <Select placeholder="请选择阅读状态" style={{ width: 120 }} allowClear>
              <Select.Option value={true}>已读</Select.Option>
              <Select.Option value={false}>未读</Select.Option>
            </Select>
          </Form.Item>
          <Form.Item>
            <Button type="primary" htmlType="submit">
              搜索
            </Button>
          </Form.Item>
        </Form>

        {/* 接收人列表 */}
        <Table
          columns={columns}
          dataSource={dataSource}
          loading={loading}
          rowKey="id"
          pagination={{
            current: pagination.current,
            pageSize: pagination.pageSize,
            total: pagination.total,
            showSizeChanger: true,
            showQuickJumper: true,
            showTotal: (total, range) =>
              `共 ${total} 条记录，第 ${range[0]}-${range[1]} 条`,
          }}
          onChange={handleTableChange}
          size="small"
        />
      </Modal>
    );
  }
);

export default RecipientModal;