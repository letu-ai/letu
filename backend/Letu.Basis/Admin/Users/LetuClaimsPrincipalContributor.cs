using Letu.Repository;
using Letu.Basis.Admin.UserTags;
using Microsoft.Extensions.Caching.Distributed;
using System;
using System.Linq;
using System.Security.Claims;
using System.Security.Principal;
using Volo.Abp.Caching;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Security.Claims;

namespace Letu.Basis.Admin.Users;

public partial class LetuClaimsPrincipalContributor : IAbpDynamicClaimsPrincipalContributor, ITransientDependency
{
    private const string UserClaimsCacheKeyPrefix = "user_claims:";
    private static readonly DistributedCacheEntryOptions cacheOptions = new()
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

        var cache = context.ServiceProvider.GetRequiredService<IDistributedCache<UserExtraClaims>>();

        // 获取用户claims数据（按需获取数据库服务）
        var claimsData = await GetUserExtraClaimsAsync(cache, context.ServiceProvider, userId.Value);
        if (claimsData == null)
            return;

        // 添加claims到身份标识
        AddClaimsToIdentity(identity!, claimsData);
    }

    private async Task<UserExtraClaims?> GetUserExtraClaimsAsync(IDistributedCache<UserExtraClaims> cache, IServiceProvider serviceProvider, Guid userId)
    {
        // 尝试从缓存获取
        var claimsData = await ReadFromCacheAsync(cache, userId);
        if (claimsData != null)
            return claimsData;

        // 缓存未命中，才获取数据库服务
        var userRepository = serviceProvider.GetRequiredService<IFreeSqlRepository<User>>();
        var userTagRepository = serviceProvider.GetRequiredService<IFreeSqlRepository<UserInTag>>();
        var tagRepository = serviceProvider.GetRequiredService<IFreeSqlRepository<UserTag>>();

        // 从数据库查询
        var user = await userRepository.OneAsync(x => x.Id == userId);
        if (user == null)
            return null;

        var userTags = await GetUserTagNamesAsync(userTagRepository, tagRepository, userId);

        claimsData = new UserExtraClaims
        {
            OrganizationUnitId = user.OrganizationUnitId,
            DepartmentId = user.DepartmentId,
            Tags = userTags
        };

        // 写入缓存
        await WriteToCacheAsync(cache, userId, claimsData);

        return claimsData;
    }

    private async Task<UserExtraClaims?> ReadFromCacheAsync(IDistributedCache<UserExtraClaims> cache, Guid userId)
    {
        var cacheKey = $"{UserClaimsCacheKeyPrefix}{userId}";
        return await cache.GetAsync(cacheKey);
    }

    private async Task WriteToCacheAsync(IDistributedCache<UserExtraClaims> cache, Guid userId, UserExtraClaims claimsData)
    {
        var cacheKey = $"{UserClaimsCacheKeyPrefix}{userId}";
        await cache.SetAsync(cacheKey, claimsData, cacheOptions);
    }

    private static async Task<string[]> GetUserTagNamesAsync(
        IFreeSqlRepository<UserInTag> userTagRepository,
        IFreeSqlRepository<UserTag> tagRepository,
        Guid userId)
    {
        var tagIds = await userTagRepository
            .Where(x => x.UserId == userId)
            .ToListAsync(x => x.TagId);

        if (tagIds == null || tagIds.Count == 0)
        {
            return Array.Empty<string>();
        }

        var tagNames = await tagRepository
            .Where(x => tagIds.Contains(x.Id))
            .ToListAsync(x => x.Name);

        return tagNames?
            .Where(name => !string.IsNullOrWhiteSpace(name))
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToArray()
            ?? Array.Empty<string>();
    }

    private static void AddClaimsToIdentity(ClaimsIdentity identity, UserExtraClaims claimsData)
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

        if (claimsData.Tags.Length > 0)
        {
            foreach (var tag in claimsData.Tags)
            {
                if (!string.IsNullOrWhiteSpace(tag))
                {
                    identity.AddClaim(new Claim("UserTag", tag));
                }
            }
        }
    }
}
