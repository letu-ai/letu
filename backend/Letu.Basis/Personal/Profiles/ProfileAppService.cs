using Letu.Basis.Admin.Loggings;
using Letu.Basis.Admin.Users;
using Letu.Basis.Oss;
using Letu.Basis.Personal.Profiles.Dtos;
using Letu.Core.Applications;
using Letu.Core.AspNetCore.Mvc;
using Letu.Core.Utils;
using Letu.Repository;
using Volo.Abp.BlobStoring;
using Volo.Abp.EventBus.Local;

namespace Letu.Basis.Personal.Profiles;

public class ProfileAppService : BasisAppService, IProfileAppService
{
    private readonly IFreeSqlRepository<User> userRepository;
    private readonly IFreeSqlRepository<SecurityLog> securityLogRepository;
    private readonly ILocalEventBus localEventBus;
    private readonly IBlobContainer<AvatarBlobContainer> avatarBlobContainer;
    private readonly HttpContext httpContext;

    public ProfileAppService(
        IFreeSqlRepository<User> userRepository,
        IFreeSqlRepository<SecurityLog> securityLogRepository,
        ILocalEventBus localEventBus,
        IHttpContextAccessor httpContextAccessor,
        IBlobContainer<AvatarBlobContainer> avatarBlobContainer)
    {
        this.userRepository = userRepository;
        this.securityLogRepository = securityLogRepository;
        this.localEventBus = localEventBus;
        this.avatarBlobContainer = avatarBlobContainer;
        httpContext = httpContextAccessor.HttpContext!;
    }

    public async Task<ProfileOutput> GetProfileAsync()
    {
        var user = await userRepository.Where(x => x.Id == CurrentUser.Id).FirstAsync()
                     ?? throw HttpFriendlyException.NotFound("用户不存在");

        var profile = ObjectMapper.Map<User, ProfileOutput>(user);
        profile.HasPassword = user.PasswordHash != null;
        return profile;
    }

    public async Task<ProfileOutput> UpdateProfileAsync(ProfileUpdateInput input)
    {
        var user = await userRepository.Where(x => x.Id == CurrentUser.Id).FirstAsync()
            ?? throw HttpFriendlyException.NotFound("要更新的用户不存在");

        ObjectMapper.Map(input, user);

        await userRepository.UpdateAsync(user);
        var profile = ObjectMapper.Map<User, ProfileOutput>(user);
        profile.HasPassword = user.PasswordHash != null;
        return profile;
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

        await localEventBus.PublishAsync(new SecurityLog
        {
            IsSuccess = true,
            Ip = RequestUtils.GetIp(httpContext),
            OperationMsg = "修改密码",
            UserName = CurrentUser.UserName
        });

        return true;
    }

    public async Task<(Stream?, string)> GetAvatarAsync(CancellationToken cancellationToken = default)
    {
        var user = await userRepository.Where(x => x.Id == CurrentUser.Id).FirstAsync(cancellationToken)
            ?? throw HttpFriendlyException.NotFound("用户不存在");

        if (string.IsNullOrEmpty(user.Avatar))
        {
            return (null, "");
        }

        if (await avatarBlobContainer.ExistsAsync(user.Avatar))
        {
            var stream = await avatarBlobContainer.GetAsync(user.Avatar, cancellationToken);
            return (stream, MimeMapper.GetContentType(user.Avatar));
        }
        else
        {
            return (null, "");
        }
    }

    public async Task<string> UploadAvatarAsync(AvatarUploadInput input)
    {
        var fileName = $"{CurrentUser.Id}/{Path.GetFileName(input.Avatar.FileName)}";
        using var avatarStream = input.Avatar.OpenReadStream();
        await avatarBlobContainer.SaveAsync(fileName, avatarStream, overrideExisting: true);
        var user = await userRepository.Where(x => x.Id == CurrentUser.Id).FirstAsync();
        user.Avatar = fileName;
        await userRepository.UpdateAsync(user);

        return fileName;
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