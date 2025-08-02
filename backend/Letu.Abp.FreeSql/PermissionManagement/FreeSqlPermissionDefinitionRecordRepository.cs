using FreeSql;
using Letu.Repository;
using Volo.Abp.PermissionManagement;

namespace Letu.Abp.PermissionManagement;

public class FreeSqlPermissionDefinitionRecordRepository :
   FreeSqlRepository<PermissionDefinitionRecord, Guid>,
   IPermissionDefinitionRecordRepository
{
    public FreeSqlPermissionDefinitionRecordRepository(
        UnitOfWorkManager uowManger)
        : base(uowManger)
    {
    }

    public virtual async Task<PermissionDefinitionRecord> FindByNameAsync(
        string name,
        CancellationToken cancellationToken = default)
    {
        return await base.Select
            .Where(r => r.Name == name)
            .OrderBy(x => x.Id)
            .FirstAsync(cancellationToken);
    }
}