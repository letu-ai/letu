using Letu.Basis.Account.Dtos;
using Letu.Basis.Admin.Loggings;
using Letu.Basis.Admin.Users;
using Letu.Core.Applications;
using Letu.Core.AspNetCore.Mvc;
using Letu.Core.Utils;
using Letu.Repository;
using Volo.Abp.EventBus.Local;

namespace Letu.Basis.Account;

public class AccountAppService : BasisAppService, IAccountAppService
{
    private readonly IFreeSqlRepository<User> userRepository;
    private readonly IFreeSqlRepository<SecurityLog> securityLogRepository;

    public AccountAppService(
        IFreeSqlRepository<User> userRepository,
        IFreeSqlRepository<SecurityLog> securityLogRepository,
        ILocalEventBus localEventBus)
    {
        this.userRepository = userRepository;
        this.securityLogRepository = securityLogRepository;
    }

    public async Task<bool> UpdateUserInfoAsync(UserInfoUpdateInput input)
    {
        var user = await userRepository.Where(x => x.Id == CurrentUser.Id).FirstAsync();
        if (!string.IsNullOrEmpty(input.NickName))
        {
            if (user.NickName.ToLower() != input.NickName!.ToLower())
            {
                var exist = await userRepository.Where(x => x.NickName.ToLower() == input.NickName.ToLower()).AnyAsync();
                if (exist)
                    throw HttpFriendlyException.BadRequest($"昵称{input.NickName}已使用。");
            }
            user.NickName = input.NickName;
        }

        if (!string.IsNullOrEmpty(input.Avatar))
        {
            user.Avatar = input.Avatar;
        }

        await userRepository.UpdateAsync(user);
        return true;
    }

    public async Task<bool> ChangePasswordAsync(ChangePasswordInput input)
    {
        var user = await userRepository.Where(x => x.Id == CurrentUser.Id).FirstAsync()
            ?? throw HttpFriendlyException.NotFound("用户不存在");

        if (user.PasswordHash != null)
        {
            if (string.IsNullOrEmpty(input.OldPassword))
                throw HttpFriendlyException.BadRequest("请输入旧密码");

            var isRight = user.PasswordHash == EncryptionUtils.CalcPasswordHash(input.OldPassword, user.PasswordSalt);
            if (!isRight)
                throw HttpFriendlyException.BadRequest("旧密码错误");
        }

        user.PasswordSalt = EncryptionUtils.GetPasswordSalt();
        user.PasswordHash = EncryptionUtils.CalcPasswordHash(input.NewPassword, user.PasswordSalt);
        await userRepository.UpdateAsync(user);
        return true;
    }

    public async Task<PagedResult<SecurityLogListDto>> GetSecurityLogsAsync(SecurityLogQueryInput input)
    {
        var query = securityLogRepository.Select
            .Where(x => x.UserName == CurrentUser.UserName)
            .WhereIf(input.StartDate.HasValue, x => x.CreationTime >= input.StartDate!.Value)
            .WhereIf(input.EndDate.HasValue, x => x.CreationTime <= input.EndDate!.Value.AddDays(1))
            .WhereIf(input.IsSuccess.HasValue, x => x.IsSuccess == input.IsSuccess!.Value)
            .WhereIf(!string.IsNullOrEmpty(input.Ip), x => x.Ip!.Contains(input.Ip!))
            .OrderByDescending(x => x.CreationTime);

        var totalCount = await query.CountAsync();
        var items = await query
            .Page(input.Current, input.PageSize)
            .ToListAsync();

        var dtos = ObjectMapper.Map<List<SecurityLog>, List<SecurityLogListDto>>(items);

        return new PagedResult<SecurityLogListDto>
        {
            Items = dtos,
            TotalCount = totalCount
        };
    }

    public async Task<SecurityLogStatsDto> GetSecurityLogStatsAsync()
    {
        var today = DateTime.Today;

        // 今日登录次数
        var todayLoginCount = await securityLogRepository.Select
            .Where(x => x.UserName == CurrentUser.UserName)
            .Where(x => x.CreationTime >= today && x.CreationTime < today.AddDays(1))
            .Where(x => x.IsSuccess)
            .CountAsync();

        // 最近登录记录
        var recentLogin = await securityLogRepository.Select
            .Where(x => x.UserName == CurrentUser.UserName && x.IsSuccess)
            .OrderByDescending(x => x.CreationTime)
            .FirstAsync();

        // 异常登录次数（今天失败的登录）
        var abnormalLoginCount = await securityLogRepository.Select
            .Where(x => x.UserName == CurrentUser.UserName)
            .Where(x => x.CreationTime >= today && x.CreationTime < today.AddDays(1))
            .Where(x => !x.IsSuccess)
            .CountAsync();

        // 总登录次数
        var totalLoginCount = await securityLogRepository.Select
            .Where(x => x.UserName == CurrentUser.UserName && x.IsSuccess)
            .CountAsync();

        return new SecurityLogStatsDto
        {
            TodayLoginCount = (int)todayLoginCount,
            RecentLoginIp = recentLogin?.Ip,
            AbnormalLoginCount = (int)abnormalLoginCount,
            TotalLoginCount = (int)totalLoginCount
        };
    }
}