using Letu.Basis.Admin.AuditLogging.AuditLogs.Dtos;
using Letu.Repository;
using Volo.Abp.Application.Dtos;
using Volo.Abp.Application.Services;
using Volo.Abp.Auditing;
using Volo.Abp.AuditLogging;
using Volo.Abp.Domain.Entities;

namespace Letu.Basis.Admin.AuditLogging.AuditLogs;

[DisableAuditing]
public class AuditLogAppService : ApplicationService, IAuditLogAppService
{
    private IFreeSqlRepository<AuditLog> auditLogRepository;
    public AuditLogAppService(
        IFreeSqlRepository<AuditLog> auditLogRepository)
    {
        this.auditLogRepository = auditLogRepository;
    }

    public virtual async Task<PagedResultDto<AuditLogListOutput>> GetListAsync(GetAuditLogListInput input)
    {
        var query = auditLogRepository.Select
            .WhereIf(input.StartTime.HasValue, x => x.ExecutionTime >= input.StartTime!.Value)
            .WhereIf(input.EndTime.HasValue, x => x.ExecutionTime <= input.EndTime!.Value)
            .WhereIf(!string.IsNullOrEmpty(input.HttpMethod), x => x.HttpMethod == input.HttpMethod)
            .WhereIf(!string.IsNullOrEmpty(input.Url), x => x.Url != null && x.Url.Contains(input.Url))
            .WhereIf(!string.IsNullOrEmpty(input.ClientId), x => x.ClientId != null && x.ClientId == input.ClientId)
            .WhereIf(input.UserId.HasValue, x => x.UserId == input.UserId)
            .WhereIf(!string.IsNullOrEmpty(input.UserName), x => x.UserName != null && x.UserName.Contains(input.UserName))
            .WhereIf(!string.IsNullOrEmpty(input.ApplicationName), x => x.ApplicationName != null && x.ApplicationName == input.ApplicationName)
            .WhereIf(!string.IsNullOrEmpty(input.ClientIpAddress), x => x.ClientIpAddress != null && x.ClientIpAddress == input.ClientIpAddress)
            .WhereIf(!string.IsNullOrEmpty(input.CorrelationId), x => x.CorrelationId != null && x.CorrelationId == input.CorrelationId)
            .WhereIf(input.MaxExecutionDuration.HasValue, x => x.ExecutionDuration <= input.MaxExecutionDuration!.Value)
            .WhereIf(input.MinExecutionDuration.HasValue, x => x.ExecutionDuration >= input.MinExecutionDuration!.Value)
            .WhereIf(input.HasException.HasValue, x => (x.Exceptions != null && x.Exceptions.Length > 0) == input.HasException.Value)
            .WhereIf(input.HttpStatusCode.HasValue, x => x.HttpStatusCode == (int)input.HttpStatusCode!.Value);

        var totalCount = await query.CountAsync();
        if (totalCount == 0)
        {
            return new PagedResultDto<AuditLogListOutput>();
        }

        // 处理排序
        if (!string.IsNullOrEmpty(input.Sorting))
        {
            // 默认按执行时间降序排列
            query = query.OrderByPropertyNameIf(!string.IsNullOrEmpty(input.Sorting), input.Sorting, false);
        }
        else
        {
            query = query.OrderByDescending(x => x.ExecutionTime);
        }

        // 分页
        var list = await query
            .Skip(input.SkipCount)
            .Take(input.MaxResultCount)
            .ToListAsync();

        return new PagedResultDto<AuditLogListOutput>(totalCount, ObjectMapper.Map<List<AuditLog>, List<AuditLogListOutput>>(list));
    }

    public virtual async Task<AuditLogDetailOutput> GetAsync(Guid id)
    {
        // 使用嵌套的IncludeMany一次性查询审计日志及所有关联数据
        var auditLog = await auditLogRepository.Select
            .Where(x => x.Id == id)
            .IncludeMany(x => x.Actions)
            .IncludeMany(x => x.EntityChanges, then => then.IncludeMany(y => y.PropertyChanges))
            .ToOneAsync();

        if (auditLog == null)
        {
            throw new EntityNotFoundException(typeof(AuditLog), id);
        }

        var auditLogDto = ObjectMapper.Map<AuditLog, AuditLogDetailOutput>(auditLog);
        return auditLogDto;
    }

    public virtual async Task<GetErrorRateOutput> GetErrorRateAsync(GetErrorRateFilter filter)
    {
        var endDate = filter.EndDate.AddDays(1.0);

        long successfulLogCount = await auditLogRepository.Select
            .Where(x => x.ExecutionTime >= filter.StartDate && x.ExecutionTime < endDate)
            .Where(x => x.Exceptions == null || x.Exceptions == string.Empty)
            .CountAsync();

        long exceptionLogCount = await auditLogRepository.Select
            .Where(x => x.ExecutionTime >= filter.StartDate && x.ExecutionTime < endDate)
            .Where(x => x.Exceptions != null && x.Exceptions != string.Empty)
            .CountAsync();

        return new GetErrorRateOutput
        {
            Data = new Dictionary<string, long>
            {
                { L["Fault"], exceptionLogCount },
                { L["Success"], successfulLogCount }
            }
        };
    }

    public virtual async Task<GetAverageExecutionDurationPerDayOutput> GetAverageExecutionDurationPerDayAsync(GetAverageExecutionDurationPerDayInput filter)
    {
        var logs = await auditLogRepository.Select
            .Where(x => x.ExecutionTime >= filter.StartDate && x.ExecutionTime <= filter.EndDate)
            .ToListAsync(x => new
            {
                x.ExecutionTime,
                x.ExecutionDuration
            });

        // 按天分组计算平均执行时间
        var averageDurationPerDay = logs
            .GroupBy(x => x.ExecutionTime.Date)
            .ToDictionary(g => g.Key, g => g.Average(x => x.ExecutionDuration));

        return new GetAverageExecutionDurationPerDayOutput
        {
            Data = averageDurationPerDay.ToDictionary(x => x.Key.ToString("d"), x => x.Value)
        };
    }
}
