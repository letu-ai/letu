using Letu.Basis.Admin.Menus;
using Letu.Basis.Admin.Menus.Dtos;
using Letu.Basis.Application.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.Options;
using Volo.Abp.AspNetCore.Mvc.ApplicationConfigurations;
using Volo.Abp.AspNetCore.Mvc.ApplicationConfigurations.ObjectExtending;
using Volo.Abp.Authorization;
using Volo.Abp.Authorization.Permissions;
using Volo.Abp.Features;
using Volo.Abp.Localization;
using Volo.Abp.MultiTenancy;
using Volo.Abp.Settings;
using Volo.Abp.Timing;
using Volo.Abp.Users;

namespace Letu.Basis.Application;

public class LetuApplicationConfigurationAppService : AbpApplicationConfigurationAppService, ILetuApplicationConfigurationAppService
{
    private readonly IMenuItemAppService menuItemAppService;

    public LetuApplicationConfigurationAppService(
        IOptions<AbpLocalizationOptions> localizationOptions,
        IOptions<AbpMultiTenancyOptions> multiTenancyOptions,
        IServiceProvider serviceProvider,
        IAbpAuthorizationPolicyProvider abpAuthorizationPolicyProvider,
        IPermissionDefinitionManager permissionDefinitionManager,
        DefaultAuthorizationPolicyProvider defaultAuthorizationPolicyProvider,
        IPermissionChecker permissionChecker,
        IAuthorizationService authorizationService,
        ICurrentUser currentUser,
        ISettingProvider settingProvider,
        ISettingDefinitionManager settingDefinitionManager,
        IFeatureDefinitionManager featureDefinitionManager,
        ILanguageProvider languageProvider,
        ITimezoneProvider timezoneProvider,
        IOptions<AbpClockOptions> abpClockOptions,
        ICachedObjectExtensionsDtoService cachedObjectExtensionsDtoService,
        IOptions<AbpApplicationConfigurationOptions> options,
        IMenuItemAppService menuItemAppService)
        : base(
            localizationOptions,
            multiTenancyOptions,
            serviceProvider,
            abpAuthorizationPolicyProvider,
            permissionDefinitionManager,
            defaultAuthorizationPolicyProvider,
            permissionChecker,
            authorizationService,
            currentUser,
            settingProvider,
            settingDefinitionManager,
            featureDefinitionManager,
            languageProvider,
            timezoneProvider,
            abpClockOptions,
            cachedObjectExtensionsDtoService,
            options
        )
    {
        this.menuItemAppService = menuItemAppService;
    }

    public async Task<LetuApplicationConfigurationDto> GetAsync(LetuApplicationConfigurationRequestOptions options)
    {
        var abpConfig = await base.GetAsync(options);
        var menu = options.ApplicationName == null ? [] : await GetNavigationMenusAsync(options.ApplicationName);

        var result = new LetuApplicationConfigurationDto
        {
            Auth = abpConfig.Auth,
            Features = abpConfig.Features,
            GlobalFeatures = abpConfig.GlobalFeatures,
            Localization = abpConfig.Localization,
            CurrentUser = abpConfig.CurrentUser,
            Setting = abpConfig.Setting,
            MultiTenancy = abpConfig.MultiTenancy,
            CurrentTenant = abpConfig.CurrentTenant,
            Timing = abpConfig.Timing,
            Clock = abpConfig.Clock,
            ObjectExtensions = abpConfig.ObjectExtensions,
            ExtraProperties = abpConfig.ExtraProperties,
            Menu = menu,
        };

        return result;
    }

    private async Task<List<NavigationMenuDto>> GetNavigationMenusAsync(string applicationName)
    {
        if (CurrentUser.IsAuthenticated == false)
            return [];

        var menu = await menuItemAppService.GetNavigationMenuAsync(applicationName);
        return menu;
    }
}
