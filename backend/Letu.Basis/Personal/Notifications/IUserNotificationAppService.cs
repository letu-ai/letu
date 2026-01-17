using Letu.Basis.Admin.NotificationManagement;
using Letu.Basis.Personal.Notifications.Dtos;
using Letu.Core.Applications;

namespace Letu.Basis.Personal.Notifications;

public interface IUserNotificationAppService
{
    Task<PagedResult<UserNotificationDto>> GetMyNotificationListAsync(UserNotificationQueryDto dto);
    Task<UserNotificationDto> GetMyNotificationAsync(Guid id);

    Task ReadedAsync(Guid[] ids);

    Task<UserNotificationNavbarDto> GetMyNotificationNavbarInfoAsync();
}
