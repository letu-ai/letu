using Letu.Basis.Admin.Loggings.Dtos;
using Letu.Core.Applications;
using Letu.Logging.BusinessLogs;
using Letu.Repository;

namespace Letu.Basis.Admin.Loggings;

public class BusinessLogAppService : BasisAppService, IBusinessLogAppService
{
    private readonly IFreeSqlRepository<BusinessLog> logRepository;

    public BusinessLogAppService(IFreeSqlRepository<BusinessLog> logRecordRepository)
    {
        logRepository = logRecordRepository;
    }

    public async Task<PagedResult<BusinessLogListOutput>> GetBusinessLogListAsync(BusinessLogListInput dto)
    {
        var list = await logRepository.WhereIf(!string.IsNullOrEmpty(dto.Type), x => x.Type == dto.Type)
            .WhereIf(!string.IsNullOrEmpty(dto.SubType), x => x.SubType != null && x.SubType.Contains(dto.SubType!))
            .WhereIf(!string.IsNullOrEmpty(dto.Content), x => x.Content != null && x.Content.Contains(dto.Content!))
            .WhereIf(!string.IsNullOrEmpty(dto.UserName), x => x.UserName != null && x.UserName.Contains(dto.UserName!))
            .OrderByDescending(x => x.CreationTime)
            .Count(out long count)
            .Page(dto.Current, dto.PageSize)
            .ToListAsync<BusinessLogListOutput>();
        return new PagedResult<BusinessLogListOutput>(dto, count, list);
    }

    public Task<List<SelectOption>> GetBusinessTypeOptionsAsync(string? type)
    {
        return logRepository.WhereIf(!string.IsNullOrEmpty(type), x => x.Type != null && x.Type.Contains(type!))
            .GroupBy(x => x.Type)
            .OrderBy(x => x.Key)
            .ToListAsync(x => new SelectOption { Label = x.Key!, Value = x.Key! });
    }
}