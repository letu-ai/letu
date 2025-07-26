using Letu.Basis.Admin.Logging.Dtos;
using Letu.Logger.Entities;
using Letu.Repository;

namespace Letu.Basis.Admin.Logging
{
    public class BusinessLogService : IBusinessLogService
    {
        private readonly IRepository<LogRecordDO> _logRecordRepository;

        public BusinessLogService(IRepository<LogRecordDO> logRecordRepository)
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