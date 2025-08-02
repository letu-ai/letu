using Letu.Repository;
using Volo.Abp.SettingManagement;

namespace Letu.Abp.SettingManagement;

public static class SettingManagementFreeSqlExtensions
{
    public static void ConfigureSettingManagement(this IFreeSql freeSql)
    {
        freeSql.CodeFirst.Entity<Setting>(entity =>
        {
            entity.ToTable("sys_settings");

            entity.ConfigureByConvention();

            entity.Property(x => x.Name).HasMaxLength(SettingConsts.MaxNameLength).IsRequired();

            // Note: FreeSql doesn't have IsUsingOracle() method, so removing the Oracle check
            entity.Property(x => x.Value).HasMaxLength(SettingConsts.MaxValueLengthValue).IsRequired();

            entity.Property(x => x.ProviderName).HasMaxLength(SettingConsts.MaxProviderNameLength);
            entity.Property(x => x.ProviderKey).HasMaxLength(SettingConsts.MaxProviderKeyLength);

            entity.HasIndex(x => new { x.Name, x.ProviderName, x.ProviderKey }).IsUnique();

            // Setting entity doesn't implement IHasExtraProperties
        });

        freeSql.CodeFirst.Entity<SettingDefinitionRecord>(entity =>
        {
            entity.ToTable("sys_setting_definitions");

            entity.ConfigureByConvention();

            entity.Property(x => x.Name).HasMaxLength(SettingDefinitionRecordConsts.MaxNameLength).IsRequired();
            entity.Property(x => x.DisplayName).HasMaxLength(SettingDefinitionRecordConsts.MaxDisplayNameLength).IsRequired();
            entity.Property(x => x.Description).HasMaxLength(SettingDefinitionRecordConsts.MaxDescriptionLength);
            entity.Property(x => x.DefaultValue).HasMaxLength(SettingDefinitionRecordConsts.MaxDefaultValueLength);
            entity.Property(x => x.Providers).HasMaxLength(SettingDefinitionRecordConsts.MaxProvidersLength);

            entity.HasIndex(x => new { x.Name }).IsUnique();

            // SettingDefinitionRecord entity has ExtraProperties support
            entity.ConfigureExtraProperties();
        });
    }
}