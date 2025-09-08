using FreeSql;
using Letu.Repository;
using Volo.Abp.FeatureManagement;
using Volo.Abp.MultiTenancy;

namespace Letu.Abp.FeatureManagement;

public class FreeSqlFeatureValueRepository : FreeSqlRepository<FeatureValue, Guid>, IFeatureValueRepository
{
    public FreeSqlFeatureValueRepository(UnitOfWorkManager uowManger, ICurrentTenant currentTenant)
        : base(uowManger, currentTenant)
    {
    }

    public virtual async Task<FeatureValue> FindAsync(
        string name,
        string providerName,
        string providerKey,
        CancellationToken cancellationToken = default)
    {
        return await base.Select
            .Where(s => s.Name == name && s.ProviderName == providerName && s.ProviderKey == providerKey)
            .OrderBy(x => x.Id)
            .FirstAsync(cancellationToken);
    }

    public virtual async Task<List<FeatureValue>> FindAllAsync(
        string name,
        string providerName,
        string providerKey,
        CancellationToken cancellationToken = default)
    {
        return await base.Select
            .Where(s => s.Name == name && s.ProviderName == providerName && s.ProviderKey == providerKey)
            .ToListAsync(cancellationToken);
    }

    public virtual async Task<List<FeatureValue>> GetListAsync(
        string providerName,
        string providerKey,
        CancellationToken cancellationToken = default)
    {
        return await base.Select
            .Where(s => s.ProviderName == providerName && s.ProviderKey == providerKey)
            .ToListAsync(cancellationToken);
    }

    public virtual async Task DeleteAsync(
        string providerName,
        string providerKey,
        CancellationToken cancellationToken = default)
    {
        await base.DeleteAsync(s => s.ProviderName == providerName && s.ProviderKey == providerKey, cancellationToken);
    }
}
