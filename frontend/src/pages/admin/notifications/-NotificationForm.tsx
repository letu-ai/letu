import { Form, Input, Modal, Select, DatePicker, Radio, Space, Button } from "antd";
import { forwardRef, useImperativeHandle, useState } from "react";
import {
  createNotification,
  updateNotification,
  type NotificationDto,
  type NotificationResultDto,
  NotificationType,
  NotificationPriority,
  NotificationStatus,
  NOTIFICATION_TYPE_OPTIONS,
  NOTIFICATION_PRIORITY_OPTIONS,
} from "./-service";
import RecipientSelector from "@/components/RecipientSelector";
import type { RecipientValue } from "@/components/RecipientSelector/types";
import useApp from "antd/es/app/useApp";
import TextArea from "antd/es/input/TextArea";
import dayjs from "dayjs";

interface ModalProps {
  refresh?: () => void;
}

export interface ModalRef {
  openModal: (row?: NotificationResultDto) => void;
}

const NotificationForm = forwardRef<ModalRef, ModalProps>((props, ref) => {
  const [isOpenModal, setIsOpenModal] = useState<boolean>(false);
  const [form] = Form.useForm();
  const [currentRecord, setCurrentRecord] = useState<NotificationResultDto | null>(null);
  const { message } = useApp();
  const [submitType, setSubmitType] = useState<"draft" | "publish">("draft");

  useImperativeHandle(ref, () => ({
    openModal,
  }));

  const openModal = (row?: NotificationResultDto) => {
    setIsOpenModal(true);
    setCurrentRecord(row || null);
    
    if (row) {
      // 编辑模式 - 填充表单数据
      const recipientValue: RecipientValue = {
        sendScopeType: row.sendScopeType,
        sendScopeValue: row.sendScopeValue,
      };

      form.setFieldsValue({
        title: row.title,
        content: row.content,
        notificationType: row.notificationType,
        priority: row.priority,
        expireTime: row.expireTime ? dayjs(row.expireTime) : undefined,
        recipient: recipientValue,
      });
    } else {
      // 新建模式 - 重置表单并设置默认值
      form.resetFields();
      form.setFieldsValue({
        notificationType: NotificationType.OTHER,
        priority: NotificationPriority.NORMAL,
      });
    }
  };

  const onCancel = () => {
    form.resetFields();
    setIsOpenModal(false);
    setCurrentRecord(null);
    // 取消操作不刷新数据
  };

  const handleSubmit = (type: "draft" | "publish") => {
    setSubmitType(type);
    form.submit();
  };

  const handleSuccess = (successMessage: string) => {
    message.success(successMessage);
    setIsOpenModal(false);
    form.resetFields();
    setCurrentRecord(null);
    // 只在数据发生变更时才刷新
    props?.refresh?.();
  };

  const onFinish = async (values: any) => {
    try {
      const recipientValue = values.recipient as RecipientValue;
      
      const dto: NotificationDto = {
        title: values.title,
        content: values.content,
        notificationType: values.notificationType,
        sendScopeType: recipientValue.sendScopeType,
        sendScopeValue: recipientValue.sendScopeValue,
        priority: values.priority,
        expireTime: values.expireTime ? values.expireTime.format("YYYY-MM-DD HH:mm:ss") : undefined,
        isPublish: submitType === "publish",
      };

      if (currentRecord) {
        // 编辑模式
        await updateNotification(currentRecord.id, dto);
        handleSuccess(submitType === "publish" ? "发布成功" : "更新成功");
      } else {
        // 新建模式
        await createNotification(dto);
        handleSuccess(submitType === "publish" ? "创建并发布成功" : "创建成功");
      }
    } catch (error) {
      console.error("Submit failed:", error);
    }
  };

  return (
    <Modal
      title={currentRecord ? "编辑通知" : "创建通知"}
      open={isOpenModal}
      onCancel={onCancel}
      maskClosable={false}
      width={800}
      footer={[
        <Space key="footer">
          <Button onClick={onCancel}>取消</Button>
          <Button 
            onClick={() => handleSubmit("draft")}
            disabled={currentRecord?.status === NotificationStatus.PUBLISHED}
          >
            {currentRecord ? "更新" : "保存草稿"}
          </Button>
          <Button 
            type="primary" 
            onClick={() => handleSubmit("publish")}
            disabled={currentRecord?.status === NotificationStatus.PUBLISHED}
          >
            {currentRecord ? "发布" : "创建并发布"}
          </Button>
        </Space>
      ]}
    >
      <Form
        name="notificationForm"
        labelCol={{ span: 4 }}
        wrapperCol={{ span: 20 }}
        form={form}
        onFinish={onFinish}
        autoComplete="off"
      >
        <Form.Item 
          label="通知标题" 
          name="title" 
          rules={[
            { required: true, message: "请输入通知标题" }, 
            { max: 128, message: "标题最多128个字符" }
          ]}
        >
          <Input placeholder="请输入通知标题" />
        </Form.Item>

        <Form.Item 
          label="通知类型" 
          name="notificationType" 
          rules={[{ required: true, message: "请选择通知类型" }]}
        >
          <Select placeholder="请选择通知类型" options={NOTIFICATION_TYPE_OPTIONS} />
        </Form.Item>

        <Form.Item 
          label="优先级" 
          name="priority" 
          rules={[{ required: true, message: "请选择优先级" }]}
        >
          <Radio.Group options={NOTIFICATION_PRIORITY_OPTIONS} />
        </Form.Item>

        <Form.Item 
          label="接收人" 
          name="recipient" 
          rules={[{ required: true, message: "请选择接收人" }]}
        >
          <RecipientSelector placeholder="请选择通知接收人" />
        </Form.Item>

        <Form.Item 
          label="过期时间" 
          name="expireTime"
        >
          <DatePicker
            showTime
            format="YYYY-MM-DD HH:mm:ss"
            placeholder="请选择过期时间"
            style={{ width: "100%" }}
            disabledDate={(current) => current && current < dayjs().startOf("day")}
          />
        </Form.Item>

        <Form.Item 
          label="通知内容" 
          name="content"
          rules={[
            { max: 2000, message: "内容最多2000个字符" }
          ]}
        >
          <TextArea
            placeholder="请输入通知内容"
            autoSize={{ minRows: 4, maxRows: 8 }}
            maxLength={2000}
            showCount
          />
        </Form.Item>
      </Form>
    </Modal>
  );
});

export default NotificationForm;
