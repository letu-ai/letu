using Letu.Repository;
using Volo.Abp.Authorization.Permissions;
using Volo.Abp.Data;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Guids;
using Volo.Abp.MultiTenancy;
using Volo.Abp.PermissionManagement;

namespace Letu.Basis.Admin.PermissionManagement;

public class PermissionDataSeedContributor : IDataSeedContributor, ITransientDependency
{
    protected ICurrentTenant CurrentTenant { get; }
    protected IPermissionDefinitionManager PermissionDefinitionManager { get; }
    private readonly IFreeSqlRepository<PermissionGrant> permissionGrantRepository;
    private readonly IGuidGenerator guidGenerator;

    public PermissionDataSeedContributor(
        IPermissionDefinitionManager permissionDefinitionManager,
        IFreeSqlRepository<PermissionGrant> permissionGrantRepository,
        IGuidGenerator guidGenerator,
        ICurrentTenant currentTenant)
    {
        PermissionDefinitionManager = permissionDefinitionManager;
        this.permissionGrantRepository = permissionGrantRepository;
        this.guidGenerator = guidGenerator;
        CurrentTenant = currentTenant;
    }

    public virtual async Task SeedAsync(DataSeedContext context)
    {
        var multiTenancySide = CurrentTenant.GetMultiTenancySide();
        var permissionNames = (await PermissionDefinitionManager.GetPermissionsAsync())
            .Where(p => p.MultiTenancySide.HasFlag(multiTenancySide))
            .Where(p => !p.Providers.Any() || p.Providers.Contains(RolePermissionValueProvider.ProviderName))
            .Select(p => p.Name)
            .ToArray();

        await SeedRolePermissionAsync(
            RolePermissionValueProvider.ProviderName,
            "admin",
            permissionNames,
            context?.TenantId
        );
    }

    private async Task SeedRolePermissionAsync(
        string providerName,
        string providerKey,
        IEnumerable<string> grantedPermissions,
        Guid? tenantId = null)
    {
        using (CurrentTenant.Change(tenantId))
        {
            var names = grantedPermissions.ToArray();
            var existsPermissionGrants = await permissionGrantRepository.Select
                .Where(x => x.Name.In(names) && x.ProviderName == providerName && x.ProviderKey == providerKey)
                .ToListAsync(x => x.Name);
            var permissions = names.Except(existsPermissionGrants)
                .Select(permissionName => new PermissionGrant(guidGenerator.Create(), permissionName, providerName, providerKey, tenantId));
            if (!permissions.Any())
            {
                return;
            }
            await permissionGrantRepository.InsertAsync(permissions);
        }
    }
}
