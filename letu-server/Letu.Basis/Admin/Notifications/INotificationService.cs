using Letu.Basis.Admin.Notifications.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Basis.Admin.Notifications
{
    public interface INotificationService : IScopedDependency
    {
        Task AddNotificationAsync(NotificationDto dto);

        Task<PagedResult<NotificationResultDto>> GetNotificationListAsync(NotificationQueryDto dto);

        Task UpdateNotificationAsync(NotificationDto dto);

        Task DeleteNotificationAsync(Guid[] ids);
    }
}