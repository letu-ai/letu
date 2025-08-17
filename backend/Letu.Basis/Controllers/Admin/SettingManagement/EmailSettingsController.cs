using Letu.Basis.Admin.SettingManagement;
using Letu.Basis.Admin.SettingManagement.Dtos;
using Letu.Basis.Permissions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Admin.SettingManagement;

[ApiController]
[Route("api/admin/setting-management/emailing")]
[Authorize(BasisPermissions.Setting.Emailing)]
public class EmailSettingsController : ControllerBase
{
    private readonly IEmailSettingsAppService _emailSettingsAppService;

    public EmailSettingsController(IEmailSettingsAppService emailSettingsAppService)
    {
        _emailSettingsAppService = emailSettingsAppService;
    }

    [HttpGet]
    public Task<EmailSettingsDto> GetAsync()
    {
        return _emailSettingsAppService.GetAsync();
    }

    [HttpPost]
    public Task UpdateAsync(UpdateEmailSettingsDto input)
    {
        return _emailSettingsAppService.UpdateAsync(input);
    }

    [HttpPost("send-test-email")]
    [Authorize(BasisPermissions.Setting.EmailingTest)]
    public Task SendTestEmailAsync(SendTestEmailInput input)
    {
        return _emailSettingsAppService.SendTestEmailAsync(input);
    }
}
