using Volo.Abp.Settings;

namespace Letu.Basis.Settings;

public class ApplicationSettingDefinitionProvider : SettingDefinitionProvider
{
    public override void Define(ISettingDefinitionContext context)
    {
        context.Add(
            new SettingDefinition(
                ApplicationSettingNames.Site.Title,
                "乐途",
                isVisibleToClients: true)
        );
        context.Add(
            new SettingDefinition(
                ApplicationSettingNames.Site.Favicon,
                "favicon.ico",
                isVisibleToClients: true)
        );
        
        context.Add(
            new SettingDefinition(
                ApplicationSettingNames.Site.Logo,
                "",
                isVisibleToClients: true)
        );
        
        context.Add(
            new SettingDefinition(
                ApplicationSettingNames.Site.LogoText,
                "乐途管理系统",
                isVisibleToClients: true)
        );
        
        context.Add(
            new SettingDefinition(
                ApplicationSettingNames.Site.Copyright,
                "Copyright © %YEAR% letu.run",
                isVisibleToClients: true)
        );
        
        context.Add(
            new SettingDefinition(
                ApplicationSettingNames.Site.PrimaryColor,
                "#000000",
                isVisibleToClients: true)
        );

        context.Add(
            new SettingDefinition(
                ApplicationSettingNames.Site.Icp,
                "",
                isVisibleToClients: true)
        );

        context.Add(
            new SettingDefinition(
                ApplicationSettingNames.Site.Description,
                "",
                isVisibleToClients: true)
        );

        context.Add(
            new SettingDefinition(
                ApplicationSettingNames.Site.Keywords,
                "",
                isVisibleToClients: true)
        );
        
    }
}

