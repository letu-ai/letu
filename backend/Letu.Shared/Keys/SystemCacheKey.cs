namespace Letu.Shared.Keys
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
        /// 用户权限信息
        /// </summary>
        /// <param name="userId">用户ID</param>
        /// <returns></returns>
        public static string UserPermission(Guid userId) => $"user_permission:{userId}";
    }
}