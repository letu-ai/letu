using Letu.Admin.IService.Monitor.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Admin.IService.Monitor
{
    public interface IOnlineUserService : IScopedDependency
    {
        Task<PagedResult<OnlineUserResultDto>> GetOnlineUserListAsync(OnlineUserSearchDto dto);

        Task LogoutAsync(string key);
    }
}