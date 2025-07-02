using Fancyx.Core.Authorization;
using Fancyx.Core.AutoInject;
using Fancyx.Core.Interfaces;
using Fancyx.Repository.BaseEntity;
using FreeSql.Internal;
using FreeSql;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;
using Fancyx.Core.Context;

namespace Fancyx.Repository
{
    public class FancyxRepositoryModule : ModuleBase
    {
        public override void ConfigureServices(ServiceConfigurationContext context)
        {
            IFreeSql createFreeSql()
            {
                IFreeSql fsql = new FreeSqlBuilder()
                    .UseConnectionString(DataType.PostgreSQL, context.Configuration.GetConnectionString("Default"))
                    .UseAdoConnectionPool(true)
                    .UseNameConvert(NameConvertType.PascalCaseToUnderscoreWithLower)
                    .UseMonitorCommand(cmd => Console.WriteLine($"Sql：{cmd.CommandText}"))
#if DEBUG
                    .UseAutoSyncStructure(true) //自动同步实体结构到数据库，只有CRUD时才会生成表
#endif
                    .Build();

                //审计字段
                fsql.Aop.AuditValue += (s, e) =>
                {
                    if (e.AuditValueType == FreeSql.Aop.AuditValueType.Insert)
                    {
                        if (e.Column.CsType == typeof(DateTime) && e.Property.Name == nameof(CreationEntity.CreationTime) && (e.Value == null || e.Value == DBNull.Value || (DateTime)e.Value == default))
                        {
                            e.Value = DateTime.Now;
                        }
                        if (!string.IsNullOrEmpty(UserManager.Current) && e.Property.Name == nameof(CreationEntity.CreatorId) && (e.Value == null || e.Value == DBNull.Value))
                        {
                            e.Value = UserManager.Current;
                        }
                    }
                    if (e.AuditValueType == FreeSql.Aop.AuditValueType.Update)
                    {
                        if (e.Column.CsType == typeof(DateTime?) && e.Property.Name == nameof(AuditedEntity.LastModificationTime) && (e.Value == null || e.Value == DBNull.Value || (DateTime?)e.Value == default))
                        {
                            e.Value = DateTime.Now;
                        }
                        if (!string.IsNullOrEmpty(UserManager.Current) && e.Property.Name == nameof(AuditedEntity.LastModifierId) && (e.Value == null || e.Value == DBNull.Value))
                        {
                            e.Value = UserManager.Current;
                        }
                    }
                    if (!string.IsNullOrEmpty(TenantManager.Current) && e.Property.PropertyType == typeof(string) && e.Property.Name == nameof(ITenant.TenantId))
                    {
                        e.Value = TenantManager.Current;
                    }
                };
                //过滤器
                fsql.GlobalFilter.Apply<IDeletionProperty>("DeletedFilter", x => !x.IsDeleted, before: true);
                if (MultiTenancyConsts.IsEnabled)
                {
                    fsql.GlobalFilter.ApplyIf<ITenant>("TenantFilter", () => !string.IsNullOrWhiteSpace(TenantManager.Current), a => a.TenantId == TenantManager.Current);
                }

                return fsql;
            }

            context.Services.AddScoped<UnitOfWorkManager>(r => new UnitOfWorkManager(createFreeSql()));
            context.Services.AddScoped<IFreeSql>(r => r.GetService<UnitOfWorkManager>()?.Orm ?? createFreeSql());
            context.Services.AddScoped(typeof(IRepository<>), typeof(Repository<>));
        }

        public override void Configure(ApplicationInitializationContext context)
        {
        }
    }
}