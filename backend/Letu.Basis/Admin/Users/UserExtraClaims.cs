namespace Letu.Basis.Admin.Users;

public sealed class UserExtraClaims
{
    public Guid? OrganizationUnitId { get; init; }
    public Guid? DepartmentId { get; init; }
    public string[] Tags { get; init; } = [];
}
