using Letu.Basis.Admin.Notifications;
using Letu.Basis.Admin.Notifications.Dtos;
using Letu.Core.Attributes;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Admin.Controllers
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
        public async Task<AppResponse<bool>> CreateNotificationAsync([FromBody] NotificationDto dto)
        {
            await notificationService.AddNotificationAsync(dto);
            return Result.Ok();
        }

        [HttpGet]
        [HasPermission("Sys.Notification.List")]
        public async Task<AppResponse<PagedResult<NotificationResultDto>>> GetNotificationsAsync([FromQuery] NotificationQueryDto dto)
        {
            var data = await notificationService.GetNotificationListAsync(dto);
            return Result.Data(data);
        }

        [HttpPut("{id}")]
        [HasPermission("Sys.Notification.Update")]
        public async Task<AppResponse<bool>> UpdateNotificationAsync(Guid id, [FromBody] NotificationDto dto)
        {
            if (id != dto.Id)
            {
                return Result.Fail("提供的ID与通知对象ID不匹配");
            }
            
            await notificationService.UpdateNotificationAsync(dto);
            return Result.Ok();
        }

        [HttpDelete]
        [HasPermission("Sys.Notification.Delete")]
        public async Task<AppResponse<bool>> DeleteNotificationsAsync([FromBody] Guid[] ids)
        {
            await notificationService.DeleteNotificationAsync(ids);
            return Result.Ok();
        }
        
        [HttpDelete("{id}")]
        [HasPermission("Sys.Notification.Delete")]
        public async Task<AppResponse<bool>> DeleteNotificationAsync(Guid id)
        {
            await notificationService.DeleteNotificationAsync(new[] { id });
            return Result.Ok();
        }
    }
}