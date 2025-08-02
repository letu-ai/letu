using Letu.Applications;
using Letu.Basis.Personal.Notifications.Dtos;

namespace Letu.Basis.Personal.Notifications
{
    public interface IUserNotificationAppService
    {
        Task<PagedResult<UserNotificationListDto>> GetMyNotificationListAsync(UserNotificationQueryDto dto);

        Task ReadedAsync(Guid[] ids);

        Task<UserNotificationNavbarDto> GetMyNotificationNavbarInfoAsync();
    }
}
