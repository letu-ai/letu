using FreeSql;
using FreeSql.Aop;
using FreeSql.Internal;
using Letu.Core.MultiTenancy;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Volo.Abp;
using Volo.Abp.Auditing;
using Volo.Abp.Domain.Entities;
using Volo.Abp.Guids;
using Volo.Abp.MultiTenancy;

namespace Letu.Repository
{
    public static class FreeSqlFactory
    {
        public static IFreeSql Create(IServiceProvider serviceProvider)
        {
            var configuration = serviceProvider.GetRequiredService<IConfiguration>();
            var logger = serviceProvider.GetRequiredService<ILogger<IFreeSql>>();
            var freeSqlOptions = serviceProvider.GetService<IOptions<FreeSqlOptions>>()?.Value ?? new FreeSqlOptions();

            IFreeSql fsql = new FreeSqlBuilder()
                .UseConnectionString(DataType.PostgreSQL, configuration.GetConnectionString("Default"))
                .UseAdoConnectionPool(true)
                .UseNameConvert(NameConvertType.PascalCaseToUnderscoreWithLower)
                .UseMonitorCommand(cmd => logger.LogTrace("SQL: {CommandText}", cmd.CommandText))
#if DEBUG
                .UseAutoSyncStructure(true) //自动同步实体结构到数据库，只有CRUD时才会生成表
#endif
                .Build();

            // 执行所有模块预设的配置Action
            foreach (var configureAction in freeSqlOptions.ConfigureActions)
            {
                configureAction(fsql);
            }

            //审计字段
            fsql.Aop.AuditValue += (s, e) =>
            {
                var guidGenerator = serviceProvider.GetRequiredService<IGuidGenerator>();
                var auditPropertySetter = serviceProvider.GetRequiredService<IAuditPropertySetter>();
                // 创建
                if (e.AuditValueType == AuditValueType.Insert)
                {
                    ApplyAbpConceptsForAddedEntity(e.Object, auditPropertySetter, guidGenerator);

                }
                else if (e.AuditValueType == AuditValueType.Update)
                {
                    ApplyAbpConceptsForModifiedEntity(e.Object, auditPropertySetter);
                }

                // 只需要执行一次就设置完所有审计属性，所以这里终止当前实体的审计
                e.ObjectAuditBreak = true;
            };


            // 检测更新冲突
            fsql.Aop.CurdAfter += (s, e) =>
            {
                if (e.CurdType == CurdType.Update && e.ElapsedMilliseconds > 0)
                {
                    //if (e.ExecuteResult? <= 0)
                    //{
                    //    throw new DbUpdateConcurrencyException(
                    //        "并发冲突：记录已被修改",
                    //        new List<object> { e.Entity });
                    //}
                }
            };

            //过滤器
            fsql.GlobalFilter.Apply<ISoftDelete>("DeletedFilter", x => !x.IsDeleted, before: true);
            fsql.GlobalFilter.ApplyIf<IMultiTenant>(
                "TenantFilter",
                () => MultiTenancyConsts.IsEnabled && TenantManager.Current.HasValue,
                a => a.TenantId == TenantManager.Current,
                before: true);

            return fsql;
        }

        private static void ApplyAbpConceptsForAddedEntity(object entity, IAuditPropertySetter auditPropertySetter, IGuidGenerator guidGenerator)
        {
            CheckAndSetId(entity, guidGenerator);
            SetConcurrencyStampIfNull(entity);
            auditPropertySetter.SetCreationProperties(entity);
        }

        private static void ApplyAbpConceptsForModifiedEntity(object entity, IAuditPropertySetter auditPropertySetter)
        {
            auditPropertySetter.SetModificationProperties(entity);
            if (entity is ISoftDelete && entity.As<ISoftDelete>().IsDeleted)
            {
                auditPropertySetter.SetDeletionProperties(entity);
            }
        }

        private static void UpdateConcurrencyStamp(object entity)
        {
            if (entity is IHasConcurrencyStamp concurrencyEntity)
            {
                concurrencyEntity.ConcurrencyStamp = Guid.NewGuid().ToString("N");
            }
        }

        private static void SetConcurrencyStampIfNull(object entity)
        {
            if (entity is IHasConcurrencyStamp concurrencyEntity)
            {
                concurrencyEntity.ConcurrencyStamp ??= Guid.NewGuid().ToString("N");
            }
        }

        private static void CheckAndSetId(object entity, IGuidGenerator guidGenerator)
        {
            if (entity is IEntity<Guid> entityWithGuidId)
            {
                TrySetGuidId(entityWithGuidId, guidGenerator);
            }
        }

        private static void TrySetGuidId(IEntity<Guid> entity, IGuidGenerator guidGenerator)
        {
            if (entity.Id != default)
            {
                return;
            }

            //var idProperty = entity.Property("Id").Metadata.PropertyInfo!;

            ////Check for DatabaseGeneratedAttribute
            //var dbGeneratedAttr = ReflectionHelper
            //    .GetSingleAttributeOrDefault<DatabaseGeneratedAttribute>(
            //        idProperty
            //    );

            //if (dbGeneratedAttr != null && dbGeneratedAttr.DatabaseGeneratedOption != DatabaseGeneratedOption.None)
            //{
            //    return;
            //}

            EntityHelper.TrySetId(
                entity,
                () => guidGenerator.Create(),
                true
            );
        }
    }
}