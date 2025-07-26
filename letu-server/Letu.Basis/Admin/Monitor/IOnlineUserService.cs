using Letu.Basis.Admin.Monitor.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Basis.Admin.Monitor
{
    public interface IOnlineUserService : IScopedDependency
    {
        Task<PagedResult<OnlineUserResultDto>> GetOnlineUserListAsync(OnlineUserSearchDto dto);

        Task LogoutAsync(string key);
    }
}