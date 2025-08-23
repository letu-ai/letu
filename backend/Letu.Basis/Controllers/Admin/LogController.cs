using Letu.Basis.Admin.Loggings;
using Letu.Basis.Admin.Loggings.Dtos;
using Letu.Basis.Admin.OnlineUsers.Dtos;
using Letu.Core.Applications;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin
{
    [Authorize]
    [ApiController]
    [Route("api/admin/logs")]
    public class MonitorLogController: ControllerBase
    {
        private readonly IMonitorLogService _monitorLogService;
        private readonly IBusinessLogAppService businessLogService;
        private readonly ISecurityLogAppService _securityLogService;

        public MonitorLogController(IMonitorLogService monitorLogService, IBusinessLogAppService businessLogService, ISecurityLogAppService securityLogService)
        {
            _monitorLogService = monitorLogService;
            this.businessLogService = businessLogService;
            _securityLogService = securityLogService;
        }

        /// <summary>
        /// API访问日志列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet("access")]
        // [HasPermission("Monitor.ApiAccessLogList")]
        public async Task<PagedResult<ApiAccessLogListDto>> GetApiAccessLogListAsync([FromQuery] ApiAccessLogQueryDto dto)
        {
            return await _monitorLogService.GetApiAccessLogListAsync(dto);
        }

        /// <summary>
        /// 异常日志列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet("exception")]
        // [HasPermission("Monitor.ExceptionLogList")]
        public async Task<PagedResult<ExceptionLogListDto>> GetExceptionLogListAsync([FromQuery] ExceptionLogQueryDto dto)
        {
            return await _monitorLogService.GetExceptionLogListAsync(dto);
        }

        /// <summary>
        /// 标记异常已处理
        /// </summary>
        /// <param name="exceptionId">异常日志ID</param>
        /// <returns></returns>
        [HttpPost("exception/{exceptionId}/handled")]
        // [HasPermission("Monitor.ExceptionLog.HandleException")]
        public async Task HandleExceptionAsync(Guid exceptionId)
        {
            await _monitorLogService.HandleExceptionAsync(exceptionId);
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
            return await _securityLogService.GetLoginLogListAsync(dto);
        }
    }
}