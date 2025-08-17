using System;
using Volo.Abp.Auditing;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.Roles;

[Serializable]
public class RoleEto : IMultiTenant, IHasEntityVersion
{
    public Guid Id { get; set; }

    public Guid? TenantId { get; set; }

    public required string Name { get; set; }

    public bool IsDefault { get; set; }

    public bool IsStatic { get; set; }

    public bool IsPublic { get; set; }

    public int EntityVersion { get; set; }
}
