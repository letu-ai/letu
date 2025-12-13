using Letu.Basis.Admin.Loggings;
using Letu.Basis.Admin.PermissionManagement.Identity;
using Letu.Basis.Filters;
using Letu.Basis.Localization;
using Letu.Basis.Permissions;
using Letu.Core.Helpers;
using Letu.Core.MultiTenancy;
using Letu.Logging;
using Letu.Repository;
using Microsoft.AspNetCore.Mvc;
using Volo.Abp;
using Volo.Abp.AspNetCore.MultiTenancy;
using Volo.Abp.AspNetCore.Mvc;
using Volo.Abp.AspNetCore.Serilog;
using Volo.Abp.Authorization;
using Volo.Abp.Authorization.Permissions;
using Volo.Abp.Autofac;
using Volo.Abp.AutoMapper;
using Volo.Abp.BackgroundWorkers;
using Volo.Abp.Data;
using Volo.Abp.DistributedLocking;
using Volo.Abp.Emailing;
using Volo.Abp.EventBus;
using Volo.Abp.FeatureManagement;
using Volo.Abp.FeatureManagement.Localization;
using Volo.Abp.Features;
using Volo.Abp.Localization;
using Volo.Abp.Localization.ExceptionHandling;
using Volo.Abp.Modularity;
using Volo.Abp.MultiTenancy;
using Volo.Abp.PermissionManagement;
using Volo.Abp.SettingManagement;
using Volo.Abp.Threading;
using Volo.Abp.Timing;
using Volo.Abp.VirtualFileSystem;

namespace Letu.Basis;

[DependsOn(
    typeof(AbpAspNetCoreMvcModule),
    typeof(AbpAutofacModule),
    typeof(AbpAutoMapperModule),
    typeof(AbpAspNetCoreMultiTenancyModule),
    typeof(AbpAspNetCoreSerilogModule),
    typeof(AbpAuthorizationModule),
    typeof(AbpDistributedLockingModule),
    typeof(AbpFeatureManagementDomainModule),
    typeof(AbpMultiTenancyModule),
    typeof(AbpPermissionManagementDomainModule),
    typeof(AbpSettingManagementDomainModule),
    typeof(AbpEventBusModule),
    typeof(AbpEmailingModule),
    typeof(AbpTimingModule),
    typeof(LetuRepositoryModule),
    typeof(LetuLoggingModule)
)]
public class LetuBasisModule : AbpModule
{
    public override void ConfigureServices(ServiceConfigurationContext context)
    {
        var services = context.Services;
        var configuration = context.Configuration;

        ConfigureAutoMapper(services);
        ConfigurePermissionManagement();
        ConfigureFeatureManagement();
        ConfigureLocalization();
        ConfigureMultiTenancy();
        ConfigureOss(configuration);

        services.AddControllers()
            .AddApplicationPart(typeof(LetuBasisModule).Assembly); // 添加外部程序集

        PreConfigure<IMvcBuilder>(mvcBuilder =>
        {
            mvcBuilder.AddApplicationPartIfNotExists(GetType().Assembly);
        });

        services.Configure<MvcOptions>(options =>
        {
            options.Filters.Add<HttpRequestValidationFilter>();
        });


        // 配置高德地图 HttpClient
        services.AddHttpClient("amap", client =>
        {
            client.BaseAddress = new Uri("https://restapi.amap.com");
            client.Timeout = TimeSpan.FromSeconds(30);
        });


        SnowflakeHelper.Init(short.Parse(configuration["Snowflake:WorkerId"]!), short.Parse(configuration["Snowflake:DataCenterId"]!));
    }

    private void ConfigureAutoMapper(IServiceCollection services)
    {
        services.AddAutoMapperObjectMapper<LetuBasisModule>();
        Configure<AbpAutoMapperOptions>(options =>
        {
            options.AddMaps<LetuBasisModule>(validate: true);
        });
    }

    private void ConfigurePermissionManagement()
    {
        Configure<PermissionManagementOptions>(options =>
        {
            options.ManagementProviders.Add<UserPermissionManagementProvider>();
            options.ManagementProviders.Add<RolePermissionManagementProvider>();

            // 添加用户管理和角色管理的权限策略，用于配置权限管理页面的权限控制
            options.ProviderPolicies[UserPermissionValueProvider.ProviderName] = BasisPermissions.User.ManagePermission;
            options.ProviderPolicies[RolePermissionValueProvider.ProviderName] = BasisPermissions.Role.ManagePermission;
        });
    }

    private void ConfigureFeatureManagement()
    {
        Configure<FeatureManagementOptions>(options =>
        {
            options.ProviderPolicies[EditionFeatureValueProvider.ProviderName] = BasisPermissions.Edition.ManageFeatures;
            options.ProviderPolicies[TenantFeatureValueProvider.ProviderName] = BasisPermissions.Tenant.ManageFeatures;
        });

        Configure<AbpExceptionLocalizationOptions>(options =>
        {
            options.MapCodeNamespace("AbpFeatureManagement", typeof(AbpFeatureManagementResource));
        });
    }

    private void ConfigureMultiTenancy()
    {
        Configure<AbpMultiTenancyOptions>(options =>
        {
            options.IsEnabled = MultiTenancyConsts.IsEnabled;
        });
    }

    private void ConfigureLocalization()
    {
        Configure<AbpVirtualFileSystemOptions>(options =>
        {
            options.FileSets.AddEmbedded<LetuBasisModule>();
        });

        Configure<AbpLocalizationOptions>(options =>
        {
            options.Resources
                .Add<BasisResource>("zh-Hans")
                .AddVirtualJson("/Letu/Basis/Localization/Resources");
        });

        Configure<AbpExceptionLocalizationOptions>(options =>
        {
            options.MapCodeNamespace("Volo.AbpIo.MultiTenancy", typeof(BasisResource));
        });
    }

    private void ConfigureOss(IConfiguration configuration)
    {
        Configure<OssOptions>(configuration.GetSection("Oss"));
    }

    public override void OnApplicationInitialization(ApplicationInitializationContext context)
    {
        SeedBasisData(context);
    }

    public override async Task OnApplicationInitializationAsync(ApplicationInitializationContext context)
    {
        // 注册后台工作者
        await context.AddBackgroundWorkerAsync<LogCleanupWorker>();

        await base.OnApplicationInitializationAsync(context);
    }

    private static void SeedBasisData(ApplicationInitializationContext context)
    {
        using (var scope = context.ServiceProvider.CreateScope())
        {
            var dataSeeder = scope.ServiceProvider.GetRequiredService<IDataSeeder>();
            AsyncHelper.RunSync(async () => await dataSeeder.SeedAsync()); // 触发种子数据
        }
    }
}