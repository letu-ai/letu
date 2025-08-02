using Letu.Applications;
using Letu.Basis.Admin.OnlineUsers;
using Letu.Basis.Admin.OnlineUsers.Dtos;
using Letu.Basis.Identity;
using Letu.Core.Attributes;
using Letu.Logging;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin
{
    [Authorize]
    [ApiController]
    [Route("api/admin/online-users")]
    public class OnlineUserController : ControllerBase
    {
        private readonly IOnlineUserAppService onlineUserService;
        private readonly IIdentityAppService identityAppService;

        public OnlineUserController(IOnlineUserAppService onlineUserService, IIdentityAppService identityAppService)
        {
            this.onlineUserService = onlineUserService;
            this.identityAppService = identityAppService;
        }

        /// <summary>
        /// 在线用户列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet]
        [HasPermission("Monitor.OnlineUser")]
        [ApiAccessLog(operateName: "在线用户列表", operateType: [OperateType.Query])]
        public async Task<PagedResult<OnlineUserResultDto>> GetOnlineUsersAsync([FromQuery] OnlineUserSearchDto dto)
        {
            return await onlineUserService.GetOnlineUserListAsync(dto);
        }

      
    /// <summary>
    /// 注销用户会话
    /// </summary>
    /// <returns></returns>
    [HttpPost("revoke")]
    [HasPermission("Monitor.Logout")]
    [ApiAccessLog(operateName: "注销用户会话", operateType: [OperateType.Delete])]
    public async Task LogoutAsync(SessionRevokeInput input)
    {
        await identityAppService.LogoutAsync(input.UserId, input.SessionId);
    }
    }
}