using FreeSql;
using Letu.Repository;
using Volo.Abp.Timing;
using Volo.Abp.BackgroundJobs;

namespace Letu.Abp.BackgroundJobs;

public class FreeSqlBackgroundJobRepository : FreeSqlRepository<BackgroundJobRecord, Guid>, IBackgroundJobRepository
{
    private readonly IClock clock;

    public FreeSqlBackgroundJobRepository(
        UnitOfWorkManager uowManger,
        IClock clock)
        : base(uowManger)
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
