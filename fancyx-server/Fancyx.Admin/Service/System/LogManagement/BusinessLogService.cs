using Fancyx.Admin.IService.System.LogManagement;
using Fancyx.Admin.IService.System.LogManagement.Dtos;
using Fancyx.Logger.Entities;
using Fancyx.Repository;

namespace Fancyx.Admin.Service.System.LogManagement
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
                .OrderBy(x => x.CreationTime)
                .Count(out long count)
                .Page(dto.Current, dto.PageSize)
                .ToListAsync<BusinessLogListDto>();
            return new PagedResult<BusinessLogListDto>(dto, count, list);
        }

        public Task<List<AppOption>> GetBusinessTypeOptionsAsync(string? type)
        {
            return _logRecordRepository.WhereIf(!string.IsNullOrEmpty(type), x => x.Type != null && x.Type.Contains(type))
                .ToListAsync(x => new AppOption { Label = x.Type, Value = x.Type });
        }
    }
}