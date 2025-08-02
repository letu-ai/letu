using Letu.Basis.Admin.AuditLogging.AuditLogs;
using Letu.Basis.Admin.AuditLogging.AuditLogs.Dtos;
using Letu.Basis.Admin.AuditLogging.EntityChangeLogs;
using Letu.Basis.Admin.AuditLogging.EntityChangeLogs.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Volo.Abp.Application.Dtos;
using Volo.Abp.Auditing;

namespace Letu.Basis.Controllers.Admin;

[Authorize]
[ApiController]
[Route("api/admin/auditlog")]
[DisableAuditing]
public class AuditLogController : ControllerBase
{
    protected IAuditLogAppService AuditLogsAppService { get; }
    private readonly IEntityChangeLogAppService entityChangeLogAppService;

    public AuditLogController(IAuditLogAppService auditLogsAppService, IEntityChangeLogAppService entityChangeLogAppService)
    {
        AuditLogsAppService = auditLogsAppService;
        this.entityChangeLogAppService = entityChangeLogAppService;
    }

    [HttpGet]
    public virtual async Task<PagedResultDto<AuditLogListOutput>> GetListAsync([FromQuery] GetAuditLogListInput input)
    {
        return await AuditLogsAppService.GetListAsync(input);
    }

    [HttpGet("{id}")]
    public virtual async Task<AuditLogDetailOutput> GetAsync(Guid id)
    {
        return await AuditLogsAppService.GetAsync(id);
    }

    [HttpGet("statistics/error-rate")]
    public virtual async Task<GetErrorRateOutput> GetErrorRateAsync([FromQuery] GetErrorRateFilter filter)
    {
        return await AuditLogsAppService.GetErrorRateAsync(filter);
    }

    [HttpGet("statistics/average-execution-duration-per-day")]
    public virtual async Task<GetAverageExecutionDurationPerDayOutput> GetAverageExecutionDurationPerDayAsync([FromQuery] GetAverageExecutionDurationPerDayInput filter)
    {
        return await AuditLogsAppService.GetAverageExecutionDurationPerDayAsync(filter);
    }

    [HttpGet("entity-changes/")]
    public virtual async Task<PagedResultDto<EntityChangeDto>> GetEntityChangesAsync([FromQuery] GetEntityChangesInput input)
    {
        return await entityChangeLogAppService.GetEntityChangesAsync(input);
    }

    [HttpGet("entity-changes-with-username/")]
    public virtual async Task<List<EntityChangeWithUsernameDto>> GetEntityChangesWithUsernameAsync([FromQuery] EntityChangeFilter input)
    {
        return await entityChangeLogAppService.GetEntityChangesWithUsernameAsync(input);
    }

    [HttpGet("entity-change-with-username/{entityChangeId}")]
    public virtual async Task<EntityChangeWithUsernameDto> GetEntityChangeWithUsernameAsync(Guid entityChangeId)
    {
        return await entityChangeLogAppService.GetEntityChangeWithUsernameAsync(entityChangeId);
    }

    [HttpGet("entity-changes/{entityChangeId}")]
    public virtual async Task<EntityChangeDto> GetEntityChangeAsync(Guid entityChangeId)
    {
        return await entityChangeLogAppService.GetEntityChangeAsync(entityChangeId);
    }

}