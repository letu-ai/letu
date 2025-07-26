using Letu.Basis.IService.Account.Dtos;

namespace Letu.Basis.IService.Account
{
    public interface IUserNotificationService
    {
        Task<PagedResult<UserNotificationListDto>> GetMyNotificationListAsync(UserNotificationQueryDto dto);

        Task ReadedAsync(Guid[] ids);

        Task<UserNotificationNavbarDto> GetMyNotificationNavbarInfoAsync();
    }
}
