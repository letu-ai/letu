using Letu.Basis.Admin.PermissionManagement;
using Letu.Basis.Admin.PermissionManagement.Dtos;
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
    public virtual Task<GetPermissionListResultDto> GetAsync(string providerName, string providerKey)
    {
        return permissionAppService.GetAsync(providerName, providerKey);
    }

    [HttpPut]
    public virtual Task UpdateAsync(string providerName, string providerKey, UpdatePermissionsDto input)
    {
        return permissionAppService.UpdateAsync(providerName, providerKey, input);
    }
}
