using Letu.Repository;
using System.Security.Claims;
using System.Security.Principal;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Security.Claims;
using Volo.Abp.Users;

namespace Letu.Basis.Admin.Users;

public class OrgnanzitionClaimsPrincipalContributor : IAbpClaimsPrincipalContributor, ITransientDependency
{
    public async Task ContributeAsync(AbpClaimsPrincipalContributorContext context)
    {
        var identity = context.ClaimsPrincipal.Identities.FirstOrDefault();
        var userId = identity?.FindUserId();
        if (userId.HasValue)
        {
            var userService = context.ServiceProvider.GetRequiredService<IFreeSqlRepository<User>>(); //Your custom service
            var user = await userService.OneAsync(x=>x.Id == userId);
            if(user == null)

                return;
            if (user.OrganizationUnitId != null)
            {
                identity.AddClaim(new Claim("OrganizationUnitId", user.OrganizationUnitId.ToString()));
            }
        }
    }
}


public static class CurrentUserExtensions
{
    public static string GetOrganizationUnitId(this ICurrentUser currentUser)
    {
        return currentUser.FindClaimValue("OrganizationUnitId");
    }
}
