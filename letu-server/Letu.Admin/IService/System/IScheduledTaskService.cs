using Letu.Admin.IService.System.Dtos;
using Letu.Core.Interfaces;

namespace Letu.Admin.IService.System
{
    public interface IScheduledTaskService : IScopedDependency
    {
        Task AddAsync(ScheduledTaskDto dto);

        Task<PagedResult<ScheduledTaskListDto>> GetListAsync(ScheduledTaskQueryDto dto);

        Task UpdateAsync(ScheduledTaskDto dto);

        Task DeleteAsync(string key);

        Task<PagedResult<TaskExecutionLogListDto>> GetExecutionLogListAsync(TaskExecutionLogQueryDto dto);
    }
}