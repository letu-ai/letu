using Letu.Basis.Admin.OnlineUsers.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Basis.Admin.OnlineUsers
{
    public interface IOnlineUserAppService : IScopedDependency
    {
        Task<PagedResult<OnlineUserResultDto>> GetOnlineUserListAsync(OnlineUserSearchDto dto);

        Task LogoutAsync(string key);
    }
}