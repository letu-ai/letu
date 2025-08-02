using Volo.Abp.Application.Dtos;

namespace Letu.Basis.Admin.AuditLogging.AuditLogs.Dtos;

public class AuditLogListOutput : EntityDto<Guid>
{
    public Guid? UserId { get; set; }

    public string UserName { get; set; } = string.Empty;

    public Guid? TenantId { get; set; }

    public Guid? ImpersonatorUserId { get; set; }

    public Guid? ImpersonatorTenantId { get; set; }

    public DateTime ExecutionTime { get; set; }

    public int ExecutionDuration { get; set; }

    public string ClientIpAddress { get; set; } = string.Empty;

    public string ClientName { get; set; } = string.Empty;

    public string BrowserInfo { get; set; } = string.Empty;

    public string HttpMethod { get; set; } = string.Empty;

    public string Url { get; set; } = string.Empty;

    public string Exceptions { get; set; } = string.Empty;

    public string Comments { get; set; } = string.Empty;

    public int? HttpStatusCode { get; set; }

    public string ApplicationName { get; set; } = string.Empty;

    public string CorrelationId { get; set; } = string.Empty;
}
