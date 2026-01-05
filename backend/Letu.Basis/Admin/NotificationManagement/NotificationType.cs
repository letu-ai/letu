namespace Letu.Basis.Admin.NotificationManagement;

/// <summary>
/// 通知类型
/// </summary>
public enum NotificationType
{
    /// <summary>
    /// 系统公告
    /// </summary>
    SystemAnnouncement = 1,

    /// <summary>
    /// 任务提醒
    /// </summary>
    TaskReminder = 2,

    /// <summary>
    /// 审批通知
    /// </summary>
    ApprovalNotification = 3,

    /// <summary>
    /// 其他
    /// </summary>
    Other = 4
}