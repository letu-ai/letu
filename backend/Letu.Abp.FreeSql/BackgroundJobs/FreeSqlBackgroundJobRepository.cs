using FreeSql;
using Letu.Repository;
using Volo.Abp.Timing;
using Volo.Abp.BackgroundJobs;
using Volo.Abp.MultiTenancy;

namespace Letu.Abp.BackgroundJobs;

public class FreeSqlBackgroundJobRepository : FreeSqlRepository<BackgroundJobRecord, Guid>, IBackgroundJobRepository
{
    private readonly IClock clock;

    public FreeSqlBackgroundJobRepository(
        UnitOfWorkManager uowManger,
        ICurrentTenant currentTenant,
        IClock clock)
        : base(uowManger, currentTenant)
    {
        this.clock = clock;
    }




    public virtual async Task<List<BackgroundJobRecord>> GetWaitingListAsync(string? applicationName, int maxResultCount, CancellationToken cancellationToken = default)
    {
        var now = clock.Now;
        return await base.Select
            .Where(t => t.ApplicationName == applicationName)
            .Where(t => !t.IsAbandoned && t.NextTryTime <= now)
            .OrderBy("Priority desc, TryCount, NextTryTime")
            .Take(maxResultCount)
            .ToListAsync(cancellationToken);
    }
}
