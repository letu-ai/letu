using Letu.Basis.Admin.NotificationManagement;
using Letu.Repository;
using Volo.Abp.BackgroundWorkers;
using Volo.Abp.Threading;
using Volo.Abp.Timing;

namespace Letu.Basis.Notifications;

/// <summary>
/// 推送重试后台任务
/// 每分钟扫描一次失败的推送，进行重试
/// </summary>
public class NotificationPushRetryWorker : AsyncPeriodicBackgroundWorkerBase
{
    private readonly SemaphoreSlim semaphore = new(1, 1);

    public NotificationPushRetryWorker(
        AbpAsyncTimer timer,
        IServiceScopeFactory serviceScopeFactory)
        : base(timer, serviceScopeFactory)
    {
        // 每分钟执行一次
        Timer.Period = 60 * 1000;
    }

    protected override async Task DoWorkAsync(PeriodicBackgroundWorkerContext workerContext)
    {
        // 防止多重进入：如果上一次执行还未完成，直接返回
        if (!await semaphore.WaitAsync(0))
        {
            return;
        }

        var logger = workerContext.ServiceProvider.GetRequiredService<ILogger<NotificationPushRetryWorker>>();

        try
        {
            await RetrykAsync(workerContext, logger);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "推送重试任务执行失败");
        }
        finally
        {
            semaphore.Release();
        }
    }


    private async Task RetrykAsync(PeriodicBackgroundWorkerContext workerContext, ILogger logger)
    {
        var userNotificationRepository = workerContext.ServiceProvider.GetRequiredService<IFreeSqlRepository<UserNotification>>();
        var notificationPushService = workerContext.ServiceProvider.GetRequiredService<INotificationPushService>();
        var clock = workerContext.ServiceProvider.GetRequiredService<IClock>();

        var now = clock.Now;

        // 查询需要重试的推送记录
        var pendingRetries = await userNotificationRepository.Select
            .Where(x => x.PushStatus == PushStatus.Failed)
            .Where(x => x.NextRetryTime != null && x.NextRetryTime <= now)
            .Where(un => !un.IsRead)  // 已读的消息不推送
            .OrderBy(x => x.NextRetryTime)
            .Take(100)  // 每次最多处理100条
            .ToListAsync(x => x.Id);

        if (!pendingRetries.Any())
        {
            // 没有待重试项，直接返回（信号量会在 finally 中释放）
            return;
        }

        logger.LogInformation("开始处理推送重试，待重试数量: {Count}", pendingRetries.Count);

        foreach (var userNotificationId in pendingRetries)
        {
            try
            {
                await notificationPushService.RetryPushAsync(userNotificationId);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "重试推送失败: UserNotificationId={UserNotificationId}", userNotificationId);
            }
        }

        logger.LogInformation("推送重试处理完成");
    }
}
