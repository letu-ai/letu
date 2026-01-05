using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Options;
using System.Collections.Concurrent;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Timing;

namespace Letu.Basis.UserSessions;

/// <summary>
/// 用户会话活动时间记录服务
/// </summary>
public class UserSessionActivityService : ISingletonDependency
{
    private readonly IMemoryCache memoryCache;
    private readonly IClock clock;
    private readonly UserSessionActivityOptions options;
    private readonly ConcurrentDictionary<Guid, DateTime> pendingUpdates;
    private readonly Lock locker = new();

    public UserSessionActivityService(
        IMemoryCache memoryCache,
        IClock clock,
        IOptions<UserSessionActivityOptions> options)
    {
        this.memoryCache = memoryCache;
        this.clock = clock;
        this.options = options.Value;
        this.pendingUpdates = new ConcurrentDictionary<Guid, DateTime>();
    }

    /// <summary>
    /// 记录会话活动时间
    /// </summary>
    /// <param name="sessionId">会话ID</param>
    public Task RecordActivityAsync(Guid sessionId)
    {
        var now = clock.Now;
        // 精确到分钟
        var activityTime = now.AddSeconds(-now.Second);

        var cacheKey = GetCacheKey(sessionId);
        var minuteKey = GetMinuteKey(sessionId, activityTime);

        // 使用锁确保同一分钟内同一session只记录一次
        using (locker.EnterScope())
        {
            // 检查是否已经记录过这个分钟的活动时间
            if (memoryCache.TryGetValue(minuteKey, out _))
            {
                return Task.CompletedTask;
            }

            // 记录到缓存
            var cacheOptions = new MemoryCacheEntryOptions
            {
                AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(options.CacheExpirationMinutes)
            };
            memoryCache.Set(cacheKey, activityTime, cacheOptions);

            // 记录分钟键，防止同一分钟内重复记录
            memoryCache.Set(minuteKey, true, TimeSpan.FromMinutes(1));

            // 添加到待更新集合
            pendingUpdates.AddOrUpdate(sessionId, activityTime, (key, oldValue) => activityTime);
        }

        return Task.CompletedTask;
    }

    /// <summary>
    /// 获取待更新的会话ID列表及其活动时间
    /// </summary>
    public Task<Dictionary<Guid, DateTime>> GetPendingUpdatesAsync()
    {
        var result = new Dictionary<Guid, DateTime>();

        foreach (var kvp in pendingUpdates)
        {
            var sessionId = kvp.Key;
            var cacheKey = GetCacheKey(sessionId);

            // 从缓存中获取活动时间
            if (memoryCache.TryGetValue(cacheKey, out DateTime activityTime))
            {
                result[sessionId] = activityTime;
            }
        }

        return Task.FromResult(result);
    }

    /// <summary>
    /// 清除已处理的会话ID
    /// </summary>
    public void ClearProcessed(IEnumerable<Guid> sessionIds)
    {
        foreach (var sessionId in sessionIds)
        {
            var cacheKey = GetCacheKey(sessionId);
            memoryCache.Remove(cacheKey);
            pendingUpdates.TryRemove(sessionId, out _);
        }
    }

    private static string GetCacheKey(Guid sessionId)
    {
        return $"user-session-activity:{sessionId}";
    }

    private static string GetMinuteKey(Guid sessionId, DateTime activityTime)
    {
        var minuteStr = activityTime.ToString("yyyy-MM-dd HH:mm");
        return $"user-session-activity-lock:{sessionId}:{minuteStr}";
    }
}

