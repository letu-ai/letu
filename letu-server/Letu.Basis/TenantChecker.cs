using Letu.Basis.Entities.System;
using Letu.Core.Interfaces;
using Letu.Repository;
using Letu.Shared.Keys;
using FreeRedis;

namespace Letu.Basis
{
    public class TenantChecker : ITenantChecker, ISingletonDependency
    {
        private readonly IRepository<TenantDO> tenantRepository;
        private readonly IRedisClient redisClient;

        public TenantChecker(IRepository<TenantDO> tenantRepository, IRedisClient redisClient)
        {
            this.tenantRepository = tenantRepository;
            this.redisClient = redisClient;
        }

        public async Task<bool> ExistTenantAsync(string tenantId)
        {
            if (await redisClient.ExistsAsync(SystemCacheKey.AllTenant)) return await redisClient.HExistsAsync(SystemCacheKey.AllTenant, tenantId);

            var tenants = await tenantRepository.Select.ToListAsync(x => new { x.TenantId, x.Name });
            var map = tenants.ToDictionary(k => k.TenantId, v => v.Name);
            if (map.Count == 0) return false;

            await redisClient.HSetAsync(SystemCacheKey.AllTenant, map);
            return map.ContainsKey(tenantId);
        }
    }
}