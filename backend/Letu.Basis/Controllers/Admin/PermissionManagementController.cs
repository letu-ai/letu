using Letu.Basis.Admin.PermissionManagement;
using Letu.Basis.Admin.PermissionManagement.Dtos;
using Letu.Core.Applications;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Volo.Abp.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin;

[Authorize]
[ApiController]
[Route("api/admin/permission-management/permissions")]
public class PermissionManagementController : AbpControllerBase
{
    private readonly IPermissionAppService permissionAppService;

    public PermissionManagementController(IPermissionAppService permissionAppService)
    {
        this.permissionAppService = permissionAppService;
    }

    [HttpGet]
    public Task<GetPermissionListResultDto> GetAsync(string providerName, string providerKey)
    {
        return permissionAppService.GetAsync(providerName, providerKey);
    }

    [HttpPut]
    public Task UpdateAsync(string providerName, string providerKey, UpdatePermissionsDto input)
    {
        return permissionAppService.UpdateAsync(providerName, providerKey, input);
    }

    [HttpGet("tree-options")]
    public async Task<List<TreeSelectOption>> GetPermissionDefinitionsAsync()
    {
        var permissionDefinitions = await permissionAppService.GetPermissionDefinitionsAsync();
        return Convert(permissionDefinitions);
    }

    private static List<TreeSelectOption> Convert(List<PermissionDefinitionDto> definitions)
    {
        var options = new List<TreeSelectOption>();
        foreach (var definition in definitions)
        {
            var option = new TreeSelectOption()
            {
                Key = definition.Name,
                Value = definition.Name,
                Title = definition.DisplayName,
                Children = definition.Permissions.Select(x => new TreeSelectOption()
                {
                    Key = x.Name,
                    Value = x.Name,
                    Title = x.DisplayName,
                }).ToList()
            };
            options.Add(option);
        }

        return options;
    }
}

