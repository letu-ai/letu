using Letu.Repository;
using Volo.Abp.FeatureManagement;

namespace Letu.Abp.FeatureManagement;

public static class FeatureManagementFreeSqlExtensions
{
    public static void ConfigureFeatureManagement(this IFreeSql freeSql)
    {
        freeSql.CodeFirst.Entity<FeatureValue>(entity =>
        {
            entity.ToTable("sys_feature_values");

            entity.ConfigureByConvention();

            entity.Property(x => x.Name).HasMaxLength(FeatureValueConsts.MaxNameLength).IsRequired();
            entity.Property(x => x.Value).HasMaxLength(FeatureValueConsts.MaxValueLength).IsRequired();
            entity.Property(x => x.ProviderName).HasMaxLength(FeatureValueConsts.MaxProviderNameLength);
            entity.Property(x => x.ProviderKey).HasMaxLength(FeatureValueConsts.MaxProviderKeyLength);

            entity.HasIndex(x => new { x.Name, x.ProviderName, x.ProviderKey }).IsUnique();

            entity.ConfigureExtraProperties();
        });
        
        freeSql.CodeFirst.Entity<FeatureGroupDefinitionRecord>(entity =>
        {
            entity.ToTable("sys_feature_groups");

            entity.ConfigureByConvention();

            entity.Property(x => x.Name).HasMaxLength(FeatureGroupDefinitionRecordConsts.MaxNameLength).IsRequired();
            entity.Property(x => x.DisplayName).HasMaxLength(FeatureGroupDefinitionRecordConsts.MaxDisplayNameLength).IsRequired();

            entity.HasIndex(x => new { x.Name }).IsUnique();

            entity.ConfigureExtraProperties();
        });

        freeSql.CodeFirst.Entity<FeatureDefinitionRecord>(entity =>
        {
            entity.ToTable("sys_features");

            entity.ConfigureByConvention();

            entity.Property(x => x.GroupName).HasMaxLength(FeatureGroupDefinitionRecordConsts.MaxNameLength).IsRequired();
            entity.Property(x => x.Name).HasMaxLength(FeatureDefinitionRecordConsts.MaxNameLength).IsRequired();
            entity.Property(x => x.ParentName).HasMaxLength(FeatureDefinitionRecordConsts.MaxNameLength);
            entity.Property(x => x.DisplayName).HasMaxLength(FeatureDefinitionRecordConsts.MaxDisplayNameLength).IsRequired();
            entity.Property(x => x.Description).HasMaxLength(FeatureDefinitionRecordConsts.MaxDescriptionLength);
            entity.Property(x => x.DefaultValue).HasMaxLength(FeatureDefinitionRecordConsts.MaxDefaultValueLength);
            entity.Property(x => x.AllowedProviders).HasMaxLength(FeatureDefinitionRecordConsts.MaxAllowedProvidersLength);
            entity.Property(x => x.ValueType).HasMaxLength(FeatureDefinitionRecordConsts.MaxValueTypeLength);

            entity.HasIndex(x => new { x.Name }).IsUnique();
            entity.HasIndex(x => new { x.GroupName });

            entity.ConfigureExtraProperties();
        });
    }
}