namespace Letu.Basis.Admin.Loggings;

/// <summary>
/// 数据库日志清理服务接口
/// </summary>
public interface IDatabaseLogCleanupService
{
    /// <summary>
    /// 清理过期的业务日志
    /// </summary>
    /// <returns>删除的记录数</returns>
    Task<int> CleanupBusinessLogsAsync();

    /// <summary>
    /// 清理过期的审计日志（包括关联的实体变更和属性变更记录）
    /// </summary>
    /// <returns>删除的记录数</returns>
    Task<int> CleanupAuditLogsAsync();
}

