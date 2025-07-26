using Letu.Basis.IService.Monitor.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Basis.IService.Monitor
{
    public interface IOnlineUserService : IScopedDependency
    {
        Task<PagedResult<OnlineUserResultDto>> GetOnlineUserListAsync(OnlineUserSearchDto dto);

        Task LogoutAsync(string key);
    }
}