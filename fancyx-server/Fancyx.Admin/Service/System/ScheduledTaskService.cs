using Fancyx.Admin.IService.System;
using Fancyx.Admin.IService.System.Dtos;
using Fancyx.Job;
using Fancyx.Job.Database.Entities;
using Fancyx.Repository;

namespace Fancyx.Admin.Service.System
{
    public class ScheduledTaskService : IScheduledTaskService
    {
        private readonly IRepository<ScheduledTaskDO> _scheduledTaskRepository;
        private readonly IRepository<TaskExecutionLogDO> _taskExecutionLogRepository;
        private readonly IJobControl _jobControl;

        public ScheduledTaskService(IRepository<ScheduledTaskDO> scheduledTaskRepository, IRepository<TaskExecutionLogDO> taskExecutionLogRepository, IJobControl jobControl)
        {
            _scheduledTaskRepository = scheduledTaskRepository;
            _taskExecutionLogRepository = taskExecutionLogRepository;
            _jobControl = jobControl;
        }

        public Task AddAsync(ScheduledTaskCreateDto dto)
        {
            return _jobControl.AddJobAsync(dto.TaskKey, dto.CronExpression, dto.Description, dto.IsActive);
        }

        public Task DeleteAsync(string key)
        {
            return _jobControl.DeleteJobAsync(key);
        }

        public async Task<PagedResult<TaskExecutionLogListDto>> GetExecutionLogListAsync(TaskExecutionLogQueryDto dto)
        {
            var list = await _taskExecutionLogRepository.WhereIf(!string.IsNullOrEmpty(dto.TaskKey), x => x.TaskKey == dto.TaskKey)
                .WhereIf(dto.Status > 0, x => x.Status == dto.Status!.Value)
                .WhereIf(dto.ExecutionTimeRange != null && dto.ExecutionTimeRange.Length >= 2, x => x.ExecutionTime >= dto.ExecutionTimeRange![0] && x.ExecutionTime <= dto.ExecutionTimeRange![1])
                .WhereIf(dto.Cost > 0, x => x.Cost >= dto.Cost)
                .OrderByDescending(x => x.ExecutionTime)
                .Count(out var total)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync<TaskExecutionLogListDto>();
            return new PagedResult<TaskExecutionLogListDto>(dto, total, list);
        }

        public async Task<PagedResult<ScheduledTaskListDto>> GetListAsync(ScheduledTaskQueryDto dto)
        {
            var list = await _scheduledTaskRepository.WhereIf(!string.IsNullOrEmpty(dto.TaskKey), x => x.TaskKey == dto.TaskKey)
                .WhereIf(!string.IsNullOrEmpty(dto.Description), x => x.Description != null && x.Description.Contains(dto.Description!))
                .OrderByDescending(x => x.CreationTime)
                .Count(out var total)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync<ScheduledTaskListDto>();
            return new PagedResult<ScheduledTaskListDto>(dto, total, list);
        }

        public async Task UpdateAsync(ScheduledTaskUpdateDto dto)
        {
            var entity = await _scheduledTaskRepository.OneAsync(x => x.Id == dto.Id) ?? throw new EntityNotFoundException();
            await _jobControl.UpdateJobAsync(entity.TaskKey, dto.TaskKey, dto.CronExpression, dto.Description, dto.IsActive);
        }
    }
}