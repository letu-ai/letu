using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Letu.Basis.Admin.NotificationManagement.Dtos
{
    public class NotificationDto
    {
        /// <summary>
        /// 通知标题
        /// </summary>
        [NotNull]
        [Required]
        [MaxLength(128)]
        public string? Title { get; set; }

        /// <summary>
        /// 通知内容
        /// </summary>
        [MaxLength(2000)]
        public string? Content { get; set; }

        /// <summary>
        /// 通知类型：1=系统公告,2=任务提醒,3=审批通知,4=其他
        /// </summary>
        [Required]
        public NotificationType NotificationType { get; set; }

        /// <summary>
        /// 发送范围类型：1=指定用户,2=按角色,3=按部门,4=按职位,5=全体员工
        /// </summary>
        [Required]
        public SendScopeType SendScopeType { get; set; }

        /// <summary>
        /// 发送范围值（角色ID、部门ID、职位ID、用户ID等，多个用逗号分隔）
        /// </summary>
        [MaxLength(500)]
        public string? SendScopeValue { get; set; }

        /// <summary>
        /// 过期时间
        /// </summary>
        public DateTime? ExpireTime { get; set; }

        /// <summary>
        /// 优先级：1=普通,2=重要,3=紧急
        /// </summary>
        [Required]
        public Priority Priority { get; set; } = Priority.Normal;

        /// <summary>
        /// 是否立即发送，false为保存草稿
        /// </summary>
        public bool IsPublish { get; set; } = true;
    }
}