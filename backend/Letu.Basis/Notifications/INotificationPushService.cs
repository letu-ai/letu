using Letu.Basis.Admin.NotificationManagement;

namespace Letu.Basis.Notifications;

/// <summary>
/// 通知推送服务接口
/// </summary>
public interface INotificationPushService
{
    /// <summary>
    /// 推送通知到指定用户（多渠道）
    /// </summary>
    /// <param name="notification">通知实体</param>
    /// <param name="userIds">目标用户ID列表</param>
    Task PushToUsersAsync(Notification notification, List<Guid> userIds);

    /// <summary>
    /// 推送通知到全部用户
    /// </summary>
    /// <param name="notification">通知实体</param>
    Task PushToAllAsync(Notification notification);

    /// <summary>
    /// 推送到指定设备
    /// </summary>
    /// <param name="notification">通知实体</param>
    /// <param name="deviceIds">设备ID列表</param>
    Task PushToDevicesAsync(Notification notification, List<string> deviceIds);

    /// <summary>
    /// 重试失败的推送
    /// </summary>
    /// <param name="userNotificationId">用户通知ID</param>
    Task RetryPushAsync(Guid userNotificationId);
}
