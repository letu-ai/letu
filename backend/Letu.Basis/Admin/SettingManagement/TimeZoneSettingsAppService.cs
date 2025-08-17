using Letu.Basis.Permissions;
using Microsoft.AspNetCore.Authorization;
using Volo.Abp;
using Volo.Abp.MultiTenancy;
using Volo.Abp.SettingManagement;
using Volo.Abp.Timing;

namespace Letu.Basis.Admin.SettingManagement;

[Authorize(BasisPermissions.Setting.TimeZone)]
public class TimeZoneSettingsAppService : BasisAppService, ITimeZoneSettingsAppService
{
    protected ISettingManager SettingManager { get; }
    protected ITimezoneProvider TimezoneProvider { get; }

    private const string UnspecifiedTimeZone = "Unspecified";

    public TimeZoneSettingsAppService(ISettingManager settingManager, ITimezoneProvider timezoneProvider)
    {
        SettingManager = settingManager;
        TimezoneProvider = timezoneProvider;
    }

    public virtual async Task<string> GetAsync()
    {
        var timezone = CurrentTenant.GetMultiTenancySide() == MultiTenancySides.Host
            ? await SettingManager.GetOrNullGlobalAsync(TimingSettingNames.TimeZone)
            : await SettingManager.GetOrNullForCurrentTenantAsync(TimingSettingNames.TimeZone);

        if (timezone.IsNullOrWhiteSpace())
        {
            timezone = UnspecifiedTimeZone;
        }

        return timezone;
    }

    public virtual Task<List<NameValue>> GetTimezonesAsync()
    {
        var timezones = TimeZoneHelper.GetTimezones(TimezoneProvider.GetIanaTimezones());
        timezones.Insert(0, new NameValue
        {
            Name = L["DefaultTimeZone"],
            Value = UnspecifiedTimeZone
        });
        return Task.FromResult(timezones);
    }

    public virtual async Task UpdateAsync(string? timezone)
    {
        if (UnspecifiedTimeZone.Equals(timezone, StringComparison.OrdinalIgnoreCase))
        {
            timezone = null;
        }

        if (CurrentTenant.GetMultiTenancySide() == MultiTenancySides.Host)
        {
            await SettingManager.SetGlobalAsync(TimingSettingNames.TimeZone, timezone);
        }
        else
        {
            await SettingManager.SetForCurrentTenantAsync(TimingSettingNames.TimeZone, timezone);
        }
    }
}
