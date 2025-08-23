using FreeSql;
using Letu.Basis.Admin.Loggings;
using Letu.Basis.Admin.OnlineUsers.Dtos;
using Letu.Basis.Admin.Users;
using Letu.Basis.Identity;
using Letu.Core.Applications;
using Letu.Repository;
using Letu.Shared.Consts;
using Volo.Abp.Application.Services;
using Volo.Abp.Caching;

namespace Letu.Basis.Admin.OnlineUsers;

public class OnlineUserAppService : BasisAppService, IOnlineUserAppService
{
    private readonly IFreeSqlRepository<SecurityLog> _loginLogRepository;
    private readonly IFreeSqlRepository<User> _userRepository;
    private readonly IDistributedCache<string> _accessTokenCache;

    public OnlineUserAppService(IFreeSqlRepository<SecurityLog> loginLogRepository, IFreeSqlRepository<User> userRepository, IDistributedCache<string> accessTokenCache)
    {
        _loginLogRepository = loginLogRepository;
        _userRepository = userRepository;
        _accessTokenCache = accessTokenCache;
    }

    public async Task<PagedResult<OnlineUserResultDto>> GetOnlineUserListAsync(OnlineUserSearchDto dto)
    {
        //有效token时间，1分钟误差
        var time = DateTime.Now.AddHours(-AdminConsts.TokenExpiredHour).AddMinutes(-1);

        var loginLogs = await _loginLogRepository.Where(x => x.CreationTime >= time)
            .Where(x => x.IsSuccess && !string.IsNullOrEmpty(x.SessionId))
            .WhereIf(!string.IsNullOrEmpty(dto.UserName), x => x.UserName.Contains(dto.UserName!))
            .OrderByDescending(x => x.CreationTime).ToListAsync();
        var userNames = loginLogs.Select(x => x.UserName).ToList();
        var users = await _userRepository.Where(x => userNames.Contains(x.UserName)).ToListAsync(x => new { x.Id, x.UserName });

        var list = new List<OnlineUserResultDto>();
        foreach (var loginLog in loginLogs)
        {
            var user = users.FirstOrDefault(x => x.UserName == loginLog.UserName);
            if (user == null) continue;

            if (!string.IsNullOrEmpty(loginLog.SessionId) && await _accessTokenCache.GetAsync(IdentityCacheKeys.CalcAccessTokenKey(user.Id, loginLog.SessionId)) != null)
            {
                list.Add(new OnlineUserResultDto
                {
                    UserId = user.Id,
                    UserName = loginLog.UserName,
                    Ip = loginLog.Ip,
                    Address = loginLog.Address,
                    Browser = loginLog.Browser,
                    CreationTime = loginLog.CreationTime,
                    SessionId = loginLog.SessionId
                });
            }
        }
        var total = list.Count;

        return new PagedResult<OnlineUserResultDto>(dto)
        {
            TotalCount = total,
            Items = list.OrderByDescending(s => s.CreationTime).Skip((dto.Current - 1) * dto.PageSize).Take(dto.PageSize).ToList()
        };
    }
}
