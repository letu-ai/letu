using Volo.Abp.Application.Dtos;

namespace Letu.Basis.Admin.AuditLogging.AuditLogs.Dtos;

public class AuditLogActionDto : EntityDto<Guid>
{
    public Guid? TenantId { get; set; }

    public Guid AuditLogId { get; set; }

    public string ServiceName { get; set; } = string.Empty;

    public string MethodName { get; set; } = string.Empty;

    public string Parameters { get; set; } = string.Empty;

    public DateTime ExecutionTime { get; set; }

    public int ExecutionDuration { get; set; }
}
