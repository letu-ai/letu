using Volo.Abp.Settings;

namespace Letu.Basis.Settings;

public class AccountSettingDefinitionProvider : SettingDefinitionProvider
{
    public override void Define(ISettingDefinitionContext context)
    {
        context.Add(
            new SettingDefinition(
                AccountSettingNames.IsSelfRegistrationEnabled,
                "true",
                isVisibleToClients: true)
        );

        context.Add(
            new SettingDefinition(
                AccountSettingNames.EnableLocalLogin,
                "true",
                isVisibleToClients: true)
        );

        context.Add(
            new SettingDefinition(
                AccountSettingNames.AllowPasswordRecovery,
                "false",
                isVisibleToClients: true)
        );

        context.Add(
            new SettingDefinition(
                AccountSettingNames.EnableMobileVerificationCodeLogin,
                "false",
                isVisibleToClients: true)
        );

        context.Add(
            new SettingDefinition(
                AccountSettingNames.EnableEmailVerificationCodeLogin,
                "false",
                isVisibleToClients: true)
        );

        context.Add(
            new SettingDefinition(
                AccountSettingNames.EnableMobileVerificationCodeRegistration,
                "false",
                isVisibleToClients: true)
        );

        context.Add(
            new SettingDefinition(
                AccountSettingNames.EnableEmailVerificationCodeRegistration,
                "false",
                isVisibleToClients: true)
        );
    }
}
