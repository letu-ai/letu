using Letu.Applications;
using Letu.Basis.Personal.Notifications.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Personal.Notifications
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
        public async Task<PagedResult<UserNotificationListDto>> GetMyNotificationListAsync([FromQuery] UserNotificationQueryDto dto)
        {
            return await _userNotificationService.GetMyNotificationListAsync(dto);
        }

        [HttpPut("mark-as-read")]
        public async Task ReadedAsync([FromBody] Guid[] ids)
        {
            await _userNotificationService.ReadedAsync(ids);
        }

        [HttpGet("navbar-info")]
        public async Task<UserNotificationNavbarDto> GetMyNotificationNavbarInfoAsync()
        {
            return await _userNotificationService.GetMyNotificationNavbarInfoAsync();
        }
    }
}