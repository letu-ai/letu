using Letu.Basis.Admin.SettingManagement;
using Letu.Basis.Admin.SettingManagement.Dtos;
using Letu.Basis.Permissions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin.SettingManagement;

[ApiController]
[Route("api/admin/setting-management/account")]
[Authorize(BasisPermissions.Setting.Default)]
public class AccountSettingsController : ControllerBase
{
    private readonly IAccountSettingsAppService accountSettingsAppService;

    public AccountSettingsController(IAccountSettingsAppService accountSettingsAppService)
    {
        this.accountSettingsAppService = accountSettingsAppService;
    }

    [HttpGet]
    public Task<AccountSettingsDto> GetAsync()
    {
        return accountSettingsAppService.GetAsync();
    }

    [HttpPost]
    public Task UpdateAsync(AccountSettingsDto input)
    {
        return accountSettingsAppService.UpdateAsync(input);
    }
}
