using FreeSql.DataAnnotations;
using Letu.Basis.Notifications;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.NotificationManagement;

[Table(Name = "sys_notification")]
public class Notification : AuditedEntity<Guid>, IMultiTenant
{

    /// <summary>
    /// 租户ID
    /// </summary>
    public Guid? TenantId { get; set; }

    /// <summary>
    /// 如果是用户发送的，就填写发送人ID
    /// </summary>
    public Guid? SenderId { get; set; }

    /// <summary>
    /// 发送者，可填写是用名称或者系统功能名称
    /// </summary>
    [Column(IsNullable = false, StringLength = 128)]
    public required string Sender { get; set; }

    /// <summary>
    /// 通知标题
    /// </summary>
    [Column(IsNullable = false, StringLength = 128)]
    public required string Title { get; set; }

    /// <summary>
    /// 通知内容
    /// </summary>
    [Column(StringLength = 2000)]
    public string? Content { get; set; }

    /// <summary>
    /// 通知类型
    /// </summary>
    [Column(IsNullable = false)]
    public NotificationType NotificationType { get; set; }

    /// <summary>
    /// 通知子类型（业务模块自定义，如 "intercom_request", "order_paid"）
    /// </summary>
    [Column(StringLength = 64)]
    public string? SubType { get; set; }

    /// <summary>
    /// 发送范围类型
    /// </summary>
    [Column(IsNullable = false)]
    public SendScopeType SendScopeType { get; set; }

    /// <summary>
    /// 发送范围值（角色ID、部门ID、职位ID等，多个用逗号分隔）
    /// </summary>
    [Column(StringLength = 500)]
    public string? SendScopeValue { get; set; }

    /// <summary>
    /// 通知状态：1=草稿,2=已发布,3=已撤回
    /// </summary>
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
    [Column(IsNullable = false)]
    public Priority Priority { get; set; } = Priority.Normal;

    /// <summary>
    /// 目标平台（位标志）
    /// </summary>
    [Column(IsNullable = false)]
    public TargetPlatform TargetPlatform { get; set; } = TargetPlatform.All;

    [Navigate(nameof(UserNotification.NotificationId))]
    public List<UserNotification>? UserNotifications { get; set; }
}