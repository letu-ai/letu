using FreeSql;
using Letu.Repository;
using Volo.Abp.SettingManagement;

namespace Letu.Abp.SettingManagement;

public class FreeSqlSettingDefinitionRecordRepository : FreeSqlRepository<SettingDefinitionRecord, Guid>, ISettingDefinitionRecordRepository
{
    public FreeSqlSettingDefinitionRecordRepository(UnitOfWorkManager uowManger)
        : base(uowManger)
    {
    }

    public virtual async Task<SettingDefinitionRecord> FindByNameAsync(string name, CancellationToken cancellationToken = default)
    {
        return await base.Select
            .Where(x => x.Name == name)
            .OrderBy(x => x.Id)
            .FirstAsync(cancellationToken);
    }
}
