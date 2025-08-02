using Letu.Abp.AuditLogging;
using Letu.Abp.BackgroundJobs;
using Letu.Abp.FeatureManagement;
using Letu.Abp.PermissionManagement;
using Letu.Abp.SettingManagement;
using Microsoft.Extensions.DependencyInjection;
using Volo.Abp.AuditLogging;
using Volo.Abp.Modularity;

namespace Letu.Abp
{
    [DependsOn(
        typeof(AbpAuditLoggingDomainModule)
        )]
    public class LetuAbpFreeSqlModule : AbpModule
    {
        public override void ConfigureServices(ServiceConfigurationContext context)
        {
            // 配置FreeSqlOptions
            context.Services.Configure<Letu.Repository.FreeSqlOptions>(options =>
            {
                // 注册ABP相关的FreeSql配置Action
                options.AddConfigureAction(freeSql =>
                {
                    freeSql.ConfigureAuditLogging();
                    freeSql.ConfigureBackgroundJobs();
                    freeSql.ConfigurePermissionManagement();
                    freeSql.ConfigureSettingManagement();
                    freeSql.ConfigureFeatureManagement();
                });
            });
        }
    }
}