using FreeSql.DataAnnotations;
using Volo.Abp.Domain.Entities.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.Integrations;

[Table(Name = "sys_integration_settings")]
public class IntegrationSettings : AuditedEntity<Guid>, IMultiTenant
{
    public Guid? TenantId { get; set; }

    public required string Name { get; set; }

    public bool IsEnabled { get; set; }

    [Column(DbType = "jsonb")]
    public string? Values { get; set; }
}