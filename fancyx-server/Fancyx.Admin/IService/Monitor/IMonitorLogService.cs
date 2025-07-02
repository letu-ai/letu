using Fancyx.Admin.IService.Monitor.Dtos;

namespace Fancyx.Admin.IService.Monitor
{
    public interface IMonitorLogService
    {
        /// <summary>
        /// API访问日志列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<PagedResult<ApiAccessLogListDto>> GetApiAccessLogListAsync(ApiAccessLogQueryDto dto);

        /// <summary>
        /// 异常日志列表
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        Task<PagedResult<ExceptionLogListDto>> GetExceptionLogListAsync(ExceptionLogQueryDto dto);
    }
}
