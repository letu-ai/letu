using Letu.Applications;
using Letu.Basis.IService.System;
using Letu.Basis.IService.System.Dtos;
using Letu.Basis.Permissions;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin
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
        [Authorize(BasisPermissions.ScheduledTask.Create)]
        public async Task CreateAsync([FromBody] ScheduledTaskDto dto)
        {
            await _scheduledTaskService.AddAsync(dto);
        }

        /// <summary>
        /// 获取定时任务列表
        /// </summary>
        [HttpGet]
        public async Task<PagedResult<ScheduledTaskListDto>> GetListAsync([FromQuery] ScheduledTaskQueryDto dto)
        {
            return await _scheduledTaskService.GetListAsync(dto);
        }

        /// <summary>
        /// 更新定时任务
        /// </summary>
        [HttpPut("{id}")]
        [Authorize(BasisPermissions.ScheduledTask.Update)]
        public async Task UpdateAsync(Guid id, [FromBody] ScheduledTaskDto dto)
        {
            await _scheduledTaskService.UpdateAsync(id, dto);
        }

        /// <summary>
        /// 删除定时任务
        /// </summary>
        [HttpDelete("{key}")]
        [Authorize(BasisPermissions.ScheduledTask.Delete)]
        public async Task DeleteAsync(string key)
        {
            await _scheduledTaskService.DeleteAsync(key);
        }

        /// <summary>
        /// 获取定时任务执行日志
        /// </summary>
        [HttpGet("logs")]
        [Authorize(BasisPermissions.ScheduledTask.Log)]
        public async Task<PagedResult<TaskExecutionLogListDto>> GetExecutionLogsAsync([FromQuery] TaskExecutionLogQueryDto dto)
        {
            return await _scheduledTaskService.GetExecutionLogListAsync(dto);
        }
    }
}
