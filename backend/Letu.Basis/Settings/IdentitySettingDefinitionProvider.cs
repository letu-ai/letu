using Volo.Abp.Localization;
using Volo.Abp.Settings;
using Letu.Basis.Localization;

namespace Letu.Basis.Settings;

public class IdentitySettingDefinitionProvider : SettingDefinitionProvider
{
    public override void Define(ISettingDefinitionContext context)
    {
        context.Add(
            new SettingDefinition(
                IdentitySettingNames.Password.RequiredLength,
                6.ToString(),
                isVisibleToClients: true),

            new SettingDefinition(
                IdentitySettingNames.Password.RequiredUniqueChars,
                1.ToString(),
                isVisibleToClients: true),

            new SettingDefinition(
                IdentitySettingNames.Password.RequireNonAlphanumeric,
                true.ToString(),
                isVisibleToClients: true),

            new SettingDefinition(
                IdentitySettingNames.Password.RequireLowercase,
                true.ToString(),
                isVisibleToClients: true),

            new SettingDefinition(
                IdentitySettingNames.Password.RequireUppercase,
                true.ToString(),
                isVisibleToClients: true),

            new SettingDefinition(
                IdentitySettingNames.Password.RequireDigit,
                true.ToString(),
                isVisibleToClients: true),

            new SettingDefinition(
                IdentitySettingNames.Password.ForceUsersToPeriodicallyChangePassword,
                false.ToString()),

            new SettingDefinition(
                IdentitySettingNames.Password.PasswordChangePeriodDays,
                0.ToString()),

            new SettingDefinition(
                IdentitySettingNames.Lockout.AllowedForNewUsers,
                true.ToString()),

            new SettingDefinition(
                IdentitySettingNames.Lockout.LockoutDuration,
                (5 * 60).ToString()),

            new SettingDefinition(
                IdentitySettingNames.Lockout.MaxFailedAccessAttempts,
                5.ToString()),

            new SettingDefinition(
                IdentitySettingNames.SignIn.RequireConfirmedEmail,
                false.ToString()),

            new SettingDefinition(
                IdentitySettingNames.SignIn.EnablePhoneNumberConfirmation,
                true.ToString()),

            new SettingDefinition(
                IdentitySettingNames.SignIn.RequireEmailVerificationToRegister,
                false.ToString()),

            new SettingDefinition(
                IdentitySettingNames.SignIn.RequireConfirmedPhoneNumber,
                false.ToString()),

            new SettingDefinition(
                IdentitySettingNames.SignIn.AllowMultipleLogin,
                true.ToString()),

            new SettingDefinition(
                IdentitySettingNames.User.IsUserNameUpdateEnabled,
                true.ToString()),

            new SettingDefinition(
                IdentitySettingNames.User.IsEmailUpdateEnabled,
                true.ToString()),

            new SettingDefinition(
                IdentitySettingNames.OrganizationUnit.MaxUserMembershipCount,
                int.MaxValue.ToString())
        );
    }
}
