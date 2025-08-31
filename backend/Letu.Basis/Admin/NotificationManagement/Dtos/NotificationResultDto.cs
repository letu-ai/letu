namespace Letu.Basis.Admin.NotificationManagement.Dtos
{
    public class NotificationResultDto
    {
        public Guid Id { get; set; }

        /// <summary>
        /// 通知标题
        /// </summary>
        public string? Title { get; set; }

        /// <summary>
        /// 通知内容
        /// </summary>
        public string? Content { get; set; }

        /// <summary>
        /// 通知类型：1=系统公告,2=任务提醒,3=审批通知,4=其他
        /// </summary>
        public NotificationType NotificationType { get; set; }

        /// <summary>
        /// 发送范围类型：1=指定用户,2=按角色,3=按部门,4=按职位,5=全体员工
        /// </summary>
        public SendScopeType SendScopeType { get; set; }

        /// <summary>
        /// 发送范围值
        /// </summary>
        public string? SendScopeValue { get; set; }

        /// <summary>
        /// 通知状态：1=草稿,2=已发布,3=已撤回
        /// </summary>
        public NotificationStatus Status { get; set; }

        /// <summary>
        /// 发布时间
        /// </summary>
        public DateTime? PublishTime { get; set; }

        /// <summary>
        /// 过期时间
        /// </summary>
        public DateTime? ExpireTime { get; set; }

        /// <summary>
        /// 优先级：1=普通,2=重要,3=紧急
        /// </summary>
        public Priority Priority { get; set; }

        /// <summary>
        /// 发送人ID
        /// </summary>
        public Guid SenderId { get; set; }

        /// <summary>
        /// 发送人姓名
        /// </summary>
        public string? SenderName { get; set; }

        /// <summary>
        /// 创建时间
        /// </summary>
        public DateTime CreationTime { get; set; }

        /// <summary>
        /// 接收人数统计
        /// </summary>
        public int RecipientCount { get; set; }

        /// <summary>
        /// 已读人数统计
        /// </summary>
        public int ReadCount { get; set; }
    }
}