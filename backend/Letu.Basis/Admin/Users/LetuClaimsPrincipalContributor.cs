using Letu.Repository;
using Microsoft.Extensions.Caching.Distributed;
using System.Security.Claims;
using System.Security.Principal;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Security.Claims;

namespace Letu.Basis.Admin.Users;

public class LetuClaimsPrincipalContributor : IAbpDynamicClaimsPrincipalContributor, ITransientDependency
{
    private const string UserClaimsCacheKeyPrefix = "user_claims:";
    private static readonly DistributedCacheEntryOptions CacheOptions = new()
    {
        AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(30)
    };

    public async Task ContributeAsync(AbpClaimsPrincipalContributorContext context)
    {
        var identity = context.ClaimsPrincipal.Identities.FirstOrDefault();
        if (identity == null)
            return;

        var userId = identity?.FindUserId();
        if (!userId.HasValue)
            return;

        var cache = context.ServiceProvider.GetRequiredService<IDistributedCache>();

        // 获取用户claims数据（按需获取数据库服务）
        var claimsData = await GetUserClaimsDataAsync(cache, context.ServiceProvider, userId.Value);
        if (claimsData == null)
            return;

        // 添加claims到身份标识
        AddClaimsToIdentity(identity!, claimsData.Value);
    }

    private async Task<(Guid? OrganizationUnitId, Guid? DepartmentId)?> GetUserClaimsDataAsync(IDistributedCache cache, IServiceProvider serviceProvider, Guid userId)
    {
        // 尝试从缓存获取
        var claimsData = await ReadFromCacheAsync(cache, userId);
        if (claimsData.HasValue)
            return claimsData;

        // 缓存未命中，才获取数据库服务
        var userService = serviceProvider.GetRequiredService<IFreeSqlRepository<User>>();

        // 从数据库查询
        var user = await userService.OneAsync(x => x.Id == userId);
        if (user == null)
            return null;

        claimsData = (user.OrganizationUnitId, user.DepartmentId);

        // 写入缓存
        await WriteToCacheAsync(cache, userId, claimsData.Value);

        return claimsData;
    }

    private async Task<(Guid? OrganizationUnitId, Guid? DepartmentId)?> ReadFromCacheAsync(IDistributedCache cache, Guid userId)
    {
        var cacheKey = $"{UserClaimsCacheKeyPrefix}{userId}";
        var cachedData = await cache.GetStringAsync(cacheKey);

        if (string.IsNullOrEmpty(cachedData))
            return null;

        try
        {
            var parts = cachedData.Split('|');
            if (parts.Length != 2)
                return null; // 缓存数据格式无效

            var organizationUnitId = string.IsNullOrEmpty(parts[0]) ? (Guid?)null : Guid.Parse(parts[0]);
            var departmentId = string.IsNullOrEmpty(parts[1]) ? (Guid?)null : Guid.Parse(parts[1]);

            return (organizationUnitId, departmentId);
        }
        catch
        {
            // 缓存数据损坏，返回null重新查询
            return null;
        }
    }

    private async Task WriteToCacheAsync(IDistributedCache cache, Guid userId, (Guid? OrganizationUnitId, Guid? DepartmentId) claimsData)
    {
        var cacheKey = $"{UserClaimsCacheKeyPrefix}{userId}";
        var cacheValue = $"{claimsData.OrganizationUnitId}|{claimsData.DepartmentId}";

        await cache.SetStringAsync(cacheKey, cacheValue, CacheOptions);
    }

    private static void AddClaimsToIdentity(ClaimsIdentity identity, (Guid? OrganizationUnitId, Guid? DepartmentId) claimsData)
    {
        // OrganizationUnitId
        if (claimsData.OrganizationUnitId.HasValue)
        {
            identity.AddClaim(new Claim("OrganizationUnitId", claimsData.OrganizationUnitId.ToString()!));
        }

        // DepartmentId
        if (claimsData.DepartmentId.HasValue)
        {
            identity.AddClaim(new Claim("DepartmentId", claimsData.DepartmentId.ToString()!));
        }
    }
}
