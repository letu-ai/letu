using Letu.Basis.Admin.NotificationManagement;

namespace Letu.Basis.Personal.Notifications.Dtos
{
    public class UserNotificationDto
    {
        /// <summary>
        /// 用户通知ID
        /// </summary>
        public Guid Id { get; set; }

        /// <summary>
        /// 通知ID
        /// </summary>
        public Guid NotificationId { get; set; }

        /// <summary>
        /// 通知标题
        /// </summary>
        public string? Title { get; set; }

        /// <summary>
        /// 通知内容
        /// </summary>
        public string? Content { get; set; }

        /// <summary>
        /// 通知类型
        /// </summary>
        public NotificationType NotificationType { get; set; }

        /// <summary>
        /// 优先级
        /// </summary>
        public Priority Priority { get; set; }

        /// <summary>
        /// 是否已读
        /// </summary>
        public bool IsReaded { get; set; }

        /// <summary>
        /// 接收时间
        /// </summary>
        public DateTime CreationTime { get; set; }

        /// <summary>
        /// 已读时间
        /// </summary>
        public DateTime? ReadedTime { get; set; }
    }
}
