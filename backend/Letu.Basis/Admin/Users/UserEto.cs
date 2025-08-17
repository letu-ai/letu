using Volo.Abp.MultiTenancy;

namespace Letu.Basis.Admin.Users;

public class UserEto : IMultiTenant
{
    public Guid Id { get; set; }

    public Guid? TenantId { get; set; }

    public required string UserName { get; set; }

    public string? Name { get; set; }

    public bool IsActive { get; set; }
}
