using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace Letu.Basis.Notifications.Dtos;

/// <summary>
/// 发送通知输入参数
/// </summary>
/// <remarks>
/// 支持两种使用方式：
/// 1. 直接指定用户：设置 UserIds 属性
/// 2. 按范围发送：设置 SendScopeType 和 SendScopeValue
/// </remarks>
public class SendNotificationInput
{
    /// <summary>
    /// 发送人或者系统功能名称，为空则表示当前用户或者系统发送。
    /// </summary>
    public string? Sender { get; set; }

    /// <summary>
    /// 发送人ID，为空表示系统发送
    /// </summary>
    public Guid? SenderId { get; set; }

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
    /// 通知类型：1=系统公告,2=业务通知,3=系统通知
    /// </summary>
    [Required]
    public NotificationType NotificationType { get; set; }

    /// <summary>
    /// 通知子类型（业务模块自定义，如 "intercom_request", "order_paid"）
    /// </summary>
    [MaxLength(64)]
    public string? SubType { get; set; }

    /// <summary>
    /// 发送范围类型：1=指定用户,2=按角色,3=按部门,4=按职位,5=全体员工,6=指定设备,7=按客户端类型
    /// </summary>
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
    public Priority Priority { get; set; } = Priority.Normal;

    /// <summary>
    /// 目标平台
    /// </summary>
    public TargetPlatform TargetPlatform { get; set; } = TargetPlatform.All;

    /// <summary>
    /// 租户ID，为空表示使用当前租户
    /// </summary>
    public Guid? TenantId { get; set; }
}
