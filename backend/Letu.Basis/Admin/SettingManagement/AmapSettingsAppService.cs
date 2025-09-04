using Letu.Basis.Admin.SettingManagement.Dtos;
using Letu.Basis.Permissions;
using Letu.Basis.Settings;
using Microsoft.AspNetCore.Authorization;
using Volo.Abp.Features;
using Volo.Abp.SettingManagement;

namespace Letu.Basis.Admin.SettingManagement;

[Authorize(BasisPermissions.Setting.Amap)]
public class AmapSettingsAppService : BasisAppService, IAmapSettingsAppService
{
    private readonly ISettingManager settingManager;

    public AmapSettingsAppService(ISettingManager settingManager)
    {
        this.settingManager = settingManager;
    }

    public virtual async Task<AmapSettingsDto> GetAsync()
    {
        await CheckFeatureAsync();

        return new AmapSettingsDto
        {
            ApiKey = await SettingProvider.GetOrNullAsync(AmapSettingNames.ApiKey),
        };
    }

    public virtual async Task UpdateAsync(AmapSettingsDto input)
    {
        await CheckFeatureAsync();

        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, AmapSettingNames.ApiKey, input.ApiKey);
    }

    protected virtual async Task CheckFeatureAsync()
    {
        await FeatureChecker.CheckEnabledAsync(SettingManagementFeatures.Enable);
    }
}
