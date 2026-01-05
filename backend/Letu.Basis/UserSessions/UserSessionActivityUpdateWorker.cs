using System.Diagnostics;
using Letu.Repository;
using Microsoft.Extensions.Options;
using Volo.Abp.BackgroundWorkers;
using Volo.Abp.Threading;
using Volo.Abp.Timing;

namespace Letu.Basis.UserSessions;

/// <summary>
/// 用户会话活动时间批量更新后台任务
/// </summary>
public class UserSessionActivityUpdateWorker : AsyncPeriodicBackgroundWorkerBase
{
    private readonly ILogger<UserSessionActivityUpdateWorker> logger;
    private readonly IFreeSqlRepository<UserSession> sessionRepository;
    private readonly UserSessionActivityService activityService;
    private readonly UserSessionActivityOptions options;

    public UserSessionActivityUpdateWorker(
        AbpAsyncTimer timer,
        IServiceScopeFactory serviceScopeFactory,
        ILogger<UserSessionActivityUpdateWorker> logger,
        IFreeSqlRepository<UserSession> sessionRepository,
        UserSessionActivityService activityService,
        IOptions<UserSessionActivityOptions> options)
        : base(timer, serviceScopeFactory)
    {
        this.logger = logger;
        this.sessionRepository = sessionRepository;
        this.activityService = activityService;
        this.options = options.Value;

        CronExpression = this.options.BatchUpdateCronExpression;
    }

    protected override async Task DoWorkAsync(PeriodicBackgroundWorkerContext workerContext)
    {
        var stopwatch = Stopwatch.StartNew();

        try
        {
            // 获取待更新的会话列表
            var pendingUpdates = await activityService.GetPendingUpdatesAsync();

            if (pendingUpdates.Count == 0)
            {
                logger.LogDebug("没有待更新的会话活动时间");
                return;
            }

            // 批量更新数据库
            var updatedCount = await BatchUpdateLastActiveTimeAsync(pendingUpdates);

            // 清除已处理的缓存项
            activityService.ClearProcessed(pendingUpdates.Keys);

            // 太慢才记录日志，避免频繁记录日志
            if(stopwatch.Elapsed.TotalSeconds > 3)
            {
                logger.LogInformation(
                    "批量更新会话活动时间完成，更新 {UpdatedCount} 条，耗时 {Elapsed} 秒",
                    updatedCount,
                    stopwatch.Elapsed.TotalSeconds);
            }
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "批量更新会话活动时间时发生错误，耗时 {Elapsed} 秒", stopwatch.Elapsed.TotalSeconds);
        }
    }

    /// <summary>
    /// 批量更新LastActiveTime
    /// </summary>
    private async Task<int> BatchUpdateLastActiveTimeAsync(Dictionary<Guid, DateTime> sessionActivities)
    {
        if (sessionActivities == null || sessionActivities.Count == 0)
        {
            return 0;
        }

        var sessionIds = sessionActivities.Keys.ToList();
        var sessions = await sessionRepository.Select
            .Where(x => sessionIds.Contains(x.Id) && x.Status == SessionStatus.Active)
            .ToListAsync();

        var updatedCount = 0;
        foreach (var session in sessions)
        {
            if (sessionActivities.TryGetValue(session.Id, out var activityTime))
            {
                session.LastActiveTime = activityTime;
                updatedCount++;
            }
        }

        if (updatedCount > 0)
        {
            await sessionRepository.UpdateAsync(sessions);
        }

        return updatedCount;
    }
}

