using Letu.Basis.Admin.SettingManagement;
using Letu.Basis.Amaps;
using Letu.Basis.Permissions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin.SettingManagement;

[ApiController]
[Route("api/admin/setting-management/amap")]
[Authorize(BasisPermissions.Integration.Amap)]
public class AmapSettingsController : ControllerBase
{
    private readonly IAmapSettingsAppService amapSettingsAppService;

    public AmapSettingsController(IAmapSettingsAppService amapSettingsAppService)
    {
        this.amapSettingsAppService = amapSettingsAppService;
    }

    [HttpGet]
    public Task<AmapSettings> GetAsync()
    {
        return amapSettingsAppService.GetAsync();
    }

    [HttpPost]
    public Task UpdateAsync([FromBody] AmapSettings input)
    {
        return amapSettingsAppService.UpdateAsync(input);
    }
}
