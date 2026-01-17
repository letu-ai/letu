using Letu.Basis.Admin.NotificationManagement;
using Letu.Basis.Admin.Users;
using Letu.Basis.Admin.UserDevices;
using Letu.Basis.Identity;
using Letu.Basis.Notifications.Dtos;
using Letu.Repository;
using Volo.Abp.DependencyInjection;
using Volo.Abp.MultiTenancy;
using Volo.Abp.Users;

namespace Letu.Basis.Notifications;

/// <summary>
/// 通知发送服务实现
/// </summary>
public class NotificationService : INotificationService, ITransientDependency
{
    private readonly IFreeSqlRepository<Notification> notificationRepository;
    private readonly IFreeSqlRepository<UserNotification> userNotificationRepository;
    private readonly IFreeSqlRepository<User> userRepository;
    private readonly IFreeSqlRepository<UserDevice> userDeviceRepository;
    private readonly IServiceScopeFactory serviceScopeFactory;
    private readonly ICurrentTenant currentTenant;
    private readonly ICurrentUser currentUser;
    private readonly ILogger<NotificationService> logger;

    public NotificationService(
        IFreeSqlRepository<Notification> notificationRepository,
        IFreeSqlRepository<UserNotification> userNotificationRepository,
        IFreeSqlRepository<User> userRepository,
        IFreeSqlRepository<UserDevice> userDeviceRepository,
        IServiceScopeFactory serviceScopeFactory,
        ICurrentTenant currentTenant,
        ICurrentUser currentUser,
        ILogger<NotificationService> logger)
    {
        this.notificationRepository = notificationRepository;
        this.userNotificationRepository = userNotificationRepository;
        this.userRepository = userRepository;
        this.userDeviceRepository = userDeviceRepository;
        this.serviceScopeFactory = serviceScopeFactory;
        this.currentTenant = currentTenant;
        this.currentUser = currentUser;
        this.logger = logger;
    }

    public async Task<Guid> CreateNotificationAsync(SendNotificationInput input)
    {
        // 验证输入参数
        if (input.SendScopeType != SendScopeType.AllUsers && input.SendScopeValue == null)
        {
            throw new ArgumentException("必须指定 SendScopeValue");
        }

        // 1. 创建通知记录
        var notification = new Notification
        {
            Title = input.Title!,
            Content = input.Content,
            NotificationType = input.NotificationType,
            SubType = input.SubType,
            SendScopeType = input.SendScopeType,
            SendScopeValue = input.SendScopeValue,
            Priority = input.Priority,
            ExpireTime = input.ExpireTime,
            TargetPlatform = input.TargetPlatform,
            SenderId = input.SenderId ?? currentUser.Id,
            Sender = input.Sender ?? currentUser.Name ?? currentUser.UserName ?? "System",
            Status = NotificationStatus.Published,
            PublishTime = DateTime.Now,
            TenantId = input.TenantId ?? currentTenant.Id
        };

        await notificationRepository.InsertAsync(notification);

        logger.LogInformation(
            "通知创建成功: NotificationId={NotificationId}, Title={Title}, SendScopeType={SendScopeType}",
            notification.Id, notification.Title, notification.SendScopeType);

        // 2. 计算目标用户并创建用户通知记录
        var targetUserIds = await GetTargetUserIdsAsync(input.SendScopeType, input.SendScopeValue);

        if (targetUserIds.Count > 0)
        {
            await CreateUserNotificationsAsync(notification, targetUserIds);

            logger.LogInformation(
                "用户通知记录创建完成: NotificationId={NotificationId}, UserCount={UserCount}",
                notification.Id, targetUserIds.Count);

            // 3. 触发即时推送（异步，不阻塞调用方）
            TriggerPushAsync(notification, targetUserIds, input.SendScopeType);
        }
        else
        {
            logger.LogWarning(
                "没有找到目标用户: NotificationId={NotificationId}, SendScopeType={SendScopeType}",
                notification.Id, input.SendScopeType);
        }

        return notification.Id;
    }

    /// <summary>
    /// 创建用户通知记录
    /// </summary>
    private async Task CreateUserNotificationsAsync(Notification notification, List<Guid> targetUserIds)
    {
        // 计算推送有效期
        var pushExpireTime = DateTime.Now.Add(
            PushRetryConfig.GetDefaultExpireTime(notification.NotificationType, notification.SubType));

        var userNotifications = targetUserIds.Select(userId => new UserNotification
        {
            NotificationId = notification.Id,
            UserId = userId,
            IsRead = false,
            PushStatus = PushStatus.Pending,
            PushExpireTime = pushExpireTime,
            TenantId = notification.TenantId
        }).ToList();

        await userNotificationRepository.InsertAsync(userNotifications);
    }

    /// <summary>
    /// 触发异步推送（fire-and-forget）
    /// </summary>
    private void TriggerPushAsync(Notification notification, List<Guid> targetUserIds, SendScopeType sendScopeType)
    {
        // 使用 Task.Run 启动后台任务，主线程立即返回
        _ = Task.Run(async () =>
        {
            // 创建新的作用域，避免使用已释放的请求作用域
            using var scope = serviceScopeFactory.CreateScope();
            var notificationPushService = scope.ServiceProvider.GetRequiredService<INotificationPushService>();
            
            try
            {
                logger.LogInformation(
                    "开始推送通知: NotificationId={NotificationId}, UserCount={UserCount}",
                    notification.Id, targetUserIds.Count);

                if (sendScopeType == SendScopeType.AllUsers)
                {
                    await notificationPushService.PushToAllAsync(notification);
                }
                else
                {
                    await notificationPushService.PushToUsersAsync(notification, targetUserIds);
                }

                logger.LogInformation(
                    "通知推送完成: NotificationId={NotificationId}",
                    notification.Id);
            }
            catch (Exception ex)
            {
                logger.LogError(ex,
                    "推送通知失败，将由后台任务重试: NotificationId={NotificationId}",
                    notification.Id);
                // 推送失败不影响主流程，Worker 会自动重试
            }
        });
    }

    /// <summary>
    /// 根据发送范围获取目标用户ID列表
    /// </summary>
    private async Task<List<Guid>> GetTargetUserIdsAsync(SendScopeType sendScopeType, string? sendScopeValue)
    {
        // 处理设备相关的范围类型
        if (sendScopeType == SendScopeType.SpecificDevices)
        {
            if (!string.IsNullOrEmpty(sendScopeValue))
            {
                var deviceIds = sendScopeValue.Split(',', StringSplitOptions.RemoveEmptyEntries).ToList();
                return await userDeviceRepository.Select
                    .Where(d => deviceIds.Contains(d.DeviceId))
                    .Distinct()
                    .ToListAsync(d => d.UserId);
            }
            return [];
        }

        if (sendScopeType == SendScopeType.ByClientType)
        {
            if (!string.IsNullOrEmpty(sendScopeValue))
            {
                var clientTypes = sendScopeValue.Split(',', StringSplitOptions.RemoveEmptyEntries)
                    .Select(x => Enum.Parse<ClientType>(x)).ToList();
                return await userDeviceRepository.Select
                    .Where(d => clientTypes.Contains(d.ClientType))
                    .Distinct()
                    .ToListAsync(d => d.UserId);
            }
            return [];
        }

        // 处理用户相关的范围类型
        var query = userRepository.Select.Where(u => u.IsEnabled);

        switch (sendScopeType)
        {
            case SendScopeType.SpecificUsers:
                if (!string.IsNullOrEmpty(sendScopeValue))
                {
                    var userIds = sendScopeValue.Split(',', StringSplitOptions.RemoveEmptyEntries)
                        .Select(Guid.Parse).ToList();
                    query = query.Where(u => userIds.Contains(u.Id));
                }
                break;
            case SendScopeType.ByRole:
                // TODO: 实现按角色查询
                break;
            case SendScopeType.ByDepartment:
                if (!string.IsNullOrEmpty(sendScopeValue))
                {
                    var deptIds = sendScopeValue.Split(',', StringSplitOptions.RemoveEmptyEntries)
                        .Select(Guid.Parse).ToList();
                    query = query.Where(u => u.DepartmentId.HasValue && deptIds.Contains(u.DepartmentId.Value));
                }
                break;
            case SendScopeType.ByPosition:
                if (!string.IsNullOrEmpty(sendScopeValue))
                {
                    var positionIds = sendScopeValue.Split(',', StringSplitOptions.RemoveEmptyEntries)
                        .Select(Guid.Parse).ToList();
                    query = query.Where(u => u.PositionId.HasValue && positionIds.Contains(u.PositionId.Value));
                }
                break;
            case SendScopeType.AllUsers:
                // 查询所有启用的用户
                break;
        }

        return await query.ToListAsync(u => u.Id);
    }
}
