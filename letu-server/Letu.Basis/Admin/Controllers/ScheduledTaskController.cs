using Letu.Basis.IService.System;
using Letu.Basis.IService.System.Dtos;
using Letu.Core.Attributes;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Admin.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/admin/scheduled-tasks")]
    public class ScheduledTaskController : ControllerBase
    {
        private readonly IScheduledTaskAppService _scheduledTaskService;

        public ScheduledTaskController(IScheduledTaskAppService scheduledTaskService)
        {
            _scheduledTaskService = scheduledTaskService;
        }

        /// <summary>
        /// 创建定时任务
        /// </summary>
        [HttpPost]
        [HasPermission("Sys.ScheduledTask.Add")]
        public async Task<AppResponse<bool>> CreateAsync([FromBody] ScheduledTaskDto dto)
        {
            await _scheduledTaskService.AddAsync(dto);
            return Result.Ok();
        }

        /// <summary>
        /// 获取定时任务列表
        /// </summary>
        [HttpGet]
        [HasPermission("Sys.ScheduledTask.List")]
        public async Task<AppResponse<PagedResult<ScheduledTaskListDto>>> GetListAsync([FromQuery] ScheduledTaskQueryDto dto)
        {
            var data = await _scheduledTaskService.GetListAsync(dto);
            return Result.Data(data);
        }

        /// <summary>
        /// 更新定时任务
        /// </summary>
        [HttpPut("{key}")]
        [HasPermission("Sys.ScheduledTask.Update")]
        public async Task<AppResponse<bool>> UpdateAsync(string key, [FromBody] ScheduledTaskDto dto)
        {
            await _scheduledTaskService.UpdateAsync(dto);
            return Result.Ok();
        }

        /// <summary>
        /// 删除定时任务
        /// </summary>
        [HttpDelete("{key}")]
        [HasPermission("Sys.ScheduledTask.Delete")]
        public async Task<AppResponse<bool>> DeleteAsync(string key)
        {
            await _scheduledTaskService.DeleteAsync(key);
            return Result.Ok();
        }

        /// <summary>
        /// 获取定时任务执行日志
        /// </summary>
        [HttpGet("logs")]
        [HasPermission("Sys.ScheduledTask.Log")]
        public async Task<AppResponse<PagedResult<TaskExecutionLogListDto>>> GetExecutionLogsAsync([FromQuery] TaskExecutionLogQueryDto dto)
        {
            var data = await _scheduledTaskService.GetExecutionLogListAsync(dto);
            return Result.Data(data);
        }
    }
}
