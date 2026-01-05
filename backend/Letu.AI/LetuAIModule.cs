using Letu.AI.Localization;
using Letu.Basis;
using Letu.Repository;
using Microsoft.Extensions.DependencyInjection;
using Volo.Abp.AutoMapper;
using Volo.Abp.Localization;
using Volo.Abp.Modularity;
using Volo.Abp.VirtualFileSystem;

namespace Letu.AI;

[DependsOn(
    typeof(LetuBasisModule)
)]
public class LetuAIModule : AbpModule
{
    public override void ConfigureServices(ServiceConfigurationContext context)
    {
        var services = context.Services;
        var configuration = context.Configuration;

        ConfigureAutoMapper(services);
        ConfigureLocalization();
        ConfigureTenantTableOptions();

        // 注册服务
        services.AddHttpClient();

        services.AddControllers()
            .AddApplicationPart(typeof(LetuAIModule).Assembly); // 添加外部程序集

        PreConfigure<IMvcBuilder>(mvcBuilder =>
        {
            mvcBuilder.AddApplicationPartIfNotExists(GetType().Assembly);
        });
    }

    private void ConfigureAutoMapper(IServiceCollection services)
    {
        services.AddAutoMapperObjectMapper<LetuAIModule>();
        Configure<AbpAutoMapperOptions>(options =>
        {
            options.AddMaps<LetuAIModule>(validate: true);
        });
    }

    private void ConfigureLocalization()
    {
        Configure<AbpVirtualFileSystemOptions>(options =>
        {
            options.FileSets.AddEmbedded<LetuAIModule>();
        });

        Configure<AbpLocalizationOptions>(options =>
        {
            options.Resources
                .Add<AIResource>("zh-Hans")
                .AddVirtualJson("/Letu/AI/Localization/Resources");
        });
    }

    private void ConfigureTenantTableOptions()
    {
        Configure<TenantTableOptions>(options =>
        {
            options.AddAssembly(typeof(LetuAIModule).Assembly);
        });
    }
}