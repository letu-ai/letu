using Letu.Basis.Admin.Loggings;
using Letu.Basis.Admin.Users;
using Letu.Basis.Identity.Dtos;
using Letu.Core.Utils;
using Letu.Identity.Jwt;
using Letu.Repository;
using Letu.Shared.Keys;
using Letu.Utils;
using Microsoft.Extensions.Caching.Distributed;
using Microsoft.Extensions.Options;
using System.Security.Claims;
using Volo.Abp;
using Volo.Abp.Application.Services;
using Volo.Abp.Auditing;
using Volo.Abp.Caching;
using Volo.Abp.EventBus.Local;
using Volo.Abp.Guids;
using Volo.Abp.Security.Claims;
using Volo.Abp.Users;

namespace Letu.Basis.Identity
{
    public class IdentityAppService : ApplicationService, IIdentityAppService
    {
        private readonly IGuidGenerator guidGenerator;
        private readonly JwtAccessTokenOptions jwtAccessTokenOptions;
        private readonly IFreeSqlRepository<User> _userRepository;
        private readonly ILocalEventBus _localEventBus;
        private readonly HttpContext _httpContext;
        private readonly IJwtAccessTokenProvider jwtAccessTokenProvider;
        private readonly IDistributedCache<string> accessTokenCache;
        private readonly IDistributedCache<string> refreshTokenCache;
        private readonly IDistributedCache<HashSet<string>> _userSessionIdsCache;

        public IdentityAppService(
            IGuidGenerator guidGenerator,
            IFreeSqlRepository<User> userRepository,
            ILocalEventBus localEventBus,
            IHttpContextAccessor httpContextAccessor,
            IOptions<JwtAccessTokenOptions> jwtAccessTokenOptions,
            IJwtAccessTokenProvider jwtAccessTokenProvider,
            IDistributedCache<string> accessTokenCache,
            IDistributedCache<string> refreshTokenCache,
            IDistributedCache<HashSet<string>> userSessionIdsCache)
        {
            this.guidGenerator = guidGenerator;
            this.jwtAccessTokenOptions = jwtAccessTokenOptions.Value;
            this.jwtAccessTokenProvider = jwtAccessTokenProvider;
            _userRepository = userRepository;
            _localEventBus = localEventBus;
            _httpContext = httpContextAccessor.HttpContext!;
            this.accessTokenCache = accessTokenCache;
            this.refreshTokenCache = refreshTokenCache;
            _userSessionIdsCache = userSessionIdsCache;
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
                var user = await _userRepository.Where(x => x.UserName.Equals(input.UserName, StringComparison.CurrentCultureIgnoreCase) && x.IsEnabled).FirstAsync();

                if (user == null)
                    throw new BusinessException(message: "账号或密码不存在");

                if (user.Password != EncryptionUtils.CalcPasswordHash(input.Password, user.PasswordSalt))
                    throw new BusinessException(message: "密码错误");

                var sessionId = guidGenerator.Create().ToString("N");

                var claims = CreateUserClaims(user, sessionId);
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

            await LogoutAsync(userId.ToString(), sessionId);
        }

        /// <summary>
        /// 注销指定用户的登录会话。给管理员使用，允许管理员强制用户下线。
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="sessionId"></param>
        /// <returns></returns>
        // TODO：添加权限验证，确保只有管理员可以调用此方法
        public async Task LogoutAsync(string userId, string sessionId)
        {
            await accessTokenCache.RemoveAsync(IdentityCacheKeys.CalcAccessTokenKey(userId, sessionId));
            await refreshTokenCache.RemoveAsync(IdentityCacheKeys.CalcRefreshTokenKey(userId, sessionId));
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
                var claims = CreateUserClaims(user, sessionId);
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
            if (!jwtAccessTokenOptions.AllowMultipleLogin)
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

            var accessTokenExpired = TimeSpan.FromSeconds(jwtAccessTokenOptions.Expiration);
            var refreshTokenExpired = TimeSpan.FromMinutes(jwtAccessTokenOptions.RefreshTokenExpiration);
            
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

        private List<Claim> CreateUserClaims(User user, string sessionId)
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

            return claims;
        }

        private JwtAccessToken CreateToken(List<Claim> claims)
        {
            var token = jwtAccessTokenProvider.CreateToken(claims, jwtAccessTokenOptions.Expiration);
            token.RefreshToken = guidGenerator.Create().ToString("N").ToLower();
            return token;
        }
    }
}