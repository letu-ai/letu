namespace Letu.Repository;

internal static class TenantManager
{
    // 租户ID -> 表后缀 的懒加载缓存
    private static readonly Dictionary<Guid, int> tenantSuffixCache = new();
    private static readonly object locker = new();

    // IFreeSql 实例（用于查询租户表后缀）
    private static IFreeSql? freeSql;

    public static void Initialize(IFreeSql freeSql)
    {
        TenantManager.freeSql = freeSql;
    }

    /// <summary>
    /// 根据租户ID获取格式化的表后缀字符串（如 "-T0001"）
    /// </summary>
    /// <param name="tenantId">租户ID</param>
    /// <returns>格式化的表后缀字符串，如果租户ID无效或查询失败返回null</returns>
    public static string? GetTableSuffixString(Guid tenantId)
    {
        var suffix = GetTableSuffix(tenantId);
        if (suffix < 1 || suffix > 9999)
        {
            return null;
        }
        return $"-T{suffix:D4}";
    }

    /// <summary>
    /// 根据租户ID获取表后缀数字
    /// </summary>
    /// <param name="tenantId">租户ID</param>
    /// <returns>表后缀数字（1-9999），如果查询失败返回0</returns>
    private static int GetTableSuffix(Guid tenantId)
    {
        if (tenantSuffixCache.TryGetValue(tenantId, out var suffix))
        {
            return suffix;
        }

        lock (locker)
        {
            // 双重检查
            if (tenantSuffixCache.TryGetValue(tenantId, out suffix))
            {
                return suffix;
            }

            // 从数据库查询（使用 Ado 直接执行 SQL，避免编译时依赖）
            if (freeSql != null)
            {
                try
                {
                    // 直接查询 sys_tenant 表获取表后缀
                    var sql = "SELECT table_suffix FROM sys_tenant WHERE id = @tenantId";
                    suffix = freeSql.Ado.QuerySingle<int>(sql, new { tenantId });

                    if (suffix > 0)
                    {
                        tenantSuffixCache[tenantId] = suffix;
                        return suffix;
                    }
                }
                catch
                {
                    // 如果查询失败，返回 0
                    return 0;
                }
            }

            return 0;
        }
    }
}