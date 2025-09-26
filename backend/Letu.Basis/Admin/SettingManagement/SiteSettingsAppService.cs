using Letu.Basis.Admin.SettingManagement.Dtos;
using Letu.Basis.Permissions;
using Letu.Basis.Settings;
using Microsoft.AspNetCore.Authorization;
using Volo.Abp.SettingManagement;

namespace Letu.Basis.Admin.SettingManagement;

[Authorize(BasisPermissions.Setting.Site)]
public class SiteSettingsAppService : BasisAppService, ISiteSettingsAppService
{
    private readonly ISettingManager settingManager;

    public SiteSettingsAppService(ISettingManager settingManager)
    {
        this.settingManager = settingManager;
    }

    public virtual async Task<SiteSettingsDto> GetAsync()
    {
        return new SiteSettingsDto
        {
            SiteUrl = await SettingProvider.GetOrNullAsync(ApplicationSettingNames.Site.SiteUrl),
            Title = await SettingProvider.GetOrNullAsync(ApplicationSettingNames.Site.Title),
            Favicon = await SettingProvider.GetOrNullAsync(ApplicationSettingNames.Site.Favicon),
            Logo = await SettingProvider.GetOrNullAsync(ApplicationSettingNames.Site.Logo),
            LogoText = await SettingProvider.GetOrNullAsync(ApplicationSettingNames.Site.LogoText),
            Copyright = await SettingProvider.GetOrNullAsync(ApplicationSettingNames.Site.Copyright),
            Icp = await SettingProvider.GetOrNullAsync(ApplicationSettingNames.Site.Icp) ,
            Description = await SettingProvider.GetOrNullAsync(ApplicationSettingNames.Site.Description) ,
            Keywords = await SettingProvider.GetOrNullAsync(ApplicationSettingNames.Site.Keywords),
            PrimaryColor = await SettingProvider.GetOrNullAsync(ApplicationSettingNames.Site.PrimaryColor),
        };
    }

    public virtual async Task UpdateAsync(SiteSettingsDto input)
    {
        var siteUrl = input.SiteUrl?.RemovePostFix("/");

        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, ApplicationSettingNames.Site.SiteUrl, siteUrl);
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, ApplicationSettingNames.Site.Title, input.Title);
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, ApplicationSettingNames.Site.Favicon, input.Favicon);
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, ApplicationSettingNames.Site.Logo, input.Logo);
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, ApplicationSettingNames.Site.LogoText, input.LogoText);
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, ApplicationSettingNames.Site.Copyright, input.Copyright);
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, ApplicationSettingNames.Site.Icp, input.Icp);
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, ApplicationSettingNames.Site.Description, input.Description);
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, ApplicationSettingNames.Site.Keywords, input.Keywords);
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, ApplicationSettingNames.Site.PrimaryColor, input.PrimaryColor);
    }
}

