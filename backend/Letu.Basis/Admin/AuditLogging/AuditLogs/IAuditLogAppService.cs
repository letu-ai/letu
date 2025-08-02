using Letu.Basis.Admin.AuditLogging.AuditLogs.Dtos;
using Volo.Abp.Application.Dtos;

namespace Letu.Basis.Admin.AuditLogging.AuditLogs;

public interface IAuditLogAppService
{
    Task<PagedResultDto<AuditLogListOutput>> GetListAsync(GetAuditLogListInput input);

    Task<AuditLogDetailOutput> GetAsync(Guid id);

    Task<GetErrorRateOutput> GetErrorRateAsync(GetErrorRateFilter filter);

    Task<GetAverageExecutionDurationPerDayOutput> GetAverageExecutionDurationPerDayAsync(GetAverageExecutionDurationPerDayInput filter);

}
