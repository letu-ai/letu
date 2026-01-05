using Letu.Basis.Admin.Users;
using Letu.Basis.Identity.Dtos;
using Letu.Basis.Settings;
using Letu.Basis.UserSessions;
using Letu.Core.AspNetCore.Mvc;
using Letu.Core.Identity.Jwt;
using Letu.Core.Utils;
using Letu.Logging.SecurtyLogs;
using Letu.Repository;
using Microsoft.Extensions.Caching.Distributed;
using Microsoft.Extensions.Options;
using System.Security.Claims;
using Volo.Abp;
using Volo.Abp.Caching;
using Volo.Abp.DistributedLocking;
using Volo.Abp.EventBus.Local;
using Volo.Abp.Security.Claims;
using Volo.Abp.Settings;
using Volo.Abp.Users;

namespace Letu.Basis.Identity;

public class IdentityAppService : BasisAppService, IIdentityAppService
{
    private readonly JwtOptions jwtOptions;
    private readonly IFreeSqlRepository<User> userRepository;
    private readonly ILocalEventBus localEventBus;
    private readonly HttpContext httpContext;
    private readonly IJwtAccessTokenProvider jwtAccessTokenProvider;
    private readonly IDistributedCache<string> sessionIdCache;
    private readonly IUserRoleFinder userRoleFinder;
    private readonly IAbpDistributedLock distributedLock;
    private readonly IFreeSqlRepository<UserSession> sessionRepository;

    public IdentityAppService(
        IFreeSqlRepository<User> userRepository,
        ILocalEventBus localEventBus,
        IHttpContextAccessor httpContextAccessor,
        IOptions<JwtOptions> jwtOptions,
        IJwtAccessTokenProvider jwtAccessTokenProvider,
        IDistributedCache<string> sessionIdCache,
        IUserRoleFinder userRoleFinder,
        IAbpDistributedLock distributedLock,
        IFreeSqlRepository<UserSession> sessionRepository)
    {
        this.jwtOptions = jwtOptions.Value;
        this.jwtAccessTokenProvider = jwtAccessTokenProvider;
        this.userRepository = userRepository;
        this.localEventBus = localEventBus;
        httpContext = httpContextAccessor.HttpContext!;
        this.sessionIdCache = sessionIdCache;
        this.userRoleFinder = userRoleFinder;
        this.distributedLock = distributedLock;
        this.sessionRepository = sessionRepository;
    }

    public async Task<UserTokenOutput> LoginAsync(LoginInput input)
    {
        // TODO：应记录登录成功，失败和方式
        var loginLog = new SecurityLog
        {
            IsSuccess = true,
            Ip = RequestUtils.GetIp(httpContext),
            OperationMsg = "登录成功",
            UserName = input.UserName
        };

        try
        {
            var user = await userRepository.Where(x => x.UserName.Equals(input.UserName, StringComparison.CurrentCultureIgnoreCase) && x.IsEnabled)
                .FirstAsync();

            if (user == null)
                throw HttpFriendlyException.BadRequest("账号或密码错误。")
                    .WithData("UserName", input.UserName);

            if (user.PasswordHash != EncryptionUtils.CalcPasswordHash(input.Password, user.PasswordSalt))
                throw HttpFriendlyException.BadRequest("账号或密码错误。")
                    .WithData("UserName", input.UserName);

            // 处理多设备登录控制
            if (await SettingProvider.GetAsync<bool>(IdentitySettingNames.SignIn.AllowMultipleLogin) != true)
            {
                await RemoveOtherSessionsAsync(user.Id, input.ClientType);
            }

            var session = await CreateUserSessionAsync(user.Id, LoginChannel.Account, input);
            await CacheUserSessionIdAsync(session);

            var claims = await CreateUserClaims(user, session);
            var token = CreateToken(claims);
            token.RefreshToken = session.RefreshToken;

            CreateCookie(token.Token, token.ExpiresAt); // 设置 JWT Token 到 Cookie 中，用于图片等资源的认证

            // 更新loginLog的SessionId为数据库生成的Id
            loginLog.SessionId = session.Id.ToString();

            return new UserTokenOutput
            {
                AccessToken = token.Token,
                RefreshToken = token.RefreshToken,
                ExpiredTime = token.ExpiresAt
            };
        }
        catch (BusinessException ex)
        {
            loginLog.IsSuccess = false;
            loginLog.OperationMsg = ex.Message;
            throw;
        }
        finally
        {
            loginLog.Address = RequestUtils.ResolveAddress(loginLog.Ip);
            loginLog.Browser = input.DeviceName;

            await localEventBus.PublishAsync(loginLog);
        }
    }

    public async Task LogoutAsync()
    {

        // 清除 JWT Cookie
        ClearJwtCookie();

        if (!CurrentUser.IsAuthenticated)
            return;

        var userId = CurrentUser.GetId();
        var sessionId = CurrentUser.GetSessionId();

        await LogoutAsync(userId, sessionId);

        await localEventBus.PublishAsync(new SecurityLog
        {
            IsSuccess = true,
            Ip = RequestUtils.GetIp(httpContext),
            OperationMsg = "注销成功",
            UserName = CurrentUser.UserName
        });

    }

    /// <summary>
    /// 注销指定用户的登录会话。给管理员使用，允许管理员强制用户下线。
    /// </summary>
    /// <param name="userId"></param>
    /// <param name="sessionId"></param>
    /// <returns></returns>
    // TODO：添加权限验证，确保只有管理员可以调用此方法
    public async Task LogoutAsync(Guid userId, string sessionId)
    {
        var sessionIdGuid = Guid.Parse(sessionId);

        // 1. 标记数据库会话为KickedOut
        var session = await sessionRepository.OneAsync(x => x.UserId == userId && x.Id == sessionIdGuid);
        if (session != null)
        {
            session.Status = SessionStatus.KickedOut;
            await sessionRepository.UpdateAsync(session);
        }

        // 2. 清除Redis缓存
        await sessionIdCache.RemoveAsync(IdentityCacheKeys.CalcUserSessionIdKey(sessionId));
    }

    public async Task<UserTokenOutput> RefreshTokenAsync(string refreshToken)
    {
        // 1. 从数据库查询RefreshToken对应的会话
        var session = await sessionRepository.OneAsync(x => x.RefreshToken == refreshToken);
        if (session == null)
        {
            throw HttpFriendlyException.BadRequest("刷新token无效或已过期");
        }

        // 2. 使用分布式锁
        await using var handle = await distributedLock.TryAcquireAsync($"refresh_token:{refreshToken}", TimeSpan.FromSeconds(10));
        if (handle == null)
            throw HttpFriendlyException.BadRequest("token刷新请求过于频繁，请稍后重试");

        // 3. 验证会话状态
        if (session.Status != SessionStatus.Active)
        {
            var statusMsg = session.Status switch
            {
                SessionStatus.Inactive => "会话已注销",
                SessionStatus.Expired => "会话已过期",
                SessionStatus.KickedOut => "会话已被强制下线",
                _ => "会话状态异常"
            };
            throw HttpFriendlyException.BadRequest(statusMsg);
        }

        // 4. 验证是否过期
        if (session.ExpireTime.HasValue && session.ExpireTime < Clock.Now)
        {
            session.Status = SessionStatus.Expired;
            await sessionRepository.UpdateAsync(session);
            throw HttpFriendlyException.BadRequest("会话已过期");
        }

        // 5. 获取用户信息
        var user = await userRepository.OneAsync(x => x.Id == session.UserId)
            ?? throw HttpFriendlyException.NotFound("用户不存在");

        // 6. 更新数据库会话
        session = await RefreshUserSessionAsync(session);
        await CacheUserSessionIdAsync(session);

        // 7. 创建新Token
        var claims = await CreateUserClaims(user, session);
        var token = CreateToken(claims);
        token.RefreshToken = session.RefreshToken;

        // 9. 更新Cookie
        CreateCookie(token.Token, token.ExpiresAt);

        return new UserTokenOutput
        {
            AccessToken = token.Token,
            RefreshToken = token.RefreshToken,
            ExpiredTime = token.ExpiresAt
        };
    }

    /// <summary>
    /// 保存用户登录信息到Redis
    /// </summary>
    private async Task CacheUserSessionIdAsync(UserSession session)
    {
        var accessTokenExpired = TimeSpan.FromSeconds(jwtOptions.Issuance.ExpirySeconds);

        // Redis缓存AccessToken(性能考虑)
        await sessionIdCache.SetAsync(
            IdentityCacheKeys.CalcUserSessionIdKey(session.Id),
            session.UserId.ToString(),
            new DistributedCacheEntryOptions { AbsoluteExpirationRelativeToNow = accessTokenExpired }
        );
    }

    private async Task<UserSession> CreateUserSessionAsync(Guid userId, LoginChannel loginChannel, LoginInput input)
    {
        var rememberMeDays = await SettingProvider.GetAsync<int>(IdentitySettingNames.SignIn.RememberMeDurationDays);
        var expireTime = Clock.Now.AddDays(rememberMeDays);

        var session = new UserSession
        {
            UserId = userId,
            ClientType = input.ClientType,
            IpAddress = RequestUtils.GetIp(httpContext),
            Geo = RequestUtils.ResolveAddress(RequestUtils.GetIp(httpContext)),
            UserAgent = RequestUtils.GetUserAgent(httpContext),
            AppVersion = input.AppVersion,
            DeviceId = input.DeviceId,
            DeviceName = input.DeviceName,
            RefreshToken = Guid.NewGuid().ToString("N"),
            LoginChannel = loginChannel,
            LastActiveTime = Clock.Now,
            ExpireTime = expireTime,
            Status = SessionStatus.Active
        };

        return await sessionRepository.InsertAsync(session);
    }

    private async Task<UserSession> RefreshUserSessionAsync(UserSession session)
    {
        session.RefreshToken = Guid.NewGuid().ToString("N");
        session.LastActiveTime = Clock.Now;
        session.ExpireTime = Clock.Now.AddDays(await SettingProvider.GetAsync<int>(IdentitySettingNames.SignIn.RememberMeDurationDays));
        await sessionRepository.UpdateAsync(session);
        return session;
    }

    /// <summary>
    /// 踢出相同类型其他客户端的会话(当不允许多设备登录时)
    /// </summary>
    private async Task RemoveOtherSessionsAsync(Guid userId, ClientType clientType)
    {
        var activeSessions = await sessionRepository
            .Where(s => s.UserId == userId && s.ClientType == clientType && s.Status == SessionStatus.Active)
            .ToListAsync();

        foreach (var session in activeSessions)
        {
            // 标记为被踢下线
            session.Status = SessionStatus.KickedOut;

            // 清除Redis缓存
            await sessionIdCache.RemoveAsync(IdentityCacheKeys.CalcUserSessionIdKey(session.Id));
        }
        await sessionRepository.UpdateAsync(activeSessions);
    }

    private async Task<List<Claim>> CreateUserClaims(User user, UserSession session)
    {
        var claims = new List<Claim> {
            new(AbpClaimTypes.UserId, user.Id.ToString()),
            new(AbpClaimTypes.UserName, user.UserName),
            new(AbpClaimTypes.SessionId, session.Id.ToString("N")),
        };

        if (user.TenantId.HasValue)
        {
            claims.Add(new Claim(AbpClaimTypes.TenantId, user.TenantId.Value.ToString()));
        }

        if (user.NickName != null)
        {
            claims.Add(new Claim(AbpClaimTypes.Name, user.NickName));
        }

        // 获取用户角色并添加到claims中
        var roleNames = await userRoleFinder.GetRoleNamesAsync(user.Id);
        foreach (var roleName in roleNames)
        {
            claims.Add(new Claim(ClaimTypes.Role, roleName));
        }

        return claims;
    }

    private JwtAccessToken CreateToken(List<Claim> claims)
    {
        var token = jwtAccessTokenProvider.CreateToken(claims, jwtOptions.Issuance.ExpirySeconds);
        return token;
    }

    /// <summary>
    /// 设置 JWT Token 到 Cookie 中，用于图片等静态资源的认证
    /// </summary>
    /// <param name="token">JWT Token</param>
    /// <param name="expiredTime">过期时间</param>
    private void CreateCookie(string token, DateTimeOffset expiredTime)
    {
        var cookieOptions = new CookieOptions
        {
            HttpOnly = true,            // 防止 XSS 攻击，JavaScript 无法访问
            Secure = httpContext.Request.IsHttps,    // HTTPS 下设置 Secure
            SameSite = SameSiteMode.Lax,              // 防止 CSRF 攻击
            Path = "/",                 // Cookie 路径
            Expires = expiredTime       // 与 JWT 相同的过期时间
        };

        httpContext.Response.Cookies.Append("jwt-token", token, cookieOptions);
    }

    /// <summary>
    /// 清除 JWT Cookie
    /// </summary>
    private void ClearJwtCookie()
    {
        httpContext.Response.Cookies.Delete("jwt-token", new CookieOptions
        {
            Path = "/",
            HttpOnly = true,
            Secure = httpContext.Request.IsHttps,
            SameSite = SameSiteMode.Lax
        });
    }
}