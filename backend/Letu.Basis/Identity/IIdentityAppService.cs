using Letu.Basis.Identity.Dtos;

namespace Letu.Basis.Identity
{
    public interface IIdentityAppService
    {
        /// <summary>
        /// 登录
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        Task<UserTokenOutput> LoginAsync(LoginInput input);

        /// <summary>
        /// 注销当前用户会话
        /// </summary>
        /// <returns></returns>
        Task LogoutAsync();

        /// <summary>
        /// 注销指定用户会话
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="sessionId"></param>
        /// <returns></returns>
        Task LogoutAsync(string userId, string sessionId);

        /// <summary>
        /// 刷新token
        /// </summary>
        /// <param name="refreshToken"></param>
        /// <returns></returns>
        Task<UserTokenOutput> RefreshTokenAsync(string refreshToken);
        Task<bool> ValidateTokenAsync(string userId, string sessionId, string token);
    }
} 