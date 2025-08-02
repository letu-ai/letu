using FreeSql;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Volo.Abp.Auditing;
using Volo.Abp.AuditLogging;
using Volo.Abp.DependencyInjection;

namespace Letu.Abp.AuditLogging;

/// <summary>
/// 自定义审计日志存储
/// </summary>
public class LetuAuditingStore : IAuditingStore, ITransientDependency
{
    private readonly AbpAuditingOptions options;
    private readonly UnitOfWorkManager unitOfWorkManager;
    private readonly IAuditLogInfoToAuditLogConverter converter;
    private readonly ILogger<LetuAuditingStore> logger;

    public LetuAuditingStore(
        UnitOfWorkManager unitOfWorkManager,
        IOptions<AbpAuditingOptions> options,
        IAuditLogInfoToAuditLogConverter converter,
        ILogger<LetuAuditingStore> logger)
    {
        this.logger = logger;
        this.options = options.Value;
        this.unitOfWorkManager = unitOfWorkManager;
        this.converter = converter;
    }


    public virtual async Task SaveAsync(AuditLogInfo auditInfo)
    {
        if (!options.HideErrors)
        {
            await SaveLogAsync(auditInfo);
            return;
        }

        try
        {
            await SaveLogAsync(auditInfo);
        }
        catch (Exception ex)
        {
            logger.LogWarning("Could not save the audit log object: " + Environment.NewLine + auditInfo.ToString());
            logger.LogException(ex, LogLevel.Error);
        }
    }

    /// <summary>
    /// 保存审计日志
    /// </summary>
    /// <param name="auditInfo">审计日志信息</param>
    public async Task SaveLogAsync(AuditLogInfo auditInfo)
    {
        var auditLog = await converter.ConvertAsync(auditInfo);
        using var uow = unitOfWorkManager.Begin();
        try
        {
            var repo = uow.Orm.GetRepository<AuditLog>();
            repo.DbContextOptions.EnableCascadeSave = true;
            await repo.InsertAsync(auditLog);

            uow.Commit();
        }
        catch
        {
            uow.Rollback();
            throw;
        }
    }
}
