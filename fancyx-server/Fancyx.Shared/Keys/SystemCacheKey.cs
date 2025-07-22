﻿namespace Fancyx.Shared.Keys
{
    /// <summary>
    /// 系统模块缓存键
    /// </summary>
    public class SystemCacheKey
    {
        /// <summary>
        /// 所有租户缓存键
        /// </summary>
        public const string AllTenant = "all_tenants";

        /// <summary>
        /// 系统配置缓存键
        /// </summary>
        public const string SystemConfig = "system_config";

        /// <summary>
        /// 系统配置组缓存键
        /// </summary>
        /// <param name="group"></param>
        /// <returns></returns>
        public static string SystemConfigGroup(string group) => $"system_config_group:{group.ToLower()}";

        /// <summary>
        /// 访问令牌
        /// </summary>
        /// <param name="userId">用户ID(Guid)</param>
        /// <param name="sessionId">会话ID</param>
        /// <returns></returns>
        public static string AccessToken(Guid userId, string sessionId) => $"access_token:{userId}:{sessionId}";

        /// <summary>
        /// 访问令牌
        /// </summary>
        /// <param name="userId">用户ID(string)</param>
        /// <param name="sessionId">会话ID</param>
        /// <returns></returns>
        public static string AccessToken(string userId, string sessionId) => $"access_token:{userId}:{sessionId}";

        /// <summary>
        /// 访问令牌
        /// </summary>
        /// <param name="key">用户ID:会话ID</param>
        /// <returns></returns>
        public static string AccessToken(string key) => $"access_token:{key}";

        /// <summary>
        /// 刷新令牌
        /// </summary>
        /// <param name="userId">用户ID</param>
        /// <param name="sessionId">会话ID</param>
        /// <returns></returns>
        public static string RefreshToken(Guid userId, string sessionId) => $"refresh_token:{userId}:{sessionId}";

        /// <summary>
        /// 刷新令牌
        /// </summary>
        /// <param name="key">用户ID:会话ID</param>
        /// <returns></returns>
        public static string RefreshToken(string key) => $"refresh_token:{key}";

        /// <summary>
        /// 用户权限信息
        /// </summary>
        /// <param name="userId">用户ID</param>
        /// <returns></returns>
        public static string UserPermission(Guid userId) => $"user_permission:{userId}";

        /// <summary>
        /// 用户会话ID
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public static string UserSessionId(Guid userId) => $"user_session:{userId}";

        /// <summary>
        /// 登录验证码
        /// </summary>
        /// <param name="phone"></param>
        /// <returns></returns>
        public static string LoginSmsCode(string phone) => $"Admin:LoginSmsCode:{phone}";
    }
}