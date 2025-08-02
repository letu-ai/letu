using Letu.Repository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;
using Volo.Abp.Auditing;
using Volo.Abp.AuditLogging;
using Volo.Abp.AutoMapper;
using Volo.Abp.ExceptionHandling;
using Volo.Abp.Modularity;

namespace Letu.Logging
{
    [DependsOn(
        typeof(AbpAuditingModule),
        typeof(AbpAuditLoggingDomainModule),
        typeof(AbpAutoMapperModule),
        typeof(AbpExceptionHandlingModule),
        typeof(LetuRepositoryModule)
        )]
    public class LetuLoggingModule : AbpModule
    {
        public override void PreConfigureServices(ServiceConfigurationContext context)
        {
            context.Services.OnRegistered(OperationLogInterceptorRegistrar.RegisterIfNeeded);
        }

        public override void ConfigureServices(ServiceConfigurationContext context)
        {
            // 注册审计日志存储
            ConfigureAutoMapper(context.Services);

            context.Services.Configure<MvcOptions>(options =>
            {
                options.Filters.Add<ExceptionLogFilter>(99);    // 99 为优先级，数字越小优先级越高
            });
        }

        private void ConfigureAutoMapper(IServiceCollection services)
        {
            Configure<AbpAutoMapperOptions>(options =>
            {
                options.AddMaps<LetuLoggingModule>();
            });
        }
    }
}