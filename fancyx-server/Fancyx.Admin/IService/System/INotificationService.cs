using Fancyx.Admin.IService.System.Dtos;

namespace Fancyx.Admin.IService.System
{
    public interface INotificationService
    {
        Task AddNotificationAsync(NotificationDto dto);

        Task<PagedResult<NotificationResultDto>> GetNotificationListAsync(NotificationSearchDto dto);

        Task UpdateNotificationAsync(NotificationDto dto);

        Task DeleteNotificationAsync(Guid[] ids);
    }
}