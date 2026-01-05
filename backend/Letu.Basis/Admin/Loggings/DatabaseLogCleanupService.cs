using FreeSql;
using Letu.Logging;
using Letu.Logging.BusinessLogs;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Volo.Abp.AuditLogging;
using Volo.Abp.DependencyInjection;

namespace Letu.Basis.Admin.Loggings;

/// <summary>
/// 数据库日志清理服务
/// </summary>
public class DatabaseLogCleanupService : IDatabaseLogCleanupService, ITransientDependency
{
    private readonly IFreeSql freeSql;
    private readonly ILogger<DatabaseLogCleanupService> logger;
    private readonly IOptions<LogManagementOptions> logManagementOptions;

    public DatabaseLogCleanupService(
        IFreeSql freeSql,
        ILogger<DatabaseLogCleanupService> logger,
        IOptions<LogManagementOptions> logManagementOptions)
    {
        this.freeSql = freeSql;
        this.logger = logger;
        this.logManagementOptions = logManagementOptions;
    }

    /// <summary>
    /// 清理过期的业务日志
    /// </summary>
    public async Task<int> CleanupBusinessLogsAsync()
    {
        try
        {
            var retentionDays = logManagementOptions.Value.BusinessLog.RetentionDays;
            var cutoffDate = DateTime.Now.Date.AddDays(-retentionDays);

            // 删除 CreationTime 早于截止日期的业务日志
            var deletedCount = await freeSql.Delete<BusinessLog>()
                .Where(x => x.CreationTime < cutoffDate)
                .ExecuteAffrowsAsync();

            return deletedCount;
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "清理业务日志时发生错误");
            throw;
        }
    }

    /// <summary>
    /// 清理过期的审计日志（包括关联的实体变更和属性变更记录）
    /// </summary>
    public async Task<int> CleanupAuditLogsAsync()
    {
        try
        {
            var retentionDays = logManagementOptions.Value.AuditLog.RetentionDays;
            var cutoffDate = DateTime.Now.Date.AddDays(-retentionDays);

            // 查询需要删除的审计日志ID列表
            var auditLogIds = await freeSql.Select<AuditLog>()
                .Where(x => x.ExecutionTime < cutoffDate)
                .ToListAsync(x => x.Id);

            if (auditLogIds.Count == 0)
            {
                return 0;
            }

            var totalDeletedCount = 0;

            // 查询需要删除的实体变更记录ID
            var entityChangeIds = await freeSql.Select<EntityChange>()
                .Where(x => auditLogIds.Contains(x.AuditLogId))
                .ToListAsync(x => x.Id);

            if (entityChangeIds.Count > 0)
            {
                // 批量删除关联的属性变更记录
                var propertyChangeDeletedCount = await freeSql.Delete<EntityPropertyChange>()
                    .Where(x => entityChangeIds.Contains(x.EntityChangeId))
                    .ExecuteAffrowsAsync();

                totalDeletedCount += propertyChangeDeletedCount;

                // 批量删除关联的实体变更记录
                var entityChangeDeletedCount = await freeSql.Delete<EntityChange>()
                    .Where(x => entityChangeIds.Contains(x.Id))
                    .ExecuteAffrowsAsync();

                totalDeletedCount += entityChangeDeletedCount;
            }

            // 批量删除审计日志操作记录
            var actionDeletedCount = await freeSql.Delete<AuditLogAction>()
                .Where(x => auditLogIds.Contains(x.AuditLogId))
                .ExecuteAffrowsAsync();

            totalDeletedCount += actionDeletedCount;

            // 最后删除审计日志主记录
            var auditLogDeletedCount = await freeSql.Delete<AuditLog>()
                .Where(x => auditLogIds.Contains(x.Id))
                .ExecuteAffrowsAsync();

            totalDeletedCount += auditLogDeletedCount;

            return auditLogDeletedCount; // 返回主记录删除数
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "清理审计日志时发生错误");
            throw;
        }
    }
}

