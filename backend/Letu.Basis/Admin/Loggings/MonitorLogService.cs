using Letu.Basis.Admin.OnlineUsers.Dtos;
using Letu.Core.Applications;
using Letu.Logging.Entities;
using Letu.Repository;
using Volo.Abp.Application.Services;
using Volo.Abp.Domain.Entities;

namespace Letu.Basis.Admin.Loggings
{
    public class MonitorLogService : BasisAppService, IMonitorLogService
    {
        private readonly IFreeSqlRepository<ApiAccessLog> _apiAccessRepository;
        private readonly IFreeSqlRepository<ExceptionLog> _exceptionLogRepository;

        public MonitorLogService(IFreeSqlRepository<ApiAccessLog> apiAccessRepository, IFreeSqlRepository<ExceptionLog> exceptionLogRepository)
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
            entity.HandledBy = CurrentUser.UserName;
            entity.HandledTime = DateTime.Now;
            await _exceptionLogRepository.UpdateAsync(entity);
        }
    }
}