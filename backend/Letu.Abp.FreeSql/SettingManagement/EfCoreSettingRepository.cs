using FreeSql;
using Letu.Repository;
using Volo.Abp.SettingManagement;

namespace Letu.Abp.SettingManagement;

public class FreeSqlSettingRepository : FreeSqlRepository<Setting, Guid>,
   ISettingRepository
{
    public FreeSqlSettingRepository(UnitOfWorkManager uowManger)
        : base(uowManger)
    {
    }

    public virtual async Task<Setting> FindAsync(
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

    public virtual async Task<List<Setting>> GetListAsync(
        string providerName,
        string providerKey,
        CancellationToken cancellationToken = default)
    {
        return await base.Select
            .Where(s => s.ProviderName == providerName && s.ProviderKey == providerKey)
            .ToListAsync(cancellationToken);
    }

    public virtual async Task<List<Setting>> GetListAsync(
        string[] names,
        string providerName,
        string providerKey,
        CancellationToken cancellationToken = default)
    {
        return await base.Select
            .Where(s => names.Contains(s.Name) && s.ProviderName == providerName && s.ProviderKey == providerKey)
            .ToListAsync(cancellationToken);
    }
}
