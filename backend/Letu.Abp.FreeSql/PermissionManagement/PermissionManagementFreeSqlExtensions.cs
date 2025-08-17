using Letu.Repository;
using Volo.Abp.PermissionManagement;

namespace Letu.Abp.PermissionManagement;

public static class PermissionManagementFreeSqlExtensions
{
    public static void ConfigurePermissionManagement(this IFreeSql freeSql)
    {
        freeSql.CodeFirst.Entity<PermissionGrant>(entity =>
        {
            entity.ToTable("sys_permission_grants");

            entity.ConfigureByConvention();

            entity.Property(x => x.Name).HasMaxLength(PermissionDefinitionRecordConsts.MaxNameLength).IsRequired();
            entity.Property(x => x.ProviderName).HasMaxLength(PermissionGrantConsts.MaxProviderNameLength).IsRequired();
            entity.Property(x => x.ProviderKey).HasMaxLength(PermissionGrantConsts.MaxProviderKeyLength).IsRequired();

            entity.HasIndex(x => new { x.TenantId, x.Name, x.ProviderName, x.ProviderKey }).IsUnique();

            // PermissionGrant entity doesn't implement IHasExtraProperties
        });

        // Configuration for host database entities
        freeSql.CodeFirst.Entity<PermissionGroupDefinitionRecord>(entity =>
        {
            entity.ToTable("sys_permission_groups");

            entity.ConfigureByConvention();

            entity.Property(x => x.Name).HasMaxLength(PermissionGroupDefinitionRecordConsts.MaxNameLength).IsRequired();
            entity.Property(x => x.DisplayName).HasMaxLength(PermissionGroupDefinitionRecordConsts.MaxDisplayNameLength)
                .IsRequired();

            entity.HasIndex(x => new { x.Name }).IsUnique();

            entity.ConfigureExtraProperties();
        });

        freeSql.CodeFirst.Entity<PermissionDefinitionRecord>(entity =>
        {
            entity.ToTable("sys_permissions");

            entity.ConfigureByConvention();

            entity.Property(x => x.GroupName).HasMaxLength(PermissionGroupDefinitionRecordConsts.MaxNameLength)
                .IsRequired();
            entity.Property(x => x.Name).HasMaxLength(PermissionDefinitionRecordConsts.MaxNameLength).IsRequired();
            entity.Property(x => x.ParentName).HasMaxLength(PermissionDefinitionRecordConsts.MaxNameLength);
            entity.Property(x => x.DisplayName).HasMaxLength(PermissionDefinitionRecordConsts.MaxDisplayNameLength)
                .IsRequired();
            entity.Property(x => x.Providers).HasMaxLength(PermissionDefinitionRecordConsts.MaxProvidersLength);
            entity.Property(x => x.StateCheckers).HasMaxLength(PermissionDefinitionRecordConsts.MaxStateCheckersLength);

            entity.HasIndex(x => new { x.Name }).IsUnique();
            entity.HasIndex(x => new { x.GroupName });

            entity.ConfigureExtraProperties();
        });

        freeSql.CodeFirst.ConfigEntity<PermissionDefinitionRecord>(entity =>
        {
            entity.Property(x => x.MultiTenancySide)
                .MapType(typeof(byte));
        });
    }
}