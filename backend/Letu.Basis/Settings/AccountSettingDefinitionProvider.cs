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
                AccountSettingNames.EnableUserNameRegistration,
                "true",
                isVisibleToClients: true)
        );

        context.Add(
            new SettingDefinition(
                AccountSettingNames.EnableEmailRegistration,
                "true",
                isVisibleToClients: true)
        );

        context.Add(
            new SettingDefinition(
                AccountSettingNames.EnablePhoneNumberRegistration,
                "true",
                isVisibleToClients: true)
        );

        context.Add(
            new SettingDefinition(
                AccountSettingNames.EnableUserNameLogin,
                "true",
                isVisibleToClients: true)
        );

        context.Add(
            new SettingDefinition(
                AccountSettingNames.EnableEmailLogin,
                "true",
                isVisibleToClients: true)
        );

        context.Add(
            new SettingDefinition(
                AccountSettingNames.EnablePhoneNumberLogin,
                "true",
                isVisibleToClients: true)
        );

        context.Add(
            new SettingDefinition(
                AccountSettingNames.AllowPasswordRecovery,
                "true",
                isVisibleToClients: true)
        );
    }
}
