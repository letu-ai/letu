using Volo.Abp.Users;

namespace Letu.Basis.Admin.Users;

public static class LetuCurrentUserExtensions
{
    public static Guid? GetOrganizationUnitId(this ICurrentUser currentUser)
    {
        var value = currentUser.FindClaimValue("OrganizationUnitId");
        return Guid.TryParse(value, out var guid) ? guid : null;
    }

    public static Guid? GetDepartmentId(this ICurrentUser currentUser)
    {
        var value = currentUser.FindClaimValue("DepartmentId");
        return Guid.TryParse(value, out var guid) ? guid : null;
    }
}
