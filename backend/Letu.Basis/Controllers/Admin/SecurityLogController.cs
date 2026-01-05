using Letu.Basis.Admin.Loggings;
using Letu.Basis.Admin.Loggings.Dtos;
using Letu.Core.Applications;
using Letu.Basis.Permissions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin;

[Authorize(BasisPermissions.Logging.SecurityLog)]
[ApiController]
[Route("api/admin/logs/security")]
public class SecurityLogController : ControllerBase
{
    private readonly ISecurityLogAppService securityLogService;

    public SecurityLogController(ISecurityLogAppService securityLogService)
    {
        this.securityLogService = securityLogService;
    }

    /// <summary>
    /// 登录日志分页列表
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    [HttpGet]
    public async Task<PagedResult<SecurityLogListOutput>> GetSecurityLogListAsync([FromQuery] SecurityLogListInput input)
    {
        return await securityLogService.GetSecurityLogListAsync(input);
    }
}