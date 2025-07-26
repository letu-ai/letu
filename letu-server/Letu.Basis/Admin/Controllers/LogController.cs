using Letu.Basis.Admin.Loggings;
using Letu.Basis.Admin.Loggings.Dtos;
using Letu.Basis.Admin.OnlineUsers.Dtos;
using Letu.Core.Attributes;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Admin.Controllers
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
        [HasPermission("Monitor.ApiAccessLogList")]
        public async Task<AppResponse<PagedResult<ApiAccessLogListDto>>> GetApiAccessLogListAsync([FromQuery] ApiAccessLogQueryDto dto)
        {
            var data = await _monitorLogService.GetApiAccessLogListAsync(dto);
            return Result.Data(data);
        }

        /// <summary>
        /// 异常日志列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet("exceptions")]
        [HasPermission("Monitor.ExceptionLogList")]
        public async Task<AppResponse<PagedResult<ExceptionLogListDto>>> GetExceptionLogListAsync([FromQuery] ExceptionLogQueryDto dto)
        {
            var data = await _monitorLogService.GetExceptionLogListAsync(dto);
            return Result.Data(data);
        }

        /// <summary>
        /// 标记异常已处理
        /// </summary>
        /// <param name="exceptionId">异常日志ID</param>
        /// <returns></returns>
        [HttpPost("handle-exception/{exceptionId}")]
        [HasPermission("Monitor.ExceptionLog.HandleException")]
        public async Task<AppResponse<bool>> HandleExceptionAsync(Guid exceptionId)
        {
            await _monitorLogService.HandleExceptionAsync(exceptionId);
            return Result.Ok();
        }

           /// <summary>
        /// 业务日志分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet("business")]
        public async Task<AppResponse<PagedResult<BusinessLogListDto>>> GetBusinessLogListAsync([FromQuery] BusinessLogQueryDto dto)
        {
            var data = await businessLogService.GetBusinessLogListAsync(dto);
            return Result.Data(data);
        }

        /// <summary>
        /// 获取所有业务类型选项
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        [HttpGet("types")]
        public async Task<AppResponse<List<AppOption>>> GetBusinessTypeOptionsAsync(string? type)
        {
            var data = await businessLogService.GetBusinessTypeOptionsAsync(type);
            return Result.Data(data);
        }

        /// <summary>
        /// 登录日志分页列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        [HttpGet("security")]
        [HasPermission("Monitor.SecurityLogList")]
        public async Task<AppResponse<PagedResult<LoginLogListDto>>> GetLoginLogListAsync([FromQuery] LoginLogQueryDto dto)
        {
            var data = await _securityLogService.GetLoginLogListAsync(dto);
            return Result.Data(data);
        }
    }
}
