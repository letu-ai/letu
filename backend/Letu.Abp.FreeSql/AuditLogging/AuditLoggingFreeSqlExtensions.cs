using Letu.Repository;
using Volo.Abp.AuditLogging;

namespace Letu.Abp.AuditLogging;
public static class AuditLoggingFreeSqlExtensions
{
    /// <summary>
    /// 配置 AuditingLog扩展
    /// </summary>
    public static void ConfigureAuditLogging(this IFreeSql freeSql)
    {
        freeSql.CodeFirst
            .Entity<AuditLog>(entity =>
            {
                entity.ToTable("sys_audit_logs");
                entity.HasKey(e => e.Id);

                entity.ConfigureByConvention();

                entity.Property(e => e.ApplicationName).HasMaxLength(AuditLogConsts.MaxApplicationNameLength);
                entity.Property(e => e.UserName).HasMaxLength(AuditLogConsts.MaxUserNameLength);
                entity.Property(e => e.TenantName).HasMaxLength(AuditLogConsts.MaxTenantNameLength);
                entity.Property(e => e.ImpersonatorTenantName).HasMaxLength(AuditLogConsts.MaxTenantNameLength);
                entity.Property(e => e.ImpersonatorUserName).HasMaxLength(AuditLogConsts.MaxUserNameLength);
                entity.Property(e => e.ClientIpAddress).HasMaxLength(AuditLogConsts.MaxClientIpAddressLength);
                entity.Property(e => e.ClientName).HasMaxLength(AuditLogConsts.MaxClientNameLength);
                entity.Property(e => e.ClientId).HasMaxLength(AuditLogConsts.MaxClientIdLength);
                entity.Property(e => e.CorrelationId).HasMaxLength(AuditLogConsts.MaxCorrelationIdLength);
                entity.Property(e => e.BrowserInfo).HasMaxLength(AuditLogConsts.MaxBrowserInfoLength);
                entity.Property(e => e.HttpMethod).HasMaxLength(AuditLogConsts.MaxHttpMethodLength);
                entity.Property(e => e.Url).HasMaxLength(AuditLogConsts.MaxUrlLength);
                entity.Property(e => e.Comments).HasMaxLength(AuditLogConsts.MaxCommentsLength);

                entity.ConfigureExtraProperties();

                entity.HasMany(e => e.Actions)
                    .HasForeignKey(a => a.AuditLogId);
                entity.HasMany(e => e.EntityChanges).HasForeignKey(a => a.AuditLogId);

            })
            .Entity<AuditLogAction>(entity =>
            {
                entity.ToTable("sys_audit_log_actions");
                entity.ConfigureByConvention();

                entity.HasKey(e => e.Id);
                entity.Property(e => e.AuditLogId).IsRequired();
                entity.Property(e => e.ServiceName).HasMaxLength(AuditLogActionConsts.MaxServiceNameLength);
                entity.Property(e => e.MethodName).HasMaxLength(AuditLogActionConsts.MaxMethodNameLength);
                entity.Property(e => e.Parameters).HasMaxLength(AuditLogActionConsts.MaxParametersLength);
                entity.Property(e => e.ExtraProperties).HasColumnType("text");

            })
            .Entity<EntityChange>(entity =>
            {
                entity.ToTable("sys_entity_changes");
                entity.ConfigureByConvention();

                entity.HasKey(e => e.Id);
                entity.Property(e => e.AuditLogId).IsRequired();
                entity.Property(e => e.EntityId).HasMaxLength(EntityChangeConsts.MaxEntityIdLength);
                entity.Property(e => e.EntityTypeFullName).IsRequired().HasMaxLength(EntityChangeConsts.MaxEntityTypeFullNameLength);
                entity.Property(e => e.ExtraProperties).HasColumnType("text");

                entity.HasMany(e => e.PropertyChanges).HasForeignKey(e => e.EntityChangeId);
            })
            .Entity<EntityPropertyChange>(entity =>
            {
                entity.ToTable("sys_entity_property_changes");
                entity.ConfigureByConvention();

                entity.HasKey(e => e.Id);
                entity.Property(e => e.EntityChangeId).IsRequired();
                entity.Property(e => e.NewValue).HasMaxLength(EntityPropertyChangeConsts.MaxNewValueLength);
                entity.Property(e => e.OriginalValue).HasMaxLength(EntityPropertyChangeConsts.MaxOriginalValueLength);
                entity.Property(e => e.PropertyName).IsRequired().HasMaxLength(EntityPropertyChangeConsts.MaxPropertyNameLength);
                entity.Property(e => e.PropertyTypeFullName).IsRequired().HasMaxLength(EntityPropertyChangeConsts.MaxPropertyTypeFullNameLength);
            });

        //// 配置导航属性
        //freeSql.CodeFirst.ConfigEntity<AuditLog>(entity =>
        //    entity.Navigate(a => a.Actions, "AuditLogId")
        //         .Navigate(a => a.EntityChanges, "AuditLogId")
        //);

        //freeSql.CodeFirst.ConfigEntity<EntityChange>(entity =>
        //    entity.Navigate(a => a.PropertyChanges, "EntityChangeId")
        //);
    }
}
