using FreeSql;
using Letu.Repository;
using Volo.Abp.FeatureManagement;

namespace Letu.Abp.FeatureManagement;

public class FreeSqlFeatureGroupDefinitionRecordRepository :
   FreeSqlRepository<FeatureGroupDefinitionRecord, Guid>,
   IFeatureGroupDefinitionRecordRepository
{
    public FreeSqlFeatureGroupDefinitionRecordRepository(
        UnitOfWorkManager uowManger)
        : base(uowManger)
    {
    }
}
