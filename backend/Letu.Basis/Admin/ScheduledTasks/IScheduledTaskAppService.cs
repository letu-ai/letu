using Letu.Applications;
using Letu.Basis.IService.System.Dtos;

namespace Letu.Basis.IService.System
{
    public interface IScheduledTaskAppService
    {
        Task AddAsync(ScheduledTaskDto dto);

        Task<PagedResult<ScheduledTaskListDto>> GetListAsync(ScheduledTaskQueryDto dto);

        Task UpdateAsync(ScheduledTaskDto dto);

        Task DeleteAsync(string key);

        Task<PagedResult<TaskExecutionLogListDto>> GetExecutionLogListAsync(TaskExecutionLogQueryDto dto);
    }
}