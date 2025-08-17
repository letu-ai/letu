using Letu.Basis.Admin.SettingManagement;
using Letu.Basis.Permissions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Volo.Abp;

namespace Letu.Basis.Controllers.Admin.SettingManagement;

[ApiController]
[Route("api/admin/setting-management/timezone")]
[Authorize(BasisPermissions.Setting.TimeZone)]
public class TimeZoneSettingsController : ControllerBase
{
    private readonly ITimeZoneSettingsAppService _timeZoneSettingsAppService;

    public TimeZoneSettingsController(ITimeZoneSettingsAppService timeZoneSettingsAppService)
    {
        _timeZoneSettingsAppService = timeZoneSettingsAppService;
    }

    [HttpGet]
    public Task<string> GetAsync()
    {
        return _timeZoneSettingsAppService.GetAsync();
    }

    [HttpGet]
    [Route("timezones")]
    public Task<List<NameValue>> GetTimezonesAsync()
    {
        return _timeZoneSettingsAppService.GetTimezonesAsync();
    }

    [HttpPost]
    public Task UpdateAsync([FromBody] string timezone)
    {
        return _timeZoneSettingsAppService.UpdateAsync(timezone);
    }
}
