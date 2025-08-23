using Letu.Basis.Admin.FeatureManagement;
using Letu.Basis.Admin.FeatureManagement.Dtos;
using Letu.Basis.Permissions;
using Letu.Core.Applications;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin;

[ApiController]
[Route("api/admin/feature-management/features")]
[Authorize(BasisPermissions.Feature.Default)]
public class FeatureManagementController : ControllerBase
{
    private readonly IFeatureAppService featureAppService;

    public FeatureManagementController(IFeatureAppService featureAppService)
    {
        this.featureAppService = featureAppService;
    }

    [HttpGet]
    public virtual Task<GetFeatureListResultDto> GetAsync(string providerName, string? providerKey)
    {
        return featureAppService.GetAsync(providerName, providerKey);
    }

    [HttpPut]
    public virtual Task UpdateAsync(string providerName, string? providerKey, UpdateFeaturesDto input)
    {
        return featureAppService.UpdateAsync(providerName, providerKey, input);
    }

    [HttpDelete]
    public virtual Task DeleteAsync(string providerName, string? providerKey)
    {
        return featureAppService.DeleteAsync(providerName, providerKey);
    }


    /// <summary>
    /// 字典选项
    /// </summary>
    /// <returns></returns>
    [HttpGet("select-options/{valueType?}")]
    public async Task<List<SelectOption>> GetFeatureOptionsAsync(string? valueType = null)
    {
        return await featureAppService.GetSelectOptionsAsync(valueType);
    }

}
