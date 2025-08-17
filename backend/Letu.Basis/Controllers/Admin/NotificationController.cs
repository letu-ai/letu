using Letu.Applications;
using Letu.Basis.Admin.Notifications;
using Letu.Basis.Admin.Notifications.Dtos;
using Letu.Basis.Permissions;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin
{
    [Authorize(BasisPermissions.Notification.Default)]
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
        [Authorize(BasisPermissions.Notification.Create)]
        public async Task CreateNotificationAsync([FromBody] NotificationDto dto)
        {
            await notificationService.AddNotificationAsync(dto);
        }

        [HttpGet]
        public async Task<PagedResult<NotificationResultDto>> GetNotificationsAsync([FromQuery] NotificationQueryDto dto)
        {
            return await notificationService.GetNotificationListAsync(dto);
        }

        [HttpPut("{id}")]
        [Authorize(BasisPermissions.Notification.Update)]
        public async Task UpdateNotificationAsync(Guid id, [FromBody] NotificationDto dto)
        {
            await notificationService.UpdateNotificationAsync(id, dto);
        }

        [HttpDelete]
        [Authorize(BasisPermissions.Notification.Delete)]
        public async Task DeleteNotificationsAsync([FromBody] Guid[] ids)
        {
            await notificationService.DeleteNotificationAsync(ids);
        }

        [HttpDelete("{id}")]
        [Authorize(BasisPermissions.Notification.Delete)]
        public async Task DeleteNotificationAsync(Guid id)
        {
            await notificationService.DeleteNotificationAsync(new[] { id });
        }
    }
}