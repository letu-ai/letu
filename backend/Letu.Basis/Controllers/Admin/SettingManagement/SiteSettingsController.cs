using Letu.Basis.Admin.SettingManagement;
using Letu.Basis.Admin.SettingManagement.Dtos;
using Letu.Basis.Permissions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin.SettingManagement;

[ApiController]
[Route("api/admin/setting-management/site")]
[Authorize(BasisPermissions.Setting.Default)]
public class SiteSettingsController : ControllerBase
{
    private readonly ISiteSettingsAppService siteSettingsAppService;

    public SiteSettingsController(ISiteSettingsAppService siteSettingsAppService)
    {
        this.siteSettingsAppService = siteSettingsAppService;
    }

    [HttpGet]
    public Task<SiteSettingsDto> GetAsync()
    {
        return siteSettingsAppService.GetAsync();
    }

    [HttpPost]
    public Task UpdateAsync(SiteSettingsDto input)
    {
        return siteSettingsAppService.UpdateAsync(input);
    }
}

