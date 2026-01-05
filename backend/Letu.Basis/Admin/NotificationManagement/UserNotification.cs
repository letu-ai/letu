using FreeSql.DataAnnotations;
using System.ComponentModel.DataAnnotations;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.NotificationManagement;

[Table(Name = "sys_user_notification")]
public class UserNotification : CreationAuditedEntity<Guid>, IMultiTenant
{
    /// <summary>
    /// 通知ID
    /// </summary>
    [Required]
    [Column(IsNullable = false)]
    public Guid NotificationId { get; set; }

    /// <summary>
    /// 用户ID（员工ID）
    /// </summary>
    [Required]
    [Column(IsNullable = false)]
    public Guid UserId { get; set; }

    /// <summary>
    /// 是否已读
    /// </summary>
    [Required]
    [Column(IsNullable = false)]
    public bool IsRead { get; set; } = false;

    /// <summary>
    /// 阅读时间
    /// </summary>
    public DateTime? ReadTime { get; set; }

    /// <summary>
    /// 是否删除（用户删除通知）
    /// </summary>
    [Required]
    [Column(IsNullable = false)]
    public bool IsDeleted { get; set; } = false;

    /// <summary>
    /// 租户ID
    /// </summary>
    public Guid? TenantId { get; set; }

    /// <summary>
    /// 导航属性 - 通知
    /// </summary>
    [Navigate(nameof(NotificationId))]
    public virtual Notification? Notification { get; set; }
}