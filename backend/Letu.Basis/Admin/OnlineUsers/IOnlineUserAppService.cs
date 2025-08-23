using Letu.Basis.Admin.OnlineUsers.Dtos;
using Letu.Core.Applications;

namespace Letu.Basis.Admin.OnlineUsers
{
    public interface IOnlineUserAppService
    {
        Task<PagedResult<OnlineUserResultDto>> GetOnlineUserListAsync(OnlineUserSearchDto dto);
    }
}