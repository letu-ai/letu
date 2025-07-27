using Letu.Basis.Admin.OnlineUsers;
using Letu.Basis.Admin.OnlineUsers.Dtos;
using Letu.Core.Attributes;
using Letu.Logger;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Admin.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/admin/online-users")]
    public class OnlineUserController : ControllerBase
    {
        private readonly IOnlineUserAppService onlineUserService;

        public OnlineUserController(IOnlineUserAppService onlineUserService)
        {
            this.onlineUserService = onlineUserService;
        }

        /// <summary>
        /// 在线用户列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet]
        [HasPermission("Monitor.OnlineUser")]
        [ApiAccessLog(operateName: "在线用户列表", operateType: [OperateType.Query])]
        public async Task<AppResponse<PagedResult<OnlineUserResultDto>>> GetOnlineUsersAsync([FromQuery] OnlineUserSearchDto dto)
        {
            var data = await onlineUserService.GetOnlineUserListAsync(dto);
            return Result.Data(data);
        }

        /// <summary>
        /// 注销用户会话
        /// </summary>
        /// <param name="sessionKey">会话键值</param>
        /// <returns></returns>
        [HttpDelete("{sessionKey}")]
        [HasPermission("Monitor.Logout")]
        [ApiAccessLog(operateName: "注销用户会话", operateType: [OperateType.Delete])]
        public async Task<AppResponse<bool>> LogoutSessionAsync(string sessionKey)
        {
            await onlineUserService.LogoutAsync(sessionKey);
            return Result.Ok();
        }
    }
}