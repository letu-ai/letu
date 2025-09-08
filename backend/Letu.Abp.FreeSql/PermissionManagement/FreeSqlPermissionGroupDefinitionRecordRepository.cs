using FreeSql;
using Letu.Repository;
using Volo.Abp.MultiTenancy;
using Volo.Abp.PermissionManagement;

namespace Letu.Abp.PermissionManagement;

public class FreeSqlPermissionGroupDefinitionRecordRepository :
   FreeSqlRepository<PermissionGroupDefinitionRecord, Guid>,
   IPermissionGroupDefinitionRecordRepository
{
    public FreeSqlPermissionGroupDefinitionRecordRepository(
        UnitOfWorkManager uowManger, ICurrentTenant currentTenant)
        : base(uowManger,currentTenant)
    {
    }
}