using Letu.Basis.Admin.Notifications.Dtos;
using Letu.Core.Applications;

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