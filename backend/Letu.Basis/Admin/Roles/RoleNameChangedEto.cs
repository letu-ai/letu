using System;
using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.Roles;

[Serializable]
public class RoleNameChangedEto : IMultiTenant 
{
    public Guid Id { get; set; }

    public Guid? TenantId { get; set; }

    public required string Name { get; set; }

    public required string OldName { get; set; }
}
