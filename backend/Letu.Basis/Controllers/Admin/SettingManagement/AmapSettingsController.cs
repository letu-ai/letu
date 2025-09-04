using Letu.Basis.Admin.SettingManagement;
using Letu.Basis.Admin.SettingManagement.Dtos;
using Letu.Basis.Permissions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin.SettingManagement;

[ApiController]
[Route("api/admin/setting-management/amap")]
[Authorize(BasisPermissions.Setting.Amap)]
public class AmapSettingsController : ControllerBase
{
    private readonly IAmapSettingsAppService amapSettingsAppService;

    public AmapSettingsController(IAmapSettingsAppService amapSettingsAppService)
    {
        this.amapSettingsAppService = amapSettingsAppService;
    }

    [HttpGet]
    public Task<AmapSettingsDto> GetAsync()
    {
        return amapSettingsAppService.GetAsync();
    }

    [HttpPost]
    public Task UpdateAsync([FromBody] AmapSettingsDto input)
    {
        return amapSettingsAppService.UpdateAsync(input);
    }
}
