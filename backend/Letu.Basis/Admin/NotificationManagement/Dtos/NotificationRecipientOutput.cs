using Letu.Basis.Notifications;

namespace Letu.Basis.Admin.NotificationManagement.Dtos;

public class NotificationRecipientOutput
{
    /// <summary>
    /// 用户通知ID
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// 用户ID
    /// </summary>
    public Guid UserId { get; set; }

    /// <summary>
    /// 用户姓名
    /// </summary>
    public string? UserName { get; set; }

    /// <summary>
    /// 部门名称
    /// </summary>
    public string? DepartmentName { get; set; }

    /// <summary>
    /// 职位名称
    /// </summary>
    public string? PositionName { get; set; }

    /// <summary>
    /// 是否已读
    /// </summary>
    public bool IsRead { get; set; }

    /// <summary>
    /// 阅读时间
    /// </summary>
    public DateTime? ReadTime { get; set; }

    /// <summary>
    /// 接收时间
    /// </summary>
    public DateTime CreationTime { get; set; }

    /// <summary>
    /// 推送状态
    /// </summary>
    public PushStatus PushStatus { get; set; }

    /// <summary>
    /// 已重试次数
    /// </summary>
    public int RetryCount { get; set; }

    /// <summary>
    /// 推送失败原因
    /// </summary>
    public string? PushErrorMessage { get; set; }
}