using FreeSql.DataAnnotations;
using Letu.Basis.Admin.Users;
using Letu.Basis.Notifications;
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
    /// 导航属性 - 通知
    /// </summary>
    [Navigate(nameof(NotificationId))]
    public virtual Notification? Notification { get; set; }

    /// <summary>
    /// 用户ID（员工ID）
    /// </summary>
    [Required]
    [Column(IsNullable = false)]
    public Guid UserId { get; set; }

    /// <summary>
    /// 导航属性 - 用户
    /// </summary>
    [Navigate(nameof(UserId))]
    public virtual User? User { get; set; }

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
    /// 消息的整体推送状态
    /// </summary>
    [Required]
    [Column(IsNullable = false)]
    public PushStatus PushStatus { get; set; } = PushStatus.Pending;

    /// <summary>
    /// 推送时间
    /// </summary>
    public DateTime? PushTime { get; set; }

    /// <summary>
    /// 推送失败原因
    /// </summary>
    [MaxLength(500)]
    [Column(StringLength = 500)]
    public string? PushErrorMessage { get; set; }

    /// <summary>
    /// 已重试次数
    /// </summary>
    [Required]
    [Column(IsNullable = false)]
    public int RetryCount { get; set; } = 0;

    /// <summary>
    /// 下次重试时间
    /// </summary>
    public DateTime? NextRetryTime { get; set; }

    /// <summary>
    /// 推送有效期（过期后不再重试）
    /// </summary>
    public DateTime? PushExpireTime { get; set; }

    /// <summary>
    /// 租户ID
    /// </summary>
    public Guid? TenantId { get; set; }
}