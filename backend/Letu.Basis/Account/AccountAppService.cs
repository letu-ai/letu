using Letu.Basis.Account.Dtos;
using Letu.Basis.Settings;
using Microsoft.Extensions.Options;
using Volo.Abp.AspNetCore.MultiTenancy;
using Volo.Abp.MultiTenancy;
using Volo.Abp.Settings;

namespace Letu.Basis.Account;

public class AccountAppService : BasisAppService, IAccountAppService
{
    private readonly ITenantStore tenantStore;
    private readonly AbpMultiTenancyOptions abpTenantOptions;
    private readonly AbpAspNetCoreMultiTenancyOptions aspnetCoreTenantOptions;

    public AccountAppService(
        ITenantStore tenantStore,
        IOptions<AbpMultiTenancyOptions> abpTenantOptions,
        IOptions<AbpAspNetCoreMultiTenancyOptions> aspnetCoreTenantOptions
    )
    {
        this.tenantStore = tenantStore;
        this.abpTenantOptions = abpTenantOptions.Value;
        this.aspnetCoreTenantOptions = aspnetCoreTenantOptions.Value;
    }

    public async Task<LoginSettingsOutput> GetLoginSettingsAsync()
    {
        var signInSettings = new LoginSettingsOutput();
        if (CurrentTenant.IsAvailable)
        {
            var tenant = await tenantStore.FindAsync(CurrentTenant.GetId());
            signInSettings.TenantName = tenant?.Name;
        }
        signInSettings.MultiTenancyEnabled = abpTenantOptions.IsEnabled;
        signInSettings.ExternalProviders = await GetExternalProviders();
        signInSettings.EnableUserNameLogin = await SettingProvider.IsTrueAsync(AccountSettingNames.EnableUserNameLogin);
        signInSettings.EnableEmailLogin = await SettingProvider.IsTrueAsync(AccountSettingNames.EnableEmailLogin);
        signInSettings.EnablePhoneNumberLogin = await SettingProvider.IsTrueAsync(AccountSettingNames.EnablePhoneNumberLogin);
        signInSettings.AllowPasswordRecovery = await SettingProvider.IsTrueAsync(AccountSettingNames.AllowPasswordRecovery);
        signInSettings.IsSelfRegistrationEnabled = await SettingProvider.IsTrueAsync(AccountSettingNames.IsSelfRegistrationEnabled);
        signInSettings.EnableUserNameRegistration = await SettingProvider.IsTrueAsync(AccountSettingNames.EnableUserNameRegistration);
        signInSettings.EnableEmailRegistration = await SettingProvider.IsTrueAsync(AccountSettingNames.EnableEmailRegistration);
        signInSettings.EnablePhoneNumberRegistration = await SettingProvider.IsTrueAsync(AccountSettingNames.EnablePhoneNumberRegistration);

        return signInSettings;
    }

    public async Task<SwitchTenantOutput> SwitchTenantAsync(string? tenantName)
    {
        SwitchTenantOutput output = new()
        {
            CookieKey = aspnetCoreTenantOptions.TenantKey
        };

        if (!tenantName.IsNullOrEmpty())
        {
            var tenant = await tenantStore.FindAsync(tenantName!);
            if (tenant != null && tenant.IsActive)
            {
                output.TenantId = tenant.Id;
                output.Success = true;
            }
        }
        else
        {
            output.Success = true;
            output.TenantId = null;
        }

        return output;
    }


    private Task<List<ExternalProviderOutput>> GetExternalProviders()
    {
        return Task.FromResult(new List<ExternalProviderOutput>());
    }
}