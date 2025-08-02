using FreeSql;
using Letu.Repository;
using Volo.Abp.PermissionManagement;

namespace Letu.Abp.PermissionManagement;

public class FreeSqlPermissionGrantRepository :
   FreeSqlRepository<PermissionGrant, Guid>,
   IPermissionGrantRepository
{
    public FreeSqlPermissionGrantRepository(UnitOfWorkManager uowManger)
        : base(uowManger)
    {

    }

    public virtual async Task<PermissionGrant> FindAsync(
        string name,
        string providerName,
        string providerKey,
        CancellationToken cancellationToken = default)
    {
        return await base.Select
            .Where(s =>
                s.Name == name &&
                s.ProviderName == providerName &&
                s.ProviderKey == providerKey)
            .OrderBy(x => x.Id)
            .FirstAsync(cancellationToken);
    }

    public virtual async Task<List<PermissionGrant>> GetListAsync(
        string providerName,
        string providerKey,
        CancellationToken cancellationToken = default)
    {
        return await base.Select
            .Where(s =>
                s.ProviderName == providerName &&
                s.ProviderKey == providerKey
            ).ToListAsync(cancellationToken);
    }

    public virtual async Task<List<PermissionGrant>> GetListAsync(string[] names, string providerName, string providerKey,
        CancellationToken cancellationToken = default)
    {
        return await base.Select
            .Where(s =>
                names.Contains(s.Name) &&
                s.ProviderName == providerName &&
                s.ProviderKey == providerKey
            ).ToListAsync(cancellationToken);
    }
}
