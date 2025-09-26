//using Letu.Basis.Amaps;
//using Letu.Basis.Permissions;
//using Letu.Basis.Settings;
//using Microsoft.AspNetCore.Authorization;
//using Volo.Abp.Features;
//using Volo.Abp.SettingManagement;

//namespace Letu.Basis.Admin.SettingManagement;

//[Authorize(BasisPermissions.Settin)]
//public class AmapSettingsAppService : BasisAppService, IAmapSettingsAppService
//{
//    private readonly ISettingManager settingManager;

//    public AmapSettingsAppService(ISettingManager settingManager)
//    {
//        this.settingManager = settingManager;
//    }

//    public virtual async Task<AmapSettings> GetAsync()
//    {
//        await CheckFeatureAsync();

//        return new AmapSettings
//        {
//            ApiKey = await SettingProvider.GetOrNullAsync(AmapSettingNames.ApiKey),
//            SecurityJsCode = await SettingProvider.GetOrNullAsync(AmapSettingNames.SecurityJsCode),
//        };
//    }

//    public virtual async Task UpdateAsync(AmapSettings input)
//    {
//        await CheckFeatureAsync();

//        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, AmapSettingNames.ApiKey, input.ApiKey);
//        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, AmapSettingNames.SecurityJsCode, input.SecurityJsCode);
//    }

//    protected virtual async Task CheckFeatureAsync()
//    {
//        await FeatureChecker.CheckEnabledAsync(SettingManagementFeatures.Enable);
//    }
//}
