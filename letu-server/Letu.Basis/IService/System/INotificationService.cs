using Letu.Basis.IService.System.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Basis.IService.System
{
    public interface INotificationService : IScopedDependency
    {
        Task AddNotificationAsync(NotificationDto dto);

        Task<PagedResult<NotificationResultDto>> GetNotificationListAsync(NotificationQueryDto dto);

        Task UpdateNotificationAsync(NotificationDto dto);

        Task DeleteNotificationAsync(Guid[] ids);
    }
}