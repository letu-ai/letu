using Letu.Basis.Admin.Loggings;
using Letu.Basis.Admin.Loggings.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Admin.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/loginLog")]
    public class SecurityLogController : ControllerBase
    {
        private readonly ISecurityLogAppService _loginLogService;

        public SecurityLogController(ISecurityLogAppService loginLogService)
        {
            _loginLogService = loginLogService;
        }

        /// <summary>
        /// 登录日志分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet("GetLoginLogList")]
        public async Task<AppResponse<PagedResult<LoginLogListDto>>> GetLoginLogListAsync([FromQuery] LoginLogQueryDto dto)
        {
            var data = await _loginLogService.GetLoginLogListAsync(dto);
            return Result.Data(data);
        }
    }
}