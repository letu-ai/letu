using Letu.Basis.Notifications;
using Letu.Core.Applications;

namespace Letu.Basis.Admin.NotificationManagement.Dtos;

public class NotificationListInput : PagedResultRequest
{
    /// <summary>
    /// 通知标题
    /// </summary>
    public string? Title { get; set; }

    /// <summary>
    /// 通知类型
    /// </summary>
    public NotificationType? NotificationType { get; set; }

    /// <summary>
    /// 通知状态：1=草稿,2=已发布,3=已撤回
    /// </summary>
    public NotificationStatus? Status { get; set; }

    /// <summary>
    /// 发送范围类型
    /// </summary>
    public SendScopeType? SendScopeType { get; set; }

    /// <summary>
    /// 优先级
    /// </summary>
    public Priority? Priority { get; set; }

    /// <summary>
    /// 创建时间开始
    /// </summary>
    public DateTime? StartTime { get; set; }

    /// <summary>
    /// 创建时间结束
    /// </summary>
    public DateTime? EndTime { get; set; }
}