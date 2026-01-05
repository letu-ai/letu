using Volo.Abp.Modularity;

namespace Letu.AI;

[DependsOn(
)]
public class LetuAIAbstractionsModule : AbpModule
{
    public override void ConfigureServices(ServiceConfigurationContext context)
    {
        var services = context.Services;
        var configuration = context.Configuration;
    }
}