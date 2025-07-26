using Letu.Admin.IService.Account.Dtos;

namespace Letu.Admin.IService.Account
{
    public interface IUserNotificationService
    {
        Task<PagedResult<UserNotificationListDto>> GetMyNotificationListAsync(UserNotificationQueryDto dto);

        Task ReadedAsync(Guid[] ids);

        Task<UserNotificationNavbarDto> GetMyNotificationNavbarInfoAsync();
    }
}
