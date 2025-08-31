using Letu.Basis.Admin.NotificationManagement;
using Volo.Abp.DependencyInjection;
using Volo.Abp.EventBus.Distributed;
using Volo.Abp.Uow;

namespace Letu.Basis.Notifications;

public class NotificationPublishedEventHandler : 
    IDistributedEventHandler<NotificationPublishedEto>,
    ITransientDependency
{
    private readonly IUserNotificationAppService userNotificationAppService;
    private readonly ILogger<NotificationPublishedEventHandler> logger;

    public NotificationPublishedEventHandler(
        IUserNotificationAppService userNotificationAppService,
        ILogger<NotificationPublishedEventHandler> logger)
    {
        this.userNotificationAppService = userNotificationAppService;
        this.logger = logger;
    }

    [UnitOfWork]
    public async Task HandleEventAsync(NotificationPublishedEto eventData)
    {
        try
        {
            logger.LogInformation($"开始处理通知发布事件: NotificationId={eventData.NotificationId}, SendScopeType={eventData.SendScopeType}, TenantId={eventData.TenantId}");
            
            await userNotificationAppService.SendNotificationByRangeAsync(eventData);
                
            logger.LogInformation($"通知发布事件处理完成: NotificationId={eventData.NotificationId}");
        }
        catch (Exception ex)
        {
            logger.LogError(ex, $"处理通知发布事件失败: NotificationId={eventData.NotificationId}");
            // 这里不重新抛出异常，避免影响主流程
        }
    }
}