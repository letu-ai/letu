using FreeSql;
using Letu.Repository;
using Volo.Abp.FeatureManagement;
using Volo.Abp.MultiTenancy;

namespace Letu.Abp.FeatureManagement;

public class FreeSqlFeatureGroupDefinitionRecordRepository :
   FreeSqlRepository<FeatureGroupDefinitionRecord, Guid>,
   IFeatureGroupDefinitionRecordRepository
{
    public FreeSqlFeatureGroupDefinitionRecordRepository(
        UnitOfWorkManager uowManger, ICurrentTenant currentTenant)
        : base(uowManger, currentTenant)
    {
    }
}
