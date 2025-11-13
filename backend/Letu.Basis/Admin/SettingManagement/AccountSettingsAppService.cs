using Letu.Basis.Admin.SettingManagement.Dtos;
using Letu.Basis.Permissions;
using Letu.Basis.Settings;
using Microsoft.AspNetCore.Authorization;
using Volo.Abp.Features;
using Volo.Abp.SettingManagement;

namespace Letu.Basis.Admin.SettingManagement;

[Authorize(BasisPermissions.Setting.Default)]
public class AccountSettingsAppService : BasisAppService, IAccountSettingsAppService
{
    private ISettingManager settingManager;

    public AccountSettingsAppService(ISettingManager settingManager)
    {
        this.settingManager = settingManager;
    }

    public virtual async Task<AccountSettingsDto> GetAsync()
    {
        await CheckFeatureAsync();

        return new AccountSettingsDto
        {
            // Account
            IsSelfRegistrationEnabled = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(AccountSettingNames.IsSelfRegistrationEnabled)),
            EnableUserNameRegistration = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(AccountSettingNames.EnableUserNameRegistration)),
            EnableEmailRegistration = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(AccountSettingNames.EnableEmailRegistration)),
            EnablePhoneNumberRegistration = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(AccountSettingNames.EnablePhoneNumberRegistration)),
            EnableUserNameLogin = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(AccountSettingNames.EnableUserNameLogin)),
            EnableEmailLogin = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(AccountSettingNames.EnableEmailLogin)),
            EnablePhoneNumberLogin = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(AccountSettingNames.EnablePhoneNumberLogin)),
            AllowPasswordRecovery = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(AccountSettingNames.AllowPasswordRecovery)),

            // Password
            PasswordRequiredLength = Convert.ToInt32(await SettingProvider.GetOrNullAsync(IdentitySettingNames.Password.RequiredLength)),
            PasswordRequiredUniqueChars = Convert.ToInt32(await SettingProvider.GetOrNullAsync(IdentitySettingNames.Password.RequiredUniqueChars)),
            PasswordRequireNonAlphanumeric = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(IdentitySettingNames.Password.RequireNonAlphanumeric)),
            PasswordRequireLowercase = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(IdentitySettingNames.Password.RequireLowercase)),
            PasswordRequireUppercase = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(IdentitySettingNames.Password.RequireUppercase)),
            PasswordRequireDigit = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(IdentitySettingNames.Password.RequireDigit)),
            ForceUsersToPeriodicallyChangePassword = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(IdentitySettingNames.Password.ForceUsersToPeriodicallyChangePassword)),
            PasswordChangePeriodDays = Convert.ToInt32(await SettingProvider.GetOrNullAsync(IdentitySettingNames.Password.PasswordChangePeriodDays)),

            // Lockout
            AllowedForNewUsers = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(IdentitySettingNames.Lockout.AllowedForNewUsers)),
            LockoutDuration = Convert.ToInt32(await SettingProvider.GetOrNullAsync(IdentitySettingNames.Lockout.LockoutDuration)),
            MaxFailedAccessAttempts = Convert.ToInt32(await SettingProvider.GetOrNullAsync(IdentitySettingNames.Lockout.MaxFailedAccessAttempts)),

            // SignIn
            SignInRequireConfirmedEmail = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(IdentitySettingNames.SignIn.RequireConfirmedEmail)),
            SignInEnablePhoneNumberConfirmation = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(IdentitySettingNames.SignIn.EnablePhoneNumberConfirmation)),
            SignInRequireConfirmedPhoneNumber = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(IdentitySettingNames.SignIn.RequireConfirmedPhoneNumber)),
            SignInAllowMultipleLogin = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(IdentitySettingNames.SignIn.AllowMultipleLogin)),
            SignInRememberMeDurationDays = Convert.ToInt32(await SettingProvider.GetOrNullAsync(IdentitySettingNames.SignIn.RememberMeDurationDays)),
            
            // User
            IsUserNameUpdateEnabled = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(IdentitySettingNames.User.IsUserNameUpdateEnabled)),
            IsEmailUpdateEnabled = Convert.ToBoolean(await SettingProvider.GetOrNullAsync(IdentitySettingNames.User.IsEmailUpdateEnabled)),
        };
    }

    public virtual async Task UpdateAsync(AccountSettingsDto input)
    {
        await CheckFeatureAsync();

        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, AccountSettingNames.IsSelfRegistrationEnabled, input.IsSelfRegistrationEnabled.ToString());
        if (input.IsSelfRegistrationEnabled)
        {
            await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, AccountSettingNames.EnableUserNameRegistration, input.EnableUserNameRegistration.ToString());
            await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, AccountSettingNames.EnableEmailRegistration, input.EnableEmailRegistration.ToString());
            await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, AccountSettingNames.EnablePhoneNumberRegistration, input.EnablePhoneNumberRegistration.ToString());
        }
        else
        {
            await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, AccountSettingNames.EnableUserNameRegistration, false.ToString());
            await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, AccountSettingNames.EnableEmailRegistration, false.ToString());
            await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, AccountSettingNames.EnablePhoneNumberRegistration, false.ToString());
        }

        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, AccountSettingNames.EnableUserNameLogin, input.EnableUserNameLogin.ToString());
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, AccountSettingNames.EnableEmailLogin, input.EnableEmailLogin.ToString());
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, AccountSettingNames.EnablePhoneNumberLogin, input.EnablePhoneNumberLogin.ToString());
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, AccountSettingNames.AllowPasswordRecovery, input.AllowPasswordRecovery.ToString());

        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, IdentitySettingNames.Password.RequiredLength, input.PasswordRequiredLength.ToString());
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, IdentitySettingNames.Password.RequiredUniqueChars, input.PasswordRequiredUniqueChars.ToString());
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, IdentitySettingNames.Password.RequireNonAlphanumeric, input.PasswordRequireNonAlphanumeric.ToString());
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, IdentitySettingNames.Password.RequireLowercase, input.PasswordRequireLowercase.ToString());
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, IdentitySettingNames.Password.RequireUppercase, input.PasswordRequireUppercase.ToString());
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, IdentitySettingNames.Password.RequireDigit, input.PasswordRequireDigit.ToString());
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, IdentitySettingNames.Password.ForceUsersToPeriodicallyChangePassword, input.ForceUsersToPeriodicallyChangePassword.ToString());
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, IdentitySettingNames.Password.PasswordChangePeriodDays, input.PasswordChangePeriodDays.ToString());

        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, IdentitySettingNames.Lockout.AllowedForNewUsers, input.AllowedForNewUsers.ToString());
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, IdentitySettingNames.Lockout.LockoutDuration, input.LockoutDuration.ToString());
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, IdentitySettingNames.Lockout.MaxFailedAccessAttempts, input.MaxFailedAccessAttempts.ToString());

        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, IdentitySettingNames.SignIn.RequireConfirmedEmail, input.SignInRequireConfirmedEmail.ToString());
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, IdentitySettingNames.SignIn.EnablePhoneNumberConfirmation, input.SignInEnablePhoneNumberConfirmation.ToString());
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, IdentitySettingNames.SignIn.RequireConfirmedPhoneNumber, input.SignInRequireConfirmedPhoneNumber.ToString());
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, IdentitySettingNames.SignIn.AllowMultipleLogin, input.SignInAllowMultipleLogin.ToString());
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, IdentitySettingNames.SignIn.RememberMeDurationDays, input.SignInRememberMeDurationDays.ToString());

        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, IdentitySettingNames.User.IsUserNameUpdateEnabled, input.IsUserNameUpdateEnabled.ToString());
        await settingManager.SetForTenantOrGlobalAsync(CurrentTenant.Id, IdentitySettingNames.User.IsEmailUpdateEnabled, input.IsEmailUpdateEnabled.ToString());
    }

    protected virtual async Task CheckFeatureAsync()
    {
        await FeatureChecker.CheckEnabledAsync(SettingManagementFeatures.Enable);
    }
}
