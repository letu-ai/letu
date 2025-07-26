
using Letu.Basis.IService.Monitor;
using Letu.Basis.IService.Monitor.Dtos;
using Letu.Core.Interfaces;
using Letu.Logger.Entities;
using Letu.Repository;

namespace Letu.Basis.Service.Monitor
{
    public class MonitorLogService : IMonitorLogService, IScopedDependency
    {
        private readonly IRepository<ApiAccessLogDO> _apiAccessRepository;
        private readonly IRepository<ExceptionLogDO> _exceptionLogRepository;
        private readonly ICurrentUser _currentUser;

        public MonitorLogService(IRepository<ApiAccessLogDO> apiAccessRepository, IRepository<ExceptionLogDO> exceptionLogRepository, ICurrentUser currentUser)
        {
            _apiAccessRepository = apiAccessRepository;
            _exceptionLogRepository = exceptionLogRepository;
            _currentUser = currentUser;
        }

        public async Task<PagedResult<ApiAccessLogListDto>> GetApiAccessLogListAsync(ApiAccessLogQueryDto dto)
        {
            var list = await _apiAccessRepository.WhereIf(!string.IsNullOrEmpty(dto.UserName), x => x.UserName != null && x.UserName.Contains(dto.UserName!))
                .WhereIf(!string.IsNullOrEmpty(dto.Path), x => x.Path.Contains(dto.Path!))
                .OrderByDescending(x => x.CreationTime)
                .Count(out long count)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync<ApiAccessLogListDto>();
            return new PagedResult<ApiAccessLogListDto>(dto, count, list);
        }

        public async Task<PagedResult<ExceptionLogListDto>> GetExceptionLogListAsync(ExceptionLogQueryDto dto)
        {
            var list = await _exceptionLogRepository.WhereIf(!string.IsNullOrEmpty(dto.UserName), x => x.UserName != null && x.UserName.Contains(dto.UserName!))
                .WhereIf(!string.IsNullOrEmpty(dto.Path), x => x.RequestPath != null && x.RequestPath.Contains(dto.Path!))
                .WhereIf(dto.IsHandled.HasValue, x => x.IsHandled == dto.IsHandled!)
                .OrderByDescending(x => x.CreationTime)
                .Count(out long count)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync<ExceptionLogListDto>();
            return new PagedResult<ExceptionLogListDto>(dto, count, list);
        }

        public async Task HandleExceptionAsync(Guid exceptionId)
        {
            var entity = await _exceptionLogRepository.OneAsync(x => x.Id == exceptionId);
            if (entity == null) throw new EntityNotFoundException();
            entity.IsHandled = true;
            entity.HandledBy = _currentUser.UserName;
            entity.HandledTime = DateTime.Now;
            await _exceptionLogRepository.UpdateAsync(entity);
        }
    }
}