using Letu.Basis.Admin.Loggings;
using Letu.Basis.Admin.Users;
using Letu.Basis.Identity.Dtos;
using Letu.Basis.Settings;
using Letu.Core.AspNetCore.Mvc;
using Letu.Core.Identity.Jwt;
using Letu.Core.Utils;
using Letu.Repository;
using Microsoft.Extensions.Caching.Distributed;
using Microsoft.Extensions.Options;
using System.Security.Claims;
using Volo.Abp;
using Volo.Abp.Caching;
using Volo.Abp.DistributedLocking;
using Volo.Abp.EventBus.Local;
using Volo.Abp.Guids;
using Volo.Abp.Security.Claims;
using Volo.Abp.Settings;
using Volo.Abp.Users;

namespace Letu.Basis.Identity;

public class IdentityAppService : BasisAppService, IIdentityAppService
{
    private readonly IGuidGenerator guidGenerator;
    private readonly JwtOptions jwtOptions;
    private readonly IFreeSqlRepository<User> _userRepository;
    private readonly ILocalEventBus localEventBus;
    private readonly HttpContext _httpContext;
    private readonly IJwtAccessTokenProvider jwtAccessTokenProvider;
    private readonly IDistributedCache<string> accessTokenCache;
    private readonly IDistributedCache<string> refreshTokenCache;
    private readonly IDistributedCache<HashSet<string>> _userSessionIdsCache;
    private readonly IUserRoleFinder _userRoleFinder;
    private readonly IAbpDistributedLock distributedLock;

    public IdentityAppService(
        IGuidGenerator guidGenerator,
        IFreeSqlRepository<User> userRepository,
        ILocalEventBus localEventBus,
        IHttpContextAccessor httpContextAccessor,
        IOptions<JwtOptions> jwtOptions,
        IJwtAccessTokenProvider jwtAccessTokenProvider,
        IDistributedCache<string> accessTokenCache,
        IDistributedCache<string> refreshTokenCache,
        IDistributedCache<HashSet<string>> userSessionIdsCache,
        IUserRoleFinder userRoleFinder,
        IAbpDistributedLock distributedLock)
    {
        this.guidGenerator = guidGenerator;
        this.jwtOptions = jwtOptions.Value;
        this.jwtAccessTokenProvider = jwtAccessTokenProvider;
        _userRepository = userRepository;
        this.localEventBus = localEventBus;
        _httpContext = httpContextAccessor.HttpContext!;
        this.accessTokenCache = accessTokenCache;
        this.refreshTokenCache = refreshTokenCache;
        _userSessionIdsCache = userSessionIdsCache;
        _userRoleFinder = userRoleFinder;
        this.distributedLock = distributedLock;
    }

    public async Task<UserTokenOutput> LoginAsync(LoginInput input)
    {
        // TODO：应记录登录成功，失败和方式
        var loginLog = new SecurityLog
        {
            IsSuccess = true,
            Ip = RequestUtils.GetIp(_httpContext),
            OperationMsg = "登录成功",
            UserName = input.UserName
        };

        try
        {
            var user = await _userRepository.Where(x => x.UserName.Equals(input.UserName, StringComparison.CurrentCultureIgnoreCase) && x.IsEnabled)
                .FirstAsync();

            if (user == null)
                throw HttpFriendlyException.BadRequest("账号或密码错误。")
                    .WithData("UserName", input.UserName);

            if (user.PasswordHash != EncryptionUtils.CalcPasswordHash(input.Password, user.PasswordSalt))
                throw HttpFriendlyException.BadRequest("账号或密码错误。")
                    .WithData("UserName", input.UserName);

            var sessionId = guidGenerator.Create().ToString("N");

            var claims = await CreateUserClaims(user, sessionId);
            var token = CreateToken(claims, user.Id, sessionId);
            loginLog.SessionId = sessionId;

            // 保存用户登录信息到缓存
            await SaveUserLoginInfoToCacheAsync(user, token, sessionId);

            // 设置 JWT Token 到 Cookie 中，用于图片等资源的认证
            SetJwtCookie(token.Token, token.ExpiresAt);

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
            loginLog.Browser = RequestUtils.ResolveBrowser(RequestUtils.GetUserAgent(_httpContext));

            await localEventBus.PublishAsync(loginLog);
        }
    }

    public async Task LogoutAsync()
    {
        if (!CurrentUser.IsAuthenticated)
            return;

        var userId = CurrentUser.GetId();
        var sessionId = CurrentUser.GetSessionId();

        await LogoutAsync(userId, sessionId);

        // 清除 JWT Cookie
        ClearJwtCookie();

        await localEventBus.PublishAsync(new SecurityLog
        {
            IsSuccess = true,
            Ip = RequestUtils.GetIp(_httpContext),
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
        // 获取该会话的 RefreshToken
        var sessionKey = IdentityCacheKeys.CalcRefreshTokenKey(userId, sessionId);
        var refreshToken = await refreshTokenCache.GetAsync(sessionKey);

        // 删除所有相关缓存
        if (!string.IsNullOrEmpty(refreshToken))
        {
            // 删除 RefreshToken 本身的缓存记录
            await refreshTokenCache.RemoveAsync(refreshToken);
        }

        // 删除会话映射和 AccessToken
        await refreshTokenCache.RemoveAsync(sessionKey);
        await accessTokenCache.RemoveAsync(IdentityCacheKeys.CalcAccessTokenKey(userId, sessionId));
    }


    /// <summary>
    /// 验证Token是否有效
    /// </summary>
    /// <param name="userId"></param>
    /// <param name="sessionId"></param>
    /// <param name="token"></param>
    /// <returns></returns>
    public async Task<bool> ValidateTokenAsync(string userId, string sessionId, string token)
    {
        string key = IdentityCacheKeys.CalcAccessTokenKey(userId, sessionId);
        var existToken = await accessTokenCache.GetAsync(key);
        return existToken == token;
    }


    public async Task<UserTokenOutput> RefreshTokenAsync(string refreshToken)
    {
        // 1. 解析 RefreshToken 获取 userId 和 sessionId
        var parts = refreshToken.Split('.');
        if (parts.Length != 3)
        {
            throw HttpFriendlyException.BadRequest("刷新token格式错误");
        }

        var randomPart = parts[0];
        Guid userId;
        string sessionId;

        try
        {
            userId = Guid.Parse(parts[1]);
            sessionId = parts[2];
        }
        catch
        {
            throw HttpFriendlyException.BadRequest("刷新token格式错误");
        }

        // 使用分布式锁防止并发刷新token
        await using var handle = await distributedLock.TryAcquireAsync($"refresh_token:{userId}:{sessionId}", TimeSpan.FromSeconds(10));
        if (handle == null)
        {
            throw HttpFriendlyException.BadRequest("token刷新请求过于频繁，请稍后重试");
        }

        // 创建安全日志记录
        var securityLog = new SecurityLog
        {
            IsSuccess = true,
            Ip = RequestUtils.GetIp(_httpContext),
            OperationMsg = "刷新令牌成功",
            UserName = "", // 稍后填充
            SessionId = sessionId
        };

        try
        {
            // 2. 直接用 RefreshToken 作为键验证缓存
            var tokenValue = await refreshTokenCache.GetAsync(refreshToken);
            if (tokenValue == null)
            {
                throw HttpFriendlyException.BadRequest("刷新token已过期或无效");
            }

            // 3. 验证会话是否还有效（可能被管理员强制下线）
            var sessionKey = IdentityCacheKeys.CalcRefreshTokenKey(userId, sessionId);
            var sessionToken = await refreshTokenCache.GetAsync(sessionKey);
            if (sessionToken != refreshToken)
            {
                throw HttpFriendlyException.BadRequest("会话已被终止");
            }

            // 4. 获取用户信息
            var user = await _userRepository.Where(x => x.Id == userId).FirstAsync();
            if (user == null)
                throw HttpFriendlyException.NotFound("用户不存在");

            securityLog.UserName = user.UserName;

            // 5. 创建用户声明和生成令牌
            var claims = await CreateUserClaims(user, sessionId);
            var token = CreateToken(claims, userId, sessionId);

            // 6. 保存用户登录信息到缓存
            await SaveUserLoginInfoToCacheAsync(user, token, sessionId);

            // 7. 更新 Cookie 中的 JWT Token
            SetJwtCookie(token.Token, token.ExpiresAt);

            return new UserTokenOutput
            {
                AccessToken = token.Token,
                RefreshToken = token.RefreshToken,
                ExpiredTime = token.ExpiresAt
            };
        }
        catch (Exception ex)
        {
            securityLog.IsSuccess = false;
            securityLog.OperationMsg = ex.Message;
            throw;
        }
        finally
        {
            securityLog.Address = RequestUtils.ResolveAddress(securityLog.Ip);
            securityLog.Browser = RequestUtils.ResolveBrowser(RequestUtils.GetUserAgent(_httpContext));
            await localEventBus.PublishAsync(securityLog);
        }
    }


    /// <summary>
    /// 保存用户登录信息到缓存
    /// </summary>
    /// <param name="user">用户</param>
    /// <param name="token">令牌信息</param>
    /// <param name="sessionId"></param>
    /// <returns></returns>
    private async Task SaveUserLoginInfoToCacheAsync(User user, JwtAccessToken token, string sessionId)
    {
        if (await SettingProvider.GetAsync<bool>(IdentitySettingNames.SignIn.AllowMultipleLogin) != true)
        {
            // 移除当前用户的其它登录会话
            var existsSessionIds = await _userSessionIdsCache.GetAsync(IdentityCacheKeys.CalcUserSessionIdKey(user.Id));
            if (existsSessionIds != null)
            {
                foreach (var sid in existsSessionIds)
                {
                    // 获取旧的 RefreshToken
                    var oldRefreshToken = await refreshTokenCache.GetAsync(IdentityCacheKeys.CalcRefreshTokenKey(user.Id, sid));
                    if (!string.IsNullOrEmpty(oldRefreshToken))
                    {
                        // 删除 RefreshToken 本身的缓存记录
                        await refreshTokenCache.RemoveAsync(oldRefreshToken);
                    }

                    await accessTokenCache.RemoveAsync(IdentityCacheKeys.CalcAccessTokenKey(user.Id, sid));
                    await refreshTokenCache.RemoveAsync(IdentityCacheKeys.CalcRefreshTokenKey(user.Id, sid));
                }
                await _userSessionIdsCache.RemoveAsync(IdentityCacheKeys.CalcUserSessionIdKey(user.Id));
            }
        }

        var accessTokenExpired = TimeSpan.FromSeconds(jwtOptions.Issuance.ExpirySeconds);
        var refreshTokenExpired = TimeSpan.FromDays(30); // TODO: RefreshToken过期时间应该从Settings系统读取

        // 获取现有会话ID集合或创建新集合
        var userSessionIds = await _userSessionIdsCache.GetAsync(
            IdentityCacheKeys.CalcUserSessionIdKey(user.Id)) ?? new HashSet<string>();

        // 添加当前会话ID
        userSessionIds.Add(sessionId);

        // 用户会话ID集合的过期时间应该与RefreshToken一致，以保证会话管理的连续性
        await _userSessionIdsCache.SetAsync(
            IdentityCacheKeys.CalcUserSessionIdKey(user.Id),
            userSessionIds,
            new DistributedCacheEntryOptions { AbsoluteExpirationRelativeToNow = refreshTokenExpired }
        );

        await accessTokenCache.SetAsync(
            IdentityCacheKeys.CalcAccessTokenKey(user.Id, sessionId),
            token.Token,
            new DistributedCacheEntryOptions { AbsoluteExpirationRelativeToNow = accessTokenExpired }
        );

        if (token.RefreshToken != null)
        {
            // 双向映射：
            // 1. RefreshToken 本身作为键，值为 "valid"（用于验证 token 有效性）
            await refreshTokenCache.SetAsync(
                token.RefreshToken,
                "valid",
                new DistributedCacheEntryOptions
                {
                    AbsoluteExpirationRelativeToNow = refreshTokenExpired
                }
            );

            // 2. userId:sessionId 作为键，值为 RefreshToken（用于会话管理）
            await refreshTokenCache.SetAsync(
                IdentityCacheKeys.CalcRefreshTokenKey(user.Id, sessionId),
                token.RefreshToken,
                new DistributedCacheEntryOptions
                {
                    AbsoluteExpirationRelativeToNow = refreshTokenExpired
                }
            );
        }
    }

    private async Task<List<Claim>> CreateUserClaims(User user, string sessionId)
    {
        var claims = new List<Claim> {
            new(AbpClaimTypes.UserId, user.Id.ToString()),
            new(AbpClaimTypes.UserName, user.UserName),
            new(AbpClaimTypes.SessionId, sessionId),
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
        var roleNames = await _userRoleFinder.GetRoleNamesAsync(user.Id);
        foreach (var roleName in roleNames)
        {
            claims.Add(new Claim(ClaimTypes.Role, roleName));
        }

        return claims;
    }

    private JwtAccessToken CreateToken(List<Claim> claims, Guid userId, string sessionId)
    {
        var token = jwtAccessTokenProvider.CreateToken(claims, jwtOptions.Issuance.ExpirySeconds);
        // 生成格式化的 RefreshToken: <random>.<userId>.<sessionId>
        var randomToken = guidGenerator.Create().ToString("N").ToLower();
        token.RefreshToken = $"{randomToken}.{userId}.{sessionId}";
        return token;
    }

    /// <summary>
    /// 设置 JWT Token 到 Cookie 中，用于图片等静态资源的认证
    /// </summary>
    /// <param name="token">JWT Token</param>
    /// <param name="expiredTime">过期时间</param>
    private void SetJwtCookie(string token, DateTimeOffset expiredTime)
    {
        var cookieOptions = new CookieOptions
        {
            HttpOnly = true,            // 防止 XSS 攻击，JavaScript 无法访问
            Secure = _httpContext.Request.IsHttps,    // HTTPS 下设置 Secure
            SameSite = SameSiteMode.Lax,              // 防止 CSRF 攻击
            Path = "/",                 // Cookie 路径
            Expires = expiredTime       // 与 JWT 相同的过期时间
        };

        _httpContext.Response.Cookies.Append("jwt-token", token, cookieOptions);
    }

    /// <summary>
    /// 清除 JWT Cookie
    /// </summary>
    private void ClearJwtCookie()
    {
        _httpContext.Response.Cookies.Delete("jwt-token", new CookieOptions
        {
            Path = "/",
            HttpOnly = true,
            Secure = _httpContext.Request.IsHttps,
            SameSite = SameSiteMode.Lax
        });
    }
}