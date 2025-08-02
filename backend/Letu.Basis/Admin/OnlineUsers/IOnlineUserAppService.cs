using Letu.Applications;
using Letu.Basis.Admin.OnlineUsers.Dtos;

namespace Letu.Basis.Admin.OnlineUsers
{
    public interface IOnlineUserAppService
    {
        Task<PagedResult<OnlineUserResultDto>> GetOnlineUserListAsync(OnlineUserSearchDto dto);
    }
}