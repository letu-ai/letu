using Letu.Basis.Admin.NotificationManagement;
using Letu.Basis.Admin.UserDevices;
using Letu.Basis.ClientConnection;
using Letu.Basis.Identity;
using Letu.MobilePush;
using Letu.Repository;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Timing;

namespace Letu.Basis.Notifications;

/// <summary>
/// 通知推送服务实现
/// </summary>
public class NotificationPushService : INotificationPushService, ITransientDependency
{
    private readonly IClientConnectionHub clientConnectionHub;
    private readonly IMobilePushService mobilePushService;
    private readonly IFreeSqlRepository<UserDevice> userDeviceRepository;
    private readonly IFreeSqlRepository<UserNotification> userNotificationRepository;
    private readonly IConfiguration configuration;
    private readonly IClock clock;
    private readonly ILogger<NotificationPushService> logger;
    private readonly PushRetryConfig retryConfig;

    public NotificationPushService(
        IClientConnectionHub clientConnectionHub,
        IMobilePushService mobilePushService,
        IFreeSqlRepository<UserDevice> userDeviceRepository,
        IFreeSqlRepository<UserNotification> userNotificationRepository,
        IConfiguration configuration,
        IClock clock,
        ILogger<NotificationPushService> logger)
    {
        this.clientConnectionHub = clientConnectionHub;
        this.mobilePushService = mobilePushService;
        this.userDeviceRepository = userDeviceRepository;
        this.userNotificationRepository = userNotificationRepository;
        this.configuration = configuration;
        this.clock = clock;
        this.logger = logger;
        this.retryConfig = new PushRetryConfig();
    }

    public async Task PushToUsersAsync(Notification notification, List<Guid> userIds)
    {
        if (!userIds.Any()) return;

        var pushPayload = BuildPushPayload(notification);

        // 1. Web端推送（SSE）- 只推送一次，不参与重试
        if (notification.TargetPlatform.HasFlag(TargetPlatform.Web))
        {
            try
            {
                await clientConnectionHub.SendMessageToUsersAsync(userIds, "notification", pushPayload);
                logger.LogInformation("Web端推送成功: UserCount={UserCount}", userIds.Count);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Web端推送失败: UserCount={UserCount}", userIds.Count);
            }
        }

        // 2. 移动端推送 - 状态根据移动端结果判定
        if (notification.TargetPlatform.HasFlag(TargetPlatform.Mobile))
        {
            await PushToMobileByUsersAsync(notification, userIds);
        }
        else
        {
            // 仅 Web 端推送，直接标记为成功（Web 端不参与重试）
            await UpdatePushStatusAsync(notification.Id, userIds, PushStatus.Success, clock.Now, null);
        }
    }

    public async Task PushToAllAsync(Notification notification)
    {
        var pushPayload = BuildPushPayload(notification);

        // 1. Web端广播 - 只推送一次，不参与重试
        if (notification.TargetPlatform.HasFlag(TargetPlatform.Web))
        {
            try
            {
                await clientConnectionHub.SendMessageToAllAsync("notification", pushPayload);
                logger.LogInformation("Web端广播推送成功: NotificationId={NotificationId}", notification.Id);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Web端广播推送失败: NotificationId={NotificationId}", notification.Id);
            }
        }

        // 2. 移动端推送（全员）
        if (notification.TargetPlatform.HasFlag(TargetPlatform.Mobile))
        {
            var packageName = configuration["MobilePush:DefaultPackageName"];
            if (!string.IsNullOrEmpty(packageName))
            {
                try
                {
                    // 获取所有有效设备和对应的用户
                    var devicesWithUsers = await userDeviceRepository.Select
                        .Where(d => d.ClientType == ClientType.Android
                                 || d.ClientType == ClientType.IOS
                                 || d.ClientType == ClientType.HarmonyOS)
                        .Where(d => !string.IsNullOrEmpty(d.PushDeviceId))
                        .Where(d => d.PackageName == packageName)
                        .ToListAsync(d => new { d.PushDeviceId, d.UserId });

                    if (devicesWithUsers.Any())
                    {
                        var deviceIds = devicesWithUsers.Select(d => d.PushDeviceId).Where(d => !string.IsNullOrEmpty(d)).ToList();
                        var userIds = devicesWithUsers.Select(d => d.UserId).Distinct().ToList();

                        var result = await mobilePushService.PushToDeviceAsync(
                            PushType.Notification,
                            packageName,
                            deviceIds!,
                            notification.Title ?? "",
                            notification.Content ?? "");

                        logger.LogInformation(
                            "移动端全员推送完成: NotificationId={NotificationId}, DeviceCount={DeviceCount}, Success={Success}",
                            notification.Id, deviceIds.Count, result.Success);

                        if (result.Success)
                        {
                            await UpdatePushStatusAsync(notification.Id, userIds, PushStatus.Success, clock.Now, null);
                        }
                        else
                        {
                            var errorMessage = $"推送失败: {result.ErrorCode} - {result.ErrorMessage}";
                            var nextRetryTime = retryConfig.GetNextRetryTime(0);
                            await UpdatePushStatusAsync(notification.Id, userIds, PushStatus.Failed, null, errorMessage, nextRetryTime);
                        }
                    }
                }
                catch (Exception ex)
                {
                    logger.LogError(ex, "移动端全员推送失败: NotificationId={NotificationId}", notification.Id);

                    var userIds = await userDeviceRepository.Select
                        .Where(d => d.ClientType == ClientType.Android
                                 || d.ClientType == ClientType.IOS
                                 || d.ClientType == ClientType.HarmonyOS)
                        .Where(d => !string.IsNullOrEmpty(d.PushDeviceId))
                        .Where(d => d.PackageName == packageName)
                        .Distinct()
                        .ToListAsync(d => d.UserId);

                    if (userIds.Any())
                    {
                        var nextRetryTime = retryConfig.GetNextRetryTime(0);
                        await UpdatePushStatusAsync(notification.Id, userIds, PushStatus.Failed, null, $"推送异常: {ex.Message}", nextRetryTime);
                    }
                }
            }
        }
        else
        {
            // 仅 Web 端推送，获取所有用户并标记为成功
            var userIds = await userNotificationRepository.Select
                .Where(un => un.NotificationId == notification.Id)
                .ToListAsync(un => un.UserId);

            if (userIds.Any())
            {
                await UpdatePushStatusAsync(notification.Id, userIds, PushStatus.Success, clock.Now, null);
            }
        }
    }

