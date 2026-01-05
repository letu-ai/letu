using Letu.Basis.Admin.Tenants;
using Letu.Repository;
using Microsoft.Extensions.Options;
using System.Diagnostics;
using Volo.Abp.BackgroundWorkers;
using Volo.Abp.MultiTenancy;
using Volo.Abp.Threading;
using Volo.Abp.Timing;

namespace Letu.Basis.UserSessions;

/// <summary>
/// 会话清理后台任务
/// </summary>
public class UserSessionCleanupWorker : AsyncPeriodicBackgroundWorkerBase
{
    private readonly ILogger<UserSessionCleanupWorker> logger;
    private readonly IClock clock;
    private readonly UserSessionCleanupOptions options;
    private readonly AbpMultiTenancyOptions multiTenancyOptions;

    public UserSessionCleanupWorker(
        AbpAsyncTimer timer,
        IServiceScopeFactory serviceScopeFactory,
        ILogger<UserSessionCleanupWorker> logger,
        IClock clock,
        IOptions<UserSessionCleanupOptions> options,
        IOptions<AbpMultiTenancyOptions> multiTenancyOptions
        )
        : base(timer, serviceScopeFactory)
    {
        this.logger = logger;
        this.clock = clock;
        this.options = options.Value;
        this.multiTenancyOptions = multiTenancyOptions.Value;

        CronExpression = this.options.CleanupScheduleCron;
    }

    protected override async Task DoWorkAsync(PeriodicBackgroundWorkerContext workerContext)
    {
        if (multiTenancyOptions.IsEnabled)
        {
            await CleanupSessionsForAllTenantsAsync(workerContext);
        }
        else
        {
            await CleanupSessionsAsync(workerContext.ServiceProvider);
        }
    }

    /// <summary>
    /// 为所有租户清理会话（租户循环逻辑）
    /// </summary>
    private async Task CleanupSessionsForAllTenantsAsync(PeriodicBackgroundWorkerContext workerContext)
    {
        ITenantStore tenantStore = workerContext.ServiceProvider.GetRequiredService<ITenantStore>();
        var currentTenant = workerContext.ServiceProvider.GetRequiredService<ICurrentTenant>();

        // 获取所有租户列表
        var tenants = await tenantStore.GetListAsync();

        // 先清理主机租户（TenantId 为 null）
        await CleanupSessionsAsync(workerContext.ServiceProvider);

        // 遍历每个租户进行清理
        foreach (var tenant in tenants)
        {
            using (currentTenant.Change(tenant.Id, tenant.Name))
            {
                try
                {
                    await CleanupSessionsAsync(workerContext.ServiceProvider, tenant.Name);
                }
                catch (Exception ex)
                {
                    logger.LogError(ex, "清理租户 {TenantId}({TenantName}) 的会话时发生错误", tenant.Id, tenant.Name);
                }
            }
        }
    }

    /// <summary>
    /// 为指定租户清理会话
    /// </summary>
    /// <param name="sp"></param>
    /// <param name="tenantName">租户名称，null表示主机租户</param>
    private async Task CleanupSessionsAsync(IServiceProvider sp, string? tenantName = null)
    {
        IFreeSqlRepository<UserSession> sessionRepository = sp.GetRequiredService<IFreeSqlRepository<UserSession>>();
        
        var stopwatch = Stopwatch.StartNew();

        var now = clock.Now;
        var inactiveThreshold = now.AddDays(-options.InactiveRetentionDays);

        // 1. 标记会话为过期
        var expiredCount = await MarkSessionsAsExpiredAsync(now, sessionRepository);

        // 2. 清理Inactive会话(注销后超过N天)
        var inactiveCount = await DeleteInactiveSessionsAsync(inactiveThreshold, sessionRepository);


        if (stopwatch.Elapsed.TotalSeconds > 3)
        {
            logger.LogWarning("{TenantName}用户会话清理完成，过期 {ExpiredCount} 条，清理 {InactiveCount} 条，耗时 {Elapsed} 秒", tenantName, expiredCount, inactiveCount, stopwatch.Elapsed.TotalSeconds);
        }
    }

    /// <summary>
    /// 标记会话为过期
    /// </summary>
    public async Task<int> MarkSessionsAsExpiredAsync(DateTime beforeTime, IFreeSqlRepository<UserSession> sessionRepository)
    {
        return await sessionRepository.Where(x => x.ExpireTime < beforeTime)
            .ToUpdate()
            .Set(x => x.Status, SessionStatus.Expired)
            .ExecuteAffrowsAsync();
    }

    /// <summary>
    /// 清理Inactive会话
    /// </summary>
    public async Task<int> DeleteInactiveSessionsAsync(DateTime beforeTime, IFreeSqlRepository<UserSession> sessionRepository)
    {
        return await sessionRepository.DeleteAsync(x => x.Status == SessionStatus.Inactive && x.LastActiveTime < beforeTime);
    }
}
