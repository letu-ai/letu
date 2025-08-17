using Letu.Basis.Permissions;
using Microsoft.AspNetCore.Authorization;
using Volo.Abp.Features;
using Volo.Abp.SettingManagement;
using Volo.Abp.Settings;

namespace Letu.Basis.Admin.SettingManagement;

[Authorize(BasisPermissions.Setting.Default)]
public class SettingManagementAppService : BasisAppService, ISettingManagementAppService
{
    private readonly ISettingManager settingManager;

    public SettingManagementAppService(ISettingManager settingManager)
    {
        this.settingManager = settingManager;
    }

    public virtual async Task<List<SettingValue>> GetAllAsync(string[] names)
    {
        await CheckFeatureAsync();
        return await SettingProvider.GetAllAsync(names);
    }

    public async Task UpdateAsync(List<SettingValue> values)
    {
        await CheckFeatureAsync();

        foreach (var value in values)
        {
            await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, value.Name, value.Value);
        }
    }

    protected virtual async Task CheckFeatureAsync()
    {
        await FeatureChecker.CheckEnabledAsync(SettingManagementFeatures.Enable);
        if (CurrentTenant.IsAvailable)
        {
            await FeatureChecker.CheckEnabledAsync(SettingManagementFeatures.AllowChangingEmailSettings);
        }
    }
}
