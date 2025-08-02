using Letu.Repository;
using Volo.Abp.BackgroundJobs;

namespace Letu.Abp.BackgroundJobs;

public static class BackgroundJobsFreeSqlExtensions
{
    public static void ConfigureBackgroundJobs(this IFreeSql freeSql)
    {
        freeSql.CodeFirst.Entity<BackgroundJobRecord>(entity =>
        {
            entity.ToTable("sys_background_jobs");
            entity.ConfigureByConvention();

            entity.Property(x => x.ApplicationName).HasMaxLength(BackgroundJobRecordConsts.MaxApplicationNameLength);
            entity.Property(x => x.JobName).IsRequired().HasMaxLength(BackgroundJobRecordConsts.MaxJobNameLength);
            entity.Property(x => x.JobArgs).IsRequired().HasMaxLength(BackgroundJobRecordConsts.MaxJobArgsLength);
            entity.Property(x => x.TryCount).HasDefaultValueSql("0");
            entity.Property(x => x.NextTryTime);
            entity.Property(x => x.LastTryTime);
            entity.Property(x => x.IsAbandoned).HasDefaultValueSql("false");
            entity.Property(x => x.Priority).HasDefaultValueSql($"{(int)BackgroundJobPriority.Normal}");

            entity.ConfigureExtraProperties();

            entity.HasIndex(x => new { x.IsAbandoned, x.NextTryTime });
        });
    }
}