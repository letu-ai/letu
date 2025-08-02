using Letu.Applications;
using Letu.Basis.Admin.Notifications.Dtos;

namespace Letu.Basis.Admin.Notifications
{
    public interface INotificationAppService
    {
        Task AddNotificationAsync(NotificationDto dto);

        Task<PagedResult<NotificationResultDto>> GetNotificationListAsync(NotificationQueryDto dto);

        Task UpdateNotificationAsync(Guid id, NotificationDto dto);

        Task DeleteNotificationAsync(Guid[] ids);
    }
}