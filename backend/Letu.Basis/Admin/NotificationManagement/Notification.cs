using FreeSql.DataAnnotations;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.NotificationManagement
{
    [Table(Name = "sys_notification")]
    public class Notification : AuditedEntity<Guid>, IMultiTenant
    {
        /// <summary>
        /// 通知标题
        /// </summary>
        [NotNull]
        [Required]
        [MaxLength(128)]
        [Column(IsNullable = false, StringLength = 128)]
        public required string Title { get; set; }

        /// <summary>
        /// 通知内容
        /// </summary>
        [MaxLength(2000)]
        [Column(StringLength = 2000)]
        public string? Content { get; set; }

        /// <summary>
        /// 通知类型：1=系统公告,2=任务提醒,3=审批通知,4=其他
        /// </summary>
        [Required]
        [Column(IsNullable = false)]
        public NotificationType NotificationType { get; set; }

        /// <summary>
        /// 发送范围类型：1=指定用户,2=按角色,3=按部门,4=按职位,5=全体员工
        /// </summary>
        [Required]
        [Column(IsNullable = false)]
        public SendScopeType SendScopeType { get; set; }

        /// <summary>
        /// 发送范围值（角色ID、部门ID、职位ID等，多个用逗号分隔）
        /// </summary>
        [MaxLength(500)]
        [Column(StringLength = 500)]
        public string? SendScopeValue { get; set; }

        /// <summary>
        /// 通知状态：1=草稿,2=已发布,3=已撤回
        /// </summary>
        [Required]
        [Column(IsNullable = false)]
        public NotificationStatus Status { get; set; } = NotificationStatus.Draft;

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
        [Required]
        [Column(IsNullable = false)]
        public Priority Priority { get; set; } = Priority.Normal;

        /// <summary>
        /// 发送人ID
        /// </summary>
        [Required]
        [Column(Name = "employee_id", IsNullable = false)]
        public Guid SenderId { get; set; }

        /// <summary>
        /// 租户ID
        /// </summary>
        public Guid? TenantId { get; set; }
    }
}