using Letu.Basis.UserSessions;
using Letu.Basis.UserSessions.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Personal;

/// <summary>
/// 用户会话管理控制器
/// </summary>
[Route("/api/my/sessions")]
[ApiController]
[Authorize]
public class UserSessionController : ControllerBase
{
    private readonly IUserSessionAppService userSessionAppService;

    public UserSessionController(IUserSessionAppService userSessionAppService)
    {
        this.userSessionAppService = userSessionAppService;
    }

    /// <summary>
    /// 获取我的活动会话列表
    /// </summary>
    /// <returns></returns>
    [HttpGet]
    public async Task<List<UserSessionListOutput>> GetSessionsAsync()
    {
        return await userSessionAppService.GetSessionsAsync();
    }

    /// <summary>
    /// 注销指定会话
    /// </summary>
    /// <param name="sessionId">会话ID</param>
    /// <returns></returns>
    [HttpPost("{sessionId}/revoke")]
    public async Task RevokeSessionAsync(Guid sessionId)
    {
        await userSessionAppService.MarkAsInactiveAsync(sessionId);
    }
}

