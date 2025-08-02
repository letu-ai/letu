namespace Letu.Basis.Identity
{
    /// <summary>
    /// 身份认证缓存帮助类
    /// </summary>
    public static class IdentityCacheKeys
    {
        /// <summary>
        /// 访问令牌
        /// </summary>
        /// <param name="userId">用户ID(Guid)</param>
        /// <param name="sessionId">会话ID</param>
        /// <returns></returns>
        public static string CalcAccessTokenKey(Guid userId, string sessionId) => CalcAccessTokenKey(userId.ToString(), sessionId);

        public static string CalcAccessTokenKey(string userId, string sessionId) => $"access_tokens:{userId}:{sessionId}";


        /// <summary>
        /// 刷新令牌
        /// </summary>
        /// <param name="userId">用户ID</param>
        /// <param name="sessionId">会话ID</param>
        /// <returns></returns>
        public static string CalcRefreshTokenKey(Guid userId, string sessionId) => CalcRefreshTokenKey(userId.ToString(), sessionId);

        public static string CalcRefreshTokenKey(string userId, string sessionId) => $"refresh_tokens:{userId}:{sessionId}";

        /// <summary>
        /// 用户会话ID
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public static string CalcUserSessionIdKey(Guid userId) => CalcUserSessionIdKey(userId.ToString());
        public static string CalcUserSessionIdKey(string userId) => $"user_sessions:{userId}";
    }
}