using Fancyx.Admin.IService.Monitor;
using Fancyx.Admin.IService.Monitor.Dtos;
using Fancyx.Core.Interfaces;
using Fancyx.Logger.Entities;
using Fancyx.Repository;

namespace Fancyx.Admin.Service.Monitor
{
    public class MonitorLogService : IMonitorLogService, IScopedDependency
    {
        private readonly IRepository<ApiAccessLogDO> _apiAccessRepository;
        private readonly IRepository<ExceptionLogDO> _exceptionLogRepository;

        public MonitorLogService(IRepository<ApiAccessLogDO> apiAccessRepository, IRepository<ExceptionLogDO> exceptionLogRepository)
        {
            _apiAccessRepository = apiAccessRepository;
            _exceptionLogRepository = exceptionLogRepository;
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
                .OrderByDescending(x => x.CreationTime)
                .Count(out long count)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync<ExceptionLogListDto>();
            return new PagedResult<ExceptionLogListDto>(dto, count, list);
        }
    }
}