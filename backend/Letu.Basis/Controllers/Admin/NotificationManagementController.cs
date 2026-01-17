using Letu.Basis.Admin.NotificationManagement;
using Letu.Basis.Admin.NotificationManagement.Dtos;
using Letu.Basis.Permissions;
using Letu.Core.Applications;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin;

/// <summary>
/// 通知管理API
/// </summary>
[Authorize(BasisPermissions.Notification.Default)]
[ApiController]
[Route("api/admin/notification-management")]
public class NotificationManagementController : ControllerBase
{
    private readonly INotificationAppService notificationService;

    public NotificationManagementController(INotificationAppService notificationService)
    {
        this.notificationService = notificationService;
    }

    /// <summary>
    /// 创建通知
    /// </summary>
    [HttpPost]
    [Authorize(BasisPermissions.Notification.Create)]
    public async Task<Guid> CreateNotificationAsync([FromBody] NotificationCreateInput dto)
    {
        return await notificationService.CreateNotificationAsync(dto);
    }

    /// <summary>
    /// 获取通知列表
    /// </summary>
    [HttpGet]
    public async Task<PagedResult<NotificationListOutput>> GetNotificationsAsync([FromQuery] NotificationListInput dto)
    {
        return await notificationService.GetNotificationListAsync(dto);
    }

    /// <summary>
    /// 获取通知详情
    /// </summary>
    [HttpGet("{id}")]
    public async Task<NotificationListOutput> GetNotificationAsync(Guid id)
    {
        return await notificationService.GetNotificationAsync(id);
    }

    /// <summary>
    /// 更新通知
    /// </summary>
    [HttpPut("{id}")]
    [Authorize(BasisPermissions.Notification.Update)]
    public async Task UpdateNotificationAsync(Guid id, [FromBody] NotificationCreateInput dto)
    {
        await notificationService.UpdateNotificationAsync(id, dto);
    }

    /// <summary>
    /// 发布通知
    /// </summary>
    [HttpPost("{id}/publish")]
    [Authorize(BasisPermissions.Notification.Update)]
    public async Task PublishNotificationAsync(Guid id)
    {
        await notificationService.PublishNotificationAsync(id);
    }

    /// <summary>
    /// 撤回通知
    /// </summary>
    [HttpPost("{id}/withdraw")]
    [Authorize(BasisPermissions.Notification.Update)]
    public async Task WithdrawNotificationAsync(Guid id)
    {
        await notificationService.WithdrawNotificationAsync(id);
    }

    /// <summary>
    /// 批量删除通知
    /// </summary>
    [HttpDelete]
    [Authorize(BasisPermissions.Notification.Delete)]
    public async Task DeleteNotificationsAsync([FromBody] Guid[] ids)
    {
        await notificationService.DeleteNotificationAsync(ids);
    }

    /// <summary>
    /// 删除单个通知
    /// </summary>
    [HttpDelete("{id}")]
    [Authorize(BasisPermissions.Notification.Delete)]
    public async Task DeleteNotificationAsync(Guid id)
    {
        await notificationService.DeleteNotificationAsync(new[] { id });
    }

    /// <summary>
    /// 获取通知接收人列表
    /// </summary>
    [HttpGet("{id}/recipients")]
    public async Task<PagedResult<NotificationRecipientOutput>> GetNotificationRecipientsAsync(Guid id, [FromQuery] PagedResultRequest request)
    {
        return await notificationService.GetNotificationRecipientsAsync(id, request);
    }

    /// <summary>
    /// 清理过期通知
    /// </summary>
    [HttpPost("clean-expired")]
    [Authorize(BasisPermissions.Notification.Delete)]
    public async Task CleanExpiredNotificationsAsync()
    {
        await notificationService.CleanExpiredNotificationsAsync();
    }
}