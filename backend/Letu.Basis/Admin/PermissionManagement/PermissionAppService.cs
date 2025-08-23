using Letu.Basis.Admin.PermissionManagement.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.Options;
using Volo.Abp;
using Volo.Abp.Authorization.Permissions;
using Volo.Abp.Localization;
using Volo.Abp.MultiTenancy;
using Volo.Abp.PermissionManagement;
using Volo.Abp.SimpleStateChecking;

namespace Letu.Basis.Admin.PermissionManagement;

[Authorize]
public class PermissionAppService : BasisAppService, IPermissionAppService
{
    private readonly PermissionManagementOptions options;
    private readonly IPermissionManager permissionManager;
    private readonly IPermissionDefinitionManager permissionDefinitionManager;
    private readonly ISimpleStateCheckerManager<PermissionDefinition> simpleStateCheckerManager;

    public PermissionAppService(
        IPermissionManager permissionManager,
        IPermissionDefinitionManager permissionDefinitionManager,
        IOptions<PermissionManagementOptions> options,
        ISimpleStateCheckerManager<PermissionDefinition> simpleStateCheckerManager)
    {
        this.options = options.Value;
        this.permissionManager = permissionManager;
        this.permissionDefinitionManager = permissionDefinitionManager;
        this.simpleStateCheckerManager = simpleStateCheckerManager;
    }

    public async Task<List<PermissionDefinitionDto>> GetPermissionDefinitionsAsync()
    {
        var groups = await permissionDefinitionManager.GetGroupsAsync();
        return groups.Select(x => new PermissionDefinitionDto(x.Name, x.DisplayName?.Localize(StringLocalizerFactory) ?? x.Name)
        {
            IsGroup = true,
            Permissions = x.Permissions.Select(x => new PermissionDefinitionDto(x.Name, x.DisplayName?.Localize(StringLocalizerFactory) ?? x.Name)
            {
                Permissions = x.Children.Select(x => new PermissionDefinitionDto(x.Name, x.DisplayName?.Localize(StringLocalizerFactory) ?? x.Name)).ToList()
            }).ToList()
        })
        .ToList();
    }

    public async Task<GetPermissionListResultDto> GetAsync(string providerName, string providerKey)
    {
        await CheckProviderPolicy(providerName);

        var result = new GetPermissionListResultDto
        {
            EntityDisplayName = providerKey,
            Groups = new List<PermissionGroupDto>()
        };

        var multiTenancySide = CurrentTenant.GetMultiTenancySide();
        var permissionGroups = new List<PermissionGroupDto>();

        foreach (var group in await permissionDefinitionManager.GetGroupsAsync())
        {
            var groupDto = CreatePermissionGroupDto(group);
            var permissions = group.GetPermissionsWithChildren()
                .Where(x => x.IsEnabled)
                .Where(x => !x.Providers.Any() || x.Providers.Contains(providerName))
                .Where(x => x.MultiTenancySide.HasFlag(multiTenancySide));

            var neededCheckPermissions = new List<PermissionDefinition>();
            foreach (var permission in permissions)
            {
                if (permission.Parent != null && !neededCheckPermissions.Contains(permission.Parent))
                {
                    continue;
                }

                if (await simpleStateCheckerManager.IsEnabledAsync(permission))
                {
                    neededCheckPermissions.Add(permission);
                }
            }

            if (!neededCheckPermissions.Any())
            {
                continue;
            }

            groupDto.Permissions.AddRange(neededCheckPermissions.Select(CreatePermissionGrantInfoDto));
            permissionGroups.Add(groupDto);
        }

        var multipleGrantInfo = await permissionManager.GetAsync(
            permissionGroups.SelectMany(group => group.Permissions).Select(permission => permission.Name).ToArray(),
            providerName,
            providerKey);

        foreach (var permissionGroup in permissionGroups)
        {
            foreach (var permission in permissionGroup.Permissions)
            {
                var grantInfo = multipleGrantInfo.Result.FirstOrDefault(x => x.Name == permission.Name);
                if (grantInfo == null)
                {
                    continue;
                }

                permission.IsGranted = grantInfo.IsGranted;
                permission.GrantedProviders = grantInfo.Providers.Select(x => new ProviderInfoDto
                {
                    ProviderName = x.Name,
                    ProviderKey = x.Key,
                }).ToList();
            }

            if (permissionGroup.Permissions.Any())
            {
                result.Groups.Add(permissionGroup);
            }
        }

        return result;
    }

    private PermissionGrantInfoDto CreatePermissionGrantInfoDto(PermissionDefinition permission)
    {
        return new PermissionGrantInfoDto
        {
            Name = permission.Name,
            DisplayName = permission.DisplayName?.Localize(StringLocalizerFactory) ?? permission.Name,
            ParentName = permission.Parent?.Name,
            AllowedProviders = permission.Providers,
            GrantedProviders = new List<ProviderInfoDto>()
        };
    }

    private PermissionGroupDto CreatePermissionGroupDto(PermissionGroupDefinition group)
    {
        var localizableDisplayName = group.DisplayName as LocalizableString;

        return new PermissionGroupDto
        {
            Name = group.Name,
            DisplayName = group.DisplayName?.Localize(StringLocalizerFactory) ?? group.Name,
            Permissions = new List<PermissionGrantInfoDto>()
        };
    }

    public async Task UpdateAsync(string providerName, string providerKey, UpdatePermissionsDto input)
    {
        await CheckProviderPolicy(providerName);

        foreach (var permissionDto in input.Permissions)
        {
            await permissionManager.SetAsync(permissionDto.Name, providerName, providerKey, permissionDto.IsGranted);
        }
    }

    private async Task CheckProviderPolicy(string providerName)
    {
        var policyName = options.ProviderPolicies.GetOrDefault(providerName);
        if (policyName.IsNullOrEmpty())
        {
            throw new AbpException($"No policy defined to get/set permissions for the provider '{providerName}'. Use {nameof(PermissionManagementOptions)} to map the policy.");
        }

        await AuthorizationService.CheckAsync(policyName);
    }
}