    public async Task PushToDevicesAsync(Notification notification, List<string> deviceIds)
    {
        if (!deviceIds.Any()) return;

        var packageName = configuration["MobilePush:DefaultPackageName"];
        if (string.IsNullOrEmpty(packageName))
        {
            logger.LogWarning("未配置 MobilePush:DefaultPackageName，跳过设备推送");
            return;
        }

        try
        {
            var result = await mobilePushService.PushToDeviceAsync(
                PushType.Notification,
                packageName,
                deviceIds,
                notification.Title ?? "",
                notification.Content ?? "");

            logger.LogInformation(
                "设备推送完成: NotificationId={NotificationId}, DeviceCount={DeviceCount}, Success={Success}",
                notification.Id, deviceIds.Count, result.Success);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "设备推送失败: NotificationId={NotificationId}", notification.Id);
        }
    }

    public async Task RetryPushAsync(Guid userNotificationId)
    {
        var userNotification = await userNotificationRepository.Select
            .Where(un => un.Id == userNotificationId)
            .IncludeByPropertyName(nameof(UserNotification.Notification))
            .FirstAsync();

        if (userNotification == null)
        {
            logger.LogWarning("重试推送失败，未找到用户通知: {UserNotificationId}", userNotificationId);
            return;
        }

        // 检查是否已读，已读的消息不推送
        if (userNotification.IsRead)
        {
            logger.LogInformation("消息已读，跳过重试推送: {UserNotificationId}", userNotificationId);
            return;
        }

        // 检查是否过期
        if (userNotification.PushExpireTime.HasValue && clock.Now > userNotification.PushExpireTime.Value)
        {
            userNotification.PushStatus = PushStatus.Expired;
            userNotification.PushErrorMessage = "推送已过期";
            userNotification.NextRetryTime = null;
            await userNotificationRepository.UpdateAsync(userNotification);
            logger.LogInformation("推送已过期，标记为Expired: {UserNotificationId}", userNotificationId);
            return;
        }

        // 检查是否超过最大重试次数
        if (userNotification.RetryCount >= retryConfig.MaxRetryCount)
        {
            userNotification.PushStatus = PushStatus.Expired;
            userNotification.PushErrorMessage = $"超过最大重试次数({retryConfig.MaxRetryCount})";
            userNotification.NextRetryTime = null;
            await userNotificationRepository.UpdateAsync(userNotification);
            logger.LogInformation("超过最大重试次数，标记为Expired: {UserNotificationId}", userNotificationId);
            return;
        }

        var notification = userNotification.Notification;
        if (notification == null)
        {
            logger.LogWarning("重试推送失败，通知不存在: {NotificationId}", userNotification.NotificationId);
            return;
        }

        // 只重试移动端推送（Web 端不参与重试）
        if (!notification.TargetPlatform.HasFlag(TargetPlatform.Mobile))
        {
            // 如果通知不包含移动端，直接标记为成功
            userNotification.PushStatus = PushStatus.Success;
            userNotification.PushTime = clock.Now;
            userNotification.NextRetryTime = null;
            await userNotificationRepository.UpdateAsync(userNotification);
            return;
        }

        // 执行移动端推送
        var pushSuccess = await TryPushToMobileAsync(notification, userNotification.UserId);

        // 更新推送状态
        userNotification.RetryCount++;
        if (pushSuccess)
        {
            userNotification.PushStatus = PushStatus.Success;
            userNotification.PushTime = clock.Now;
            userNotification.PushErrorMessage = null;
            userNotification.NextRetryTime = null;
        }
        else
        {
            userNotification.PushStatus = PushStatus.Failed;
            userNotification.PushErrorMessage = "移动端推送失败";
            userNotification.NextRetryTime = retryConfig.GetNextRetryTime(userNotification.RetryCount);
        }

        await userNotificationRepository.UpdateAsync(userNotification);
    }

    /// <summary>
    /// 推送到用户的移动设备
    /// </summary>
    private async Task PushToMobileByUsersAsync(Notification notification, List<Guid> userIds)
    {
        var devices = await userDeviceRepository.Select
            .Where(d => userIds.Contains(d.UserId))
            .Where(d => d.ClientType == ClientType.Android
                     || d.ClientType == ClientType.IOS
                     || d.ClientType == ClientType.HarmonyOS)
            .Where(d => !string.IsNullOrEmpty(d.PushDeviceId))
            .ToListAsync();

        if (!devices.Any())
        {
            logger.LogDebug("没有找到用户的移动设备: NotificationId={NotificationId}, UserCount={UserCount}",
                notification.Id, userIds.Count);
            // 没有移动设备，标记为 Skipped
            await UpdatePushStatusAsync(notification.Id, userIds, PushStatus.Skipped, null, "用户没有移动设备");
            return;
        }

        // 按包名分组推送
        var deviceGroups = devices.GroupBy(d => d.PackageName);
        var successUserIds = new HashSet<Guid>();
        var failedUserIds = new HashSet<Guid>();

        foreach (var group in deviceGroups)
        {
            var deviceIds = group.Select(d => d.PushDeviceId!).ToList();
            var groupUserIds = group.Select(d => d.UserId).Distinct().ToList();

            try
            {
                var result = await mobilePushService.PushToDeviceAsync(
                    PushType.Notification,
                    group.Key!,
                    deviceIds,
                    notification.Title ?? "",
                    notification.Content ?? "");

                logger.LogInformation(
                    "移动端推送完成: NotificationId={NotificationId}, PackageName={PackageName}, DeviceCount={DeviceCount}, Success={Success}",
                    notification.Id, group.Key, deviceIds.Count, result.Success);

                if (result.Success)
                {
                    foreach (var userId in groupUserIds)
                    {
                        successUserIds.Add(userId);
                    }
                }
                else
                {
                    foreach (var userId in groupUserIds)
                    {
                        if (!successUserIds.Contains(userId))
                        {
                            failedUserIds.Add(userId);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                logger.LogError(ex,
                    "移动端推送失败: NotificationId={NotificationId}, PackageName={PackageName}",
                    notification.Id, group.Key);

                foreach (var userId in groupUserIds)
                {
                    if (!successUserIds.Contains(userId))
                    {
                        failedUserIds.Add(userId);
                    }
                }
            }
        }

        // 更新成功用户的状态
        if (successUserIds.Any())
        {
            await UpdatePushStatusAsync(notification.Id, successUserIds.ToList(), PushStatus.Success, clock.Now, null);
        }

        // 更新失败用户的状态
        if (failedUserIds.Any())
        {
            var nextRetryTime = retryConfig.GetNextRetryTime(0);
            await UpdatePushStatusAsync(notification.Id, failedUserIds.ToList(), PushStatus.Failed, null, "移动端推送失败", nextRetryTime);
        }

        // 处理没有设备的用户
        var usersWithDevices = devices.Select(d => d.UserId).Distinct().ToHashSet();
        var usersWithoutDevices = userIds.Where(u => !usersWithDevices.Contains(u)).ToList();
        if (usersWithoutDevices.Any())
        {
            await UpdatePushStatusAsync(notification.Id, usersWithoutDevices, PushStatus.Skipped, null, "用户没有移动设备");
        }
    }

    /// <summary>
    /// 尝试推送到用户的移动设备（用于重试）
    /// </summary>
    private async Task<bool> TryPushToMobileAsync(Notification notification, Guid userId)
    {
        var devices = await userDeviceRepository.Select
            .Where(d => d.UserId == userId)
            .Where(d => d.ClientType == ClientType.Android
                     || d.ClientType == ClientType.IOS
                     || d.ClientType == ClientType.HarmonyOS)
            .Where(d => !string.IsNullOrEmpty(d.PushDeviceId))
            .ToListAsync();

        if (!devices.Any())
        {
            logger.LogDebug("用户没有移动设备: UserId={UserId}, NotificationId={NotificationId}", userId, notification.Id);
            return false;
        }

        var deviceGroups = devices.GroupBy(d => d.PackageName);
        bool anySuccess = false;

        foreach (var group in deviceGroups)
        {
            var deviceIds = group.Select(d => d.PushDeviceId!).Where(id => !string.IsNullOrEmpty(id)).ToList();
            if (!deviceIds.Any()) continue;

            try
            {
                var result = await mobilePushService.PushToDeviceAsync(
                    PushType.Notification,
                    group.Key!,
                    deviceIds,
                    notification.Title,
                    notification.Content ?? "");

                if (result.Success)
                {
                    anySuccess = true;
                    logger.LogInformation(
                        "移动端重试推送成功: UserId={UserId}, PackageName={PackageName}, DeviceCount={DeviceCount}, NotificationId={NotificationId}",
                        userId, group.Key, deviceIds.Count, notification.Id);
                }
                else
                {
                    logger.LogWarning(
                        "移动端重试推送失败: UserId={UserId}, PackageName={PackageName}, Error={Error}",
                        userId, group.Key, result.ErrorMessage);
                }
            }
            catch (Exception ex)
            {
                logger.LogError(ex,
                    "移动端重试推送异常: UserId={UserId}, PackageName={PackageName}, NotificationId={NotificationId}",
                    userId, group.Key, notification.Id);
            }
        }

        return anySuccess;
    }

    /// <summary>
    /// 统一的状态更新方法
    /// </summary>
    private async Task UpdatePushStatusAsync(
        Guid notificationId,
        List<Guid> userIds,
        PushStatus status,
        DateTime? pushTime,
        string? errorMessage,
        DateTime? nextRetryTime = null)
    {
        if (!userIds.Any()) return;

        var userNotifications = await userNotificationRepository.Select
            .Where(un => un.NotificationId == notificationId && userIds.Contains(un.UserId))
            .ToListAsync();

        if (!userNotifications.Any())
        {
            logger.LogWarning(
                "未找到用户通知记录: NotificationId={NotificationId}, UserCount={UserCount}",
                notificationId, userIds.Count);
            return;
        }

        foreach (var userNotification in userNotifications)
        {
            userNotification.PushStatus = status;
            userNotification.PushTime = pushTime;
            userNotification.PushErrorMessage = errorMessage;
            userNotification.NextRetryTime = nextRetryTime;
        }

        await userNotificationRepository.UpdateAsync(userNotifications);

        logger.LogDebug(
            "推送状态更新完成: NotificationId={NotificationId}, Status={Status}, UpdatedCount={UpdatedCount}",
            notificationId, status, userNotifications.Count);
    }

    private static object BuildPushPayload(Notification notification)
    {
        return new
        {
            notificationId = notification.Id,
            notificationType = notification.NotificationType,
            subType = notification.SubType,
            title = notification.Title,
            priority = notification.Priority,
            showInList = notification.NotificationType != NotificationType.SystemNotification
        };
    }
}
