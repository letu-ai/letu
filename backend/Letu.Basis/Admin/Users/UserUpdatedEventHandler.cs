using Microsoft.Extensions.Caching.Distributed;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Domain.Entities.Events.Distributed;
using Volo.Abp.EventBus.Distributed;

namespace Letu.Basis.Admin.Users;

public class UserUpdatedEventHandler :
    IDistributedEventHandler<EntityUpdatedEto<UserEto>>,
    ITransientDependency
{
    private const string UserClaimsCacheKeyPrefix = "user_claims:";

    protected IDistributedCache DistributedCache { get; }

    public UserUpdatedEventHandler(IDistributedCache distributedCache)
    {
        DistributedCache = distributedCache;
    }

    public async Task HandleEventAsync(EntityUpdatedEto<UserEto> eventData)
    {
        // 清除该用户的claims缓存
        var cacheKey = $"{UserClaimsCacheKeyPrefix}{eventData.Entity.Id}";
        await DistributedCache.RemoveAsync(cacheKey);
    }
}