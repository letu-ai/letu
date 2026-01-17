namespace Letu.Basis.Notifications;

/// <summary>
/// 通知类型
/// </summary>
public enum NotificationType
{
    /// <summary>
    /// 系统公告，用户登录就展示的通知。
    /// </summary>
    SystemAnnouncement = 1,

    /// <summary>
    /// 业务通知，用户需要点击查看的通知。
    /// </summary>
    BusinessNotification = 2,

    /// <summary>
    /// 不给用户查看，系统功能使用的通知
    /// </summary>
    SystemNotification = 3,

}