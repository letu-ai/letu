using FreeSql.Extensions.EfCoreFluentApi;
using Volo.Abp;
using Volo.Abp.Auditing;
using Volo.Abp.Data;
using Volo.Abp.Domain.Entities;

namespace Letu.Repository;

public static class FreeSqlEntityTypeBuilderExtensions
{
    /// <summary>
    /// 配置实体的公共字段，包括ID、审计字段、软删除、多租户等
    /// </summary>
    public static void ConfigureByConvention<TEntity>(this EfCoreTableFluent<TEntity> entity)
        where TEntity : class, IEntity
    {
        var entityType = typeof(TEntity);

        // 配置创建时间
        if (typeof(IHasCreationTime).IsAssignableFrom(entityType))
        {
            entity.Property(nameof(IHasCreationTime.CreationTime)).IsRequired();
        }

        // 配置创建者
        if (typeof(ICreationAuditedObject).IsAssignableFrom(entityType))
        {
            entity.Property(nameof(ICreationAuditedObject.CreatorId)).IsRequired();
        }

        // 配置软删除
        if (typeof(ISoftDelete).IsAssignableFrom(entityType))
        {
            entity.Property(nameof(ISoftDelete.IsDeleted))
                .IsRequired()
                .HasDefaultValueSql("false");
        }

        // 配置并发标记
        if (typeof(IHasConcurrencyStamp).IsAssignableFrom(entityType))
        {
            entity.Property(nameof(IHasConcurrencyStamp.ConcurrencyStamp))
                .HasMaxLength(ConcurrencyStampConsts.MaxLength);
        }
    }

    /// <summary>
    /// 配置扩展属性，将扩展属性序列化为JSON存储到Text字段
    /// </summary>
    public static void ConfigureExtraProperties<TEntity>(this EfCoreTableFluent<TEntity> entity)
        where TEntity : class, IEntity
    {
        // 检查是否实现了 IHasExtraProperties 接口
        if (typeof(IHasExtraProperties).IsAssignableFrom(typeof(TEntity)))
        {
            entity.Property(nameof(IHasExtraProperties.ExtraProperties))
            .HasColumnType("text");
        }
    }
}