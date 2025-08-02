using FreeSql;
using Microsoft.Extensions.DependencyInjection;
using Volo.Abp;
using Volo.Abp.Modularity;

namespace Letu.Repository;

[DependsOn()]
public class LetuRepositoryModule : AbpModule
{
    public override void ConfigureServices(ServiceConfigurationContext context)
    {
        // 注册FreeSql实体配置
        context.Services.AddScoped(r => r.GetRequiredService<UnitOfWorkManager>().Orm);
        context.Services.AddScoped(r => new UnitOfWorkManager(FreeSqlFactory.Create(r)));
        context.Services.AddTransient(typeof(IFreeSqlRepository<>), typeof(FreeSqlRepository<>));
    }

    public override void OnApplicationInitialization(ApplicationInitializationContext context)
    {
        AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);
        AppContext.SetSwitch("Npgsql.DisableDateTimeInfinityConversions", true);
    }
}