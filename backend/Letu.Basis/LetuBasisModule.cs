using Letu.Basis.Filters;
using Letu.Basis.Middlewares;
using Letu.Core.Helpers;
using Letu.Job;
using Letu.Logging;
using Letu.ObjectStorage;
using Letu.Repository;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MQTTnet.AspNetCore;
using System.Reflection;
using Volo.Abp;
using Volo.Abp.AspNetCore.Mvc;
using Volo.Abp.AspNetCore.MultiTenancy;
using Volo.Abp.AspNetCore.Serilog;
using Volo.Abp.Authorization;
using Volo.Abp.Autofac;
using Volo.Abp.AutoMapper;
using Volo.Abp.DistributedLocking;
using Volo.Abp.EventBus;
using Volo.Abp.Modularity;

namespace Letu.Basis
{
    [DependsOn(
        typeof(AbpAspNetCoreMvcModule),
        typeof(AbpAutofacModule),
        typeof(AbpAspNetCoreMultiTenancyModule),
        typeof(AbpAspNetCoreSerilogModule),
        typeof(AbpAuthorizationModule),
        typeof(AbpAutoMapperModule),
        typeof(AbpDistributedLockingModule),
        typeof(AbpEventBusModule),
        typeof(LetuRepositoryModule),
        typeof(LetuLoggingModule),
        typeof(LetuObjectStorageModule),
        typeof(LetuJobModule)
        )]
    public class LetuBasisModule : AbpModule
    {
        public override void ConfigureServices(ServiceConfigurationContext context)
        {
            var services = context.Services;
            var configuration = context.Configuration;

            ConfigureAutoMapper(services);

            services.AddControllers()
                .AddApplicationPart(typeof(LetuBasisModule).Assembly); // 添加外部程序集

            PreConfigure<IMvcBuilder>(mvcBuilder =>
            {
                mvcBuilder.AddApplicationPartIfNotExists(GetType().Assembly);
            });

            services.AddHostedMqttServer(
                optionsBuilder =>
                {
                    optionsBuilder.WithDefaultEndpoint();
                });
            services.AddMqttConnectionHandler();

            services.Configure<MvcOptions>(options =>
            {
                options.Filters.Add<HttpRequestValidationFilter>();
                options.Filters.Add<AppGlobalExceptionFilter>(1);
            });


            services.AddSingleton<IAuthorizationMiddlewareResultHandler, IdentityMiddlewareResultHandler>();

            //Swagger
            services.AddSwaggerGen(c =>
            {
                // 设置Swagger读取XML注释
                var xmlFile = $"{Assembly.GetExecutingAssembly().GetName().Name}.xml";
                var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFile);
                if (File.Exists(xmlPath))
                {
                    c.IncludeXmlComments(xmlPath, includeControllerXmlComments: true);
                }
            });

            services.AddHostedService<PreparationHostService>();


            SnowflakeHelper.Init(short.Parse(configuration["Snowflake:WorkerId"]!), short.Parse(configuration["Snowflake:DataCenterId"]!));
        }


        private void ConfigureAutoMapper(IServiceCollection services)
        {
            Configure<AbpAutoMapperOptions>(options =>
            {
                options.AddMaps<LetuBasisModule>();
            });
        }

        public override void OnApplicationInitialization(ApplicationInitializationContext context)
        {

        }
    }
}