using Letu.Basis.Admin.FeatureManagement;
using Letu.Basis.Admin.FeatureManagement.Dtos;
using Letu.Basis.Permissions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin;

[ApiController]
[Route("api/admin/feature-management/features")]
[Authorize(BasisPermissions.Feature.Default)]
public class FeatureManagementController : ControllerBase
{
    protected IFeatureAppService FeatureAppService { get; }

    public FeatureManagementController(IFeatureAppService featureAppService)
    {
        FeatureAppService = featureAppService;
    }

    [HttpGet]
    public virtual Task<GetFeatureListResultDto> GetAsync(string providerName, string? providerKey)
    {
        return FeatureAppService.GetAsync(providerName, providerKey);
    }

    [HttpPut]
    public virtual Task UpdateAsync(string providerName, string? providerKey, UpdateFeaturesDto input)
    {
        return FeatureAppService.UpdateAsync(providerName, providerKey, input);
    }

    [HttpDelete]
    public virtual Task DeleteAsync(string providerName, string? providerKey)
    {
        return FeatureAppService.DeleteAsync(providerName, providerKey);
    }
}
