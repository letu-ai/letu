using Letu.Applications;
using Letu.Basis.Admin.Loggings.Dtos;
using Letu.Logging.Entities;
using Letu.Repository;
using Letu.Shared.Models;
using Volo.Abp.Application.Services;

namespace Letu.Basis.Admin.Loggings
{
    public class BusinessLogAppService : ApplicationService, IBusinessLogAppService
    {
        private readonly IFreeSqlRepository<LogRecord> _logRecordRepository;

        public BusinessLogAppService(IFreeSqlRepository<LogRecord> logRecordRepository)
        {
            _logRecordRepository = logRecordRepository;
        }

        public async Task<PagedResult<BusinessLogListDto>> GetBusinessLogListAsync(BusinessLogQueryDto dto)
        {
            var list = await _logRecordRepository.WhereIf(!string.IsNullOrEmpty(dto.Type), x => x.Type == dto.Type)
                .WhereIf(!string.IsNullOrEmpty(dto.SubType), x => x.SubType != null && x.SubType.Contains(dto.SubType!))
                .WhereIf(!string.IsNullOrEmpty(dto.Content), x => x.Content != null && x.Content.Contains(dto.Content!))
                .WhereIf(!string.IsNullOrEmpty(dto.UserName), x => x.UserName != null && x.UserName.Contains(dto.UserName!))
                .OrderByDescending(x => x.CreationTime)
                .Count(out long count)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync<BusinessLogListDto>();
            return new PagedResult<BusinessLogListDto>(dto, count, list);
        }

        public Task<List<AppOption>> GetBusinessTypeOptionsAsync(string? type)
        {
            return _logRecordRepository.WhereIf(!string.IsNullOrEmpty(type), x => x.Type != null && x.Type.Contains(type!))
                .GroupBy(x => x.Type)
                .OrderBy(x => x.Key)
                .ToListAsync(x => new AppOption { Label = x.Key, Value = x.Key });
        }
    }
}