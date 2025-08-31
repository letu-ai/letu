using Letu.Basis.Admin.NotificationManagement;
using Letu.Basis.Notifications.Dtos;
using Letu.Core.Applications;

namespace Letu.Basis.Notifications;

public interface IUserNotificationAppService
{
    Task<PagedResult<UserNotificationDto>> GetMyNotificationListAsync(UserNotificationQueryDto dto);
    Task<UserNotificationDto> GetMyNotificationAsync(Guid id);

    Task ReadedAsync(Guid[] ids);

    Task<UserNotificationNavbarDto> GetMyNotificationNavbarInfoAsync();

    /// <summary>
    /// 发送通知给指定用户
    /// </summary>
    Task SendNotificationToUserAsync(Guid employeeId, string title, string content);

    /// <summary>
    /// 发送通知给所有用户
    /// </summary>
    Task SendNotificationToAllAsync(string title, string content);

    Task SendNotificationByRangeAsync(NotificationPublishedEto eventData);
}
