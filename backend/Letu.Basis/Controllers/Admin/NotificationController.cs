using Letu.Applications;
using Letu.Basis.Admin.Notifications;
using Letu.Basis.Admin.Notifications.Dtos;
using Letu.Core.Attributes;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin
{
    [Authorize]
    [ApiController]
    [Route("api/admin/notifications")]
    public class NotificationController : ControllerBase
    {
        private readonly INotificationAppService notificationService;

        public NotificationController(INotificationAppService notificationService)
        {
            this.notificationService = notificationService;
        }

        [HttpPost]
        [HasPermission("Sys.Notification.Add")]
        public async Task CreateNotificationAsync([FromBody] NotificationDto dto)
        {
            await notificationService.AddNotificationAsync(dto);
        }

        [HttpGet]
        [HasPermission("Sys.Notification.List")]
        public async Task<PagedResult<NotificationResultDto>> GetNotificationsAsync([FromQuery] NotificationQueryDto dto)
        {
            return await notificationService.GetNotificationListAsync(dto);
        }

        [HttpPut("{id}")]
        [HasPermission("Sys.Notification.Update")]
        public async Task UpdateNotificationAsync(Guid id, [FromBody] NotificationDto dto)
        {
            await notificationService.UpdateNotificationAsync(id, dto);
        }

        [HttpDelete]
        [HasPermission("Sys.Notification.Delete")]
        public async Task DeleteNotificationsAsync([FromBody] Guid[] ids)
        {
            await notificationService.DeleteNotificationAsync(ids);
        }
        
        [HttpDelete("{id}")]
        [HasPermission("Sys.Notification.Delete")]
        public async Task DeleteNotificationAsync(Guid id)
        {
            await notificationService.DeleteNotificationAsync(new[] { id });
        }
    }
}