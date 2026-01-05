using Letu.Basis.Admin.OnlineUsers.Dtos;
using Letu.Basis.Admin.Users;
using Letu.Basis.UserSessions;
using Letu.Core.Applications;
using Letu.Repository;

namespace Letu.Basis.Admin.OnlineUsers;

public class OnlineUserAppService : BasisAppService, IOnlineUserAppService
{
    private readonly IFreeSqlRepository<UserSession> sessionRepository;

    public OnlineUserAppService(IFreeSqlRepository<UserSession> sessionRepository)
    {
        this.sessionRepository = sessionRepository;
    }

    public async Task<PagedResult<OnlineUserListOutput>> GetOnlineUserListAsync(OnlineUserListInput dto)
    {
        var now = DateTime.Now;

        // 查询在线会话：状态为Active且未过期
        var items = await sessionRepository.Select
            .Where(x => x.Status == SessionStatus.Active)
            .Where(x => x.ExpireTime == null || x.ExpireTime > now)
            .WhereIf(!string.IsNullOrEmpty(dto.UserName), x => x.User!.UserName == dto.UserName!)
            .Count(out var total)
            .Page(dto.Current, dto.PageSize)
            .ToListAsync(x => new OnlineUserListOutput
            {
                UserId = x.UserId,
                UserName = x.User!.UserName,
                IpAddress = x.IpAddress,
                Geo = x.Geo,
                UserAgent = x.UserAgent,
                AppVersion = x.AppVersion,
                DeviceName = x.DeviceName,
                CreationTime = x.CreationTime,
                SessionId = x.Id,
                ClientType = x.ClientType,
                LoginChannel = x.LoginChannel,
                LastActiveTime = x.LastActiveTime
            });

        return new PagedResult<OnlineUserListOutput>(total, items);
    }
}
