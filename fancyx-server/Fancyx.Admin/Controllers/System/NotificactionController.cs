using Fancyx.Admin.IService.System;
using Fancyx.Admin.IService.System.Dtos;
using Fancyx.Core.Attributes;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Fancyx.Admin.Controllers.System
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]/[action]")]
    public class NotificactionController : ControllerBase
    {
        private readonly INotificationService notificationService;

        public NotificactionController(INotificationService notificationService)
        {
            this.notificationService = notificationService;
        }

        [HttpPost]
        [HasPermission("Sys.Notification.Add")]
        public async Task<AppResponse<bool>> AddNotificationAsync([FromBody] NotificationDto dto)
        {
            await notificationService.AddNotificationAsync(dto);
            return Result.Ok();
        }

        [HttpGet]
        [HasPermission("Sys.Notification.List")]
        public async Task<AppResponse<PagedResult<NotificationResultDto>>> GetNotificationListAsync([FromQuery] NotificationSearchDto dto)
        {
            var data = await notificationService.GetNotificationListAsync(dto);
            return Result.Data(data);
        }

        [HttpGet]
        [HasPermission("Sys.Notification.Update")]
        public async Task<AppResponse<bool>> UpdateNotificationAsync([FromBody] NotificationDto dto)
        {
            await notificationService.UpdateNotificationAsync(dto);
            return Result.Ok();
        }

        [HttpDelete]
        [HasPermission("Sys.Notification.Delete")]
        public async Task<AppResponse<bool>> DeleteNotificationAsync([FromBody] Guid[] ids)
        {
            await notificationService.DeleteNotificationAsync(ids);
            return Result.Ok();
        }
    }
}