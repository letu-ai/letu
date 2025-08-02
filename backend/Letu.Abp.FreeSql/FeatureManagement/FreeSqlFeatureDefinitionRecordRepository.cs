using FreeSql;
using Letu.Repository;
using Volo.Abp.FeatureManagement;

namespace Letu.Abp.FeatureManagement;

public class FreeSqlFeatureDefinitionRecordRepository : FreeSqlRepository<FeatureDefinitionRecord, Guid>, IFeatureDefinitionRecordRepository
{
    public FreeSqlFeatureDefinitionRecordRepository(
        UnitOfWorkManager uowManger)
        : base(uowManger)
    {
    }

    public virtual async Task<FeatureDefinitionRecord> FindByNameAsync(string name, CancellationToken cancellationToken = default)
    {
        return await base.Select
            .Where(r => r.Name == name)
            .OrderBy(x => x.Id)
            .FirstAsync(cancellationToken);
    }
}
