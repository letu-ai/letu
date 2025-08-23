using Letu.Basis.Admin.Loggings;
using Letu.Basis.Admin.Users;
using Letu.Basis.Identity.Dtos;
using Letu.Basis.Settings;
using Letu.Basis.SharedService;
using Letu.Core.Identity.Jwt;
using Letu.Core.Utils;
using Letu.Repository;
using Microsoft.Extensions.Caching.Distributed;
using Microsoft.Extensions.Options;
using System.Security.Claims;
using Volo.Abp;
using Volo.Abp.Auditing;
using Volo.Abp.Caching;
using Volo.Abp.DistributedLocking;
using Volo.Abp.EventBus.Local;
using Volo.Abp.Guids;
using Volo.Abp.Security.Claims;
using Volo.Abp.Settings;
using Volo.Abp.Users;

namespace Letu.Basis.Identity
{
    public class IdentityAppService : BasisAppService, IIdentityAppService
    {
        private readonly IGuidGenerator guidGenerator;
        private readonly JwtOptions jwtOptions;
        private readonly IFreeSqlRepository<User> _userRepository;
        private readonly ILocalEventBus _localEventBus;
        private readonly HttpContext _httpContext;
        private readonly IJwtAccessTokenProvider jwtAccessTokenProvider;
        private readonly IdentitySharedService identitySharedService;
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
            IdentitySharedService identitySharedService,
            IDistributedCache<string> accessTokenCache,
            IDistributedCache<string> refreshTokenCache,
            IDistributedCache<HashSet<string>> userSessionIdsCache,
            IUserRoleFinder userRoleFinder,
            IAbpDistributedLock distributedLock)
        {
            this.guidGenerator = guidGenerator;
            this.jwtOptions = jwtOptions.Value;
            this.jwtAccessTokenProvider = jwtAccessTokenProvider;
            this.identitySharedService = identitySharedService;
            _userRepository = userRepository;
            _localEventBus = localEventBus;
            _httpContext = httpContextAccessor.HttpContext!;
            this.accessTokenCache = accessTokenCache;
            this.refreshTokenCache = refreshTokenCache;
            _userSessionIdsCache = userSessionIdsCache;
            _userRoleFinder = userRoleFinder;
            this.distributedLock = distributedLock;
        }

        [DisableAuditing]
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
                    throw new BusinessException(message: "账号或密码不存在");

                if (user.Password != EncryptionUtils.CalcPasswordHash(input.Password, user.PasswordSalt))
                    throw new BusinessException(message: "密码错误");

                var sessionId = guidGenerator.Create().ToString("N");

                var claims = await CreateUserClaims(user, sessionId);
                var token = CreateToken(claims);
                loginLog.SessionId = sessionId;

                // 保存用户登录信息到缓存
                await SaveUserLoginInfoToCacheAsync(user, token, sessionId);

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
                await _localEventBus.PublishAsync(loginLog);
            }
        }

        public async Task LogoutAsync()
        {
            if (!CurrentUser.IsAuthenticated)
                return;

            var userId = CurrentUser.GetId();
            var sessionId = CurrentUser.GetSessionId();

            await LogoutAsync(userId, sessionId);
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
            await accessTokenCache.RemoveAsync(IdentityCacheKeys.CalcAccessTokenKey(userId, sessionId));
            await refreshTokenCache.RemoveAsync(IdentityCacheKeys.CalcRefreshTokenKey(userId, sessionId));
            await identitySharedService.RemoveUserPermissionCacheByUserIdAsync(userId);
        }


        /// <summary>
        /// 验证Token是否有效
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="sessionId"></param>
        /// <param name="token"></param>
        /// <returns></returns>
        [DisableAuditing]
        public async Task<bool> ValidateTokenAsync(string userId, string sessionId, string token)
        {
            string key = IdentityCacheKeys.CalcAccessTokenKey(userId, sessionId);
            var existToken = await accessTokenCache.GetAsync(key);
            return existToken == token;
        }


        [DisableAuditing]
        public async Task<UserTokenOutput> RefreshTokenAsync(string refreshToken)
        {
            var sessionId = CurrentUser.GetSessionId();
            var userId = CurrentUser.GetId();

            // 使用分布式锁防止并发刷新token

            await using var handle = await distributedLock.TryAcquireAsync(nameof(IdentityAppService), TimeSpan.FromSeconds(10));
            if (handle == null)
            {
                throw new BusinessException(message: "token刷新请求过于频繁，请稍后重试");
            }

            // 创建安全日志记录
            var securityLog = new SecurityLog
            {
                IsSuccess = true,
                Ip = RequestUtils.GetIp(_httpContext),
                OperationMsg = "刷新令牌成功",
                UserName = CurrentUser.UserName!,
                SessionId = CurrentUser.GetSessionId()
            };

            try
            {
                var existRefreshToken = await refreshTokenCache.GetAsync(IdentityCacheKeys.CalcRefreshTokenKey(userId, sessionId))
                    ?? throw new BusinessException(message: "刷新token已过期");

                if (!refreshToken.Equals(existRefreshToken))
                    throw new BusinessException(message: "刷新token不正确");

                // 获取用户信息
                var user = await _userRepository.Where(x => x.Id == userId).FirstAsync();
                if (user == null)
                    throw new BusinessException(message: "用户不存在");

                // 创建用户声明和生成令牌
                var claims = await CreateUserClaims(user, sessionId);
                var token = CreateToken(claims);

                // 保存用户登录信息到缓存
                await SaveUserLoginInfoToCacheAsync(user, token, sessionId);

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
                await _localEventBus.PublishAsync(securityLog);
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

        private JwtAccessToken CreateToken(List<Claim> claims)
        {
            var token = jwtAccessTokenProvider.CreateToken(claims, jwtOptions.Issuance.ExpirySeconds);
            token.RefreshToken = guidGenerator.Create().ToString("N").ToLower();
            return token;
        }
    }
}