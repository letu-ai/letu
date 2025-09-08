using FreeSql;
using Letu.Repository;
using Volo.Abp.MultiTenancy;
using Volo.Abp.PermissionManagement;

namespace Letu.Abp.PermissionManagement;

public class FreeSqlPermissionDefinitionRecordRepository :
   FreeSqlRepository<PermissionDefinitionRecord, Guid>,
   IPermissionDefinitionRecordRepository
{
    public FreeSqlPermissionDefinitionRecordRepository(
        UnitOfWorkManager uowManger, ICurrentTenant currentTenant)
        : base(uowManger, currentTenant)
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