using Volo.Abp.Settings;

namespace Letu.Basis.Settings;

public class AmapSettingDefinitionProvider : SettingDefinitionProvider
{
    public override void Define(ISettingDefinitionContext context)
    {
        context.Add(
            new SettingDefinition(
                AmapSettingNames.ApiKey,
                isVisibleToClients: false,
                isEncrypted: true)
        );
    }
}
