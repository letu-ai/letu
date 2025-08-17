using Letu.Repository;
using Volo.Abp;
using Volo.Abp.Caching;
using Volo.Abp.DependencyInjection;
using Volo.Abp.MultiTenancy;
using Volo.Abp.ObjectMapping;

namespace Letu.Basis.Admin.Tenants;

public class TenantStore : ITenantStore, ITransientDependency
{
    private readonly IFreeSqlRepository<Tenant> tenantRepository;
    private readonly IObjectMapper<LetuBasisModule> objectMapper;
    private readonly ICurrentTenant currentTenant;
    private readonly IDistributedCache<TenantConfigurationCacheItem> cache;

    public TenantStore(
        IFreeSqlRepository<Tenant> tenantRepository,
        IObjectMapper<LetuBasisModule> objectMapper,
        ICurrentTenant currentTenant,
        IDistributedCache<TenantConfigurationCacheItem> cache)
    {
        this.tenantRepository = tenantRepository;
        this.objectMapper = objectMapper;
        this.currentTenant = currentTenant;
        this.cache = cache;
    }

    public virtual async Task<TenantConfiguration?> FindAsync(string normalizedName)
    {
        return (await GetCacheItemAsync(null, normalizedName)).Value;
    }

    public virtual async Task<TenantConfiguration?> FindAsync(Guid id)
    {
        return (await GetCacheItemAsync(id, null)).Value;
    }

    public virtual async Task<IReadOnlyList<TenantConfiguration>> GetListAsync(bool includeDetails = false)
    {
        return objectMapper.Map<List<Tenant>, List<TenantConfiguration>>(
            await tenantRepository.Select.ToListAsync());
    }

    [Obsolete("Use FindAsync method.", error: true)]
    public virtual TenantConfiguration? Find(string normalizedName)
    {
        throw new NotImplementedException("请使用FindAsync方法");
    }

    [Obsolete("Use FindAsync method.", error: true)]
    public virtual TenantConfiguration? Find(Guid id)
    {
        throw new NotImplementedException("请使用FindAsync方法");
    }

    protected virtual async Task<TenantConfigurationCacheItem> GetCacheItemAsync(Guid? id, string? normalizedName)
    {
        var cacheKey = CalculateCacheKey(id, normalizedName);

        var cacheItem = await cache.GetAsync(cacheKey, considerUow: true);
        if (cacheItem?.Value != null)
        {
            return cacheItem;
        }

        if (id.HasValue)
        {
            using (currentTenant.Change(null)) //TODO: No need this if we can implement to define host side (or tenant-independent) entities!
            {
                var tenant = await tenantRepository.Where(x => x.Id == id.Value).FirstAsync();
                return await SetCacheAsync(cacheKey, tenant);
            }
        }

        if (!normalizedName.IsNullOrWhiteSpace())
        {
            using (currentTenant.Change(null)) //TODO: No need this if we can implement to define host side (or tenant-independent) entities!
            {
                var tenant = await tenantRepository.Where(x => x.Name == normalizedName).FirstAsync();
                return await SetCacheAsync(cacheKey, tenant);
            }
        }

        throw new AbpException("Both id and normalizedName can't be invalid.");
    }

    private async Task<TenantConfigurationCacheItem> SetCacheAsync(string cacheKey, Tenant? tenant)
    {
        var tenantConfiguration = tenant != null ? objectMapper.Map<Tenant, TenantConfiguration>(tenant) : null;
        var cacheItem = new TenantConfigurationCacheItem(tenantConfiguration);
        await cache.SetAsync(cacheKey, cacheItem, considerUow: true);
        return cacheItem;
    }

    private string CalculateCacheKey(Guid? id, string? normalizedName)
    {
        return TenantConfigurationCacheItem.CalculateCacheKey(id, normalizedName);
    }
}
