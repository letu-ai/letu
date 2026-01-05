using Letu.Basis.Admin.OnlineUsers;
using Letu.Basis.Admin.OnlineUsers.Dtos;
using Letu.Basis.Identity;
using Letu.Basis.Permissions;
using Letu.Core.Applications;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin;

// TODO:完善权限点
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
    public async Task<PagedResult<OnlineUserListOutput>> GetOnlineUsersAsync([FromQuery] OnlineUserListInput dto)
    {
        return await onlineUserService.GetOnlineUserListAsync(dto);
    }


    /// <summary>
    /// 注销用户会话
    /// </summary>
    /// <returns></returns>
    [HttpPost("revoke")]
    [Authorize(BasisPermissions.User.Revoke)]
    public async Task LogoutAsync(SessionRevokeInput input)
    {
        await identityAppService.LogoutAsync(input.UserId, input.SessionId);
    }
}