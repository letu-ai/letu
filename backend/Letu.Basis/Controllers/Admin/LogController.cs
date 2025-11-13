using Letu.Basis.Admin.Loggings;
using Letu.Basis.Admin.Loggings.Dtos;
using Letu.Core.Applications;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin
{
    [Authorize]
    [ApiController]
    [Route("api/admin/logs")]
    public class MonitorLogController : ControllerBase
    {
        private readonly IBusinessLogAppService businessLogService;
        private readonly ISecurityLogAppService securityLogService;

        public MonitorLogController(IBusinessLogAppService businessLogService, ISecurityLogAppService securityLogService)
        {
            this.businessLogService = businessLogService;
            this.securityLogService = securityLogService;
        }

        /// <summary>
        /// 业务日志分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet("business")]
        public async Task<PagedResult<BusinessLogListDto>> GetBusinessLogListAsync([FromQuery] BusinessLogQueryDto dto)
        {
            return await businessLogService.GetBusinessLogListAsync(dto);
        }

        /// <summary>
        /// 获取所有业务类型选项
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        [HttpGet("business/type-options")]
        public async Task<List<SelectOption>> GetBusinessTypeOptionsAsync(string? type)
        {
            return await businessLogService.GetBusinessTypeOptionsAsync(type);
        }

        /// <summary>
        /// 登录日志分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet("security")]
        // [HasPermission("Monitor.SecurityLogList")]
        public async Task<PagedResult<LoginLogListDto>> GetLoginLogListAsync([FromQuery] LoginLogQueryDto dto)
        {
            return await securityLogService.GetLoginLogListAsync(dto);
        }
    }
}