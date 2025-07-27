using Letu.Basis.Personal.Notifications.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Personal
{
    [Authorize]
    [ApiController]
    [Route("api/my/notifications")]
    public class UserNotificationController : ControllerBase
    {
        private readonly IUserNotificationAppService _userNotificationService;

        public UserNotificationController(IUserNotificationAppService userNotificationService)
        {
            _userNotificationService = userNotificationService;
        }

        [HttpGet]
        public async Task<AppResponse<PagedResult<UserNotificationListDto>>> GetMyNotificationListAsync([FromQuery] UserNotificationQueryDto dto)
        {
            var data = await _userNotificationService.GetMyNotificationListAsync(dto);
            return Result.Data(data);
        }

        [HttpPut("mark-as-read")]
        public async Task<AppResponse<bool>> ReadedAsync([FromBody] Guid[] ids)
        {
            await _userNotificationService.ReadedAsync(ids);
            return Result.Ok();
        }

        [HttpGet("navbar-info")]
        public async Task<AppResponse<UserNotificationNavbarDto>> GetMyNotificationNavbarInfoAsync()
        {
            var data = await _userNotificationService.GetMyNotificationNavbarInfoAsync();
            return Result.Data(data);
        }
    }
}