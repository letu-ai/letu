using Volo.Abp.BackgroundWorkers;
using Volo.Abp.Threading;
using Letu.Logging;
using Microsoft.Extensions.Options;
using System.Diagnostics;

namespace Letu.Basis.Admin.Loggings;

/// <summary>
/// 日志文件清理后台任务
/// </summary>
public class LogCleanupWorker : AsyncPeriodicBackgroundWorkerBase
{
    private readonly ILogger<LogCleanupWorker> logger;
    private readonly IOptions<LogManagementOptions> logManagementOptions;
    private readonly ILogFileManagementService logFileManagementService;
    private readonly IDatabaseLogCleanupService databaseLogCleanupService;

    public LogCleanupWorker(
        AbpAsyncTimer timer,
        IServiceScopeFactory serviceScopeFactory,
        ILogFileManagementService logFileManagementService,
        IDatabaseLogCleanupService databaseLogCleanupService,
        ILogger<LogCleanupWorker> logger,
        IOptions<LogManagementOptions> logManagementOptions)
        : base(timer, serviceScopeFactory)
    {
        this.logger = logger;
        this.logManagementOptions = logManagementOptions;
        this.logFileManagementService = logFileManagementService;
        this.databaseLogCleanupService = databaseLogCleanupService;

        // 从配置读取 Cron 表达式，默认为每天凌晨2点执行
        var cronExpression = this.logManagementOptions.Value.CleanupScheduleCron;
        CronExpression = cronExpression; //Only for Quartz or Hangfire integration.

        // 临时修改：设置很短的执行间隔，让程序启动后立即执行一次清理
        // Timer.Period = 1000; // 1秒后执行
    }

    bool shouldRun = true;

    protected override async Task DoWorkAsync(PeriodicBackgroundWorkerContext workerContext)
    {
        if (!shouldRun)
        {
            return;
        }
        shouldRun = false;

        var stopwatch = Stopwatch.StartNew();
        // 1. 压缩旧文件
        try
        {
            var compressedCount = await logFileManagementService.CompressOldFilesAsync();
            logger.LogInformation("压缩旧日志文件完成，共压缩 {Count} 个文件，耗时 {Elapsed} 秒", compressedCount, stopwatch.Elapsed.TotalSeconds);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "压缩旧日志文件时发生错误，耗时 {Elapsed} 秒", stopwatch.Elapsed.TotalSeconds);
        }

        // 2. 删除过期文件
        try
        {
            stopwatch.Restart();
            var deletedCount = await logFileManagementService.CleanupExpiredFilesAsync();
            logger.LogInformation("删除过期日志文件完成，共删除 {Count} 个文件，耗时 {Elapsed} 秒", deletedCount, stopwatch.Elapsed.TotalSeconds);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "删除过期日志文件时发生错误，耗时 {Elapsed} 秒", stopwatch.Elapsed.TotalSeconds);
        }

        // 3. 清理业务日志
        try
        {
            stopwatch.Restart();
            var businessLogDeletedCount = await databaseLogCleanupService.CleanupBusinessLogsAsync();
            logger.LogInformation("清理业务日志完成，共删除 {Count} 条记录，耗时 {Elapsed} 秒", businessLogDeletedCount, stopwatch.Elapsed.TotalSeconds);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "清理业务日志时发生错误，耗时 {Elapsed} 秒", stopwatch.Elapsed.TotalSeconds);
        }

        // 4. 清理审计日志
        try
        {
            stopwatch.Restart();
            var auditLogDeletedCount = await databaseLogCleanupService.CleanupAuditLogsAsync();
            logger.LogInformation("清理审计日志完成，共删除 {Count} 条记录，耗时 {Elapsed} 秒", auditLogDeletedCount, stopwatch.Elapsed.TotalSeconds);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "清理审计日志时发生错误，耗时 {Elapsed} 秒", stopwatch.Elapsed.TotalSeconds);
        }
    }
}

