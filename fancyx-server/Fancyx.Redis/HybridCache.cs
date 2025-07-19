﻿
using System.Collections.Concurrent;
using System.Text.Json;
using System.Text.RegularExpressions;

using FreeRedis;

using Microsoft.Extensions.Caching.Memory;

namespace Fancyx.Redis
{
    internal class HybridCache : IHybridCache
    {
        private readonly IMemoryCache _memoryCache;
        private readonly IRedisClient _redisClient;
        private readonly TimeSpan _defaultExpiration;
        private readonly ConcurrentDictionary<string, byte> _cacheKeys = new();

        public HybridCache(
            IMemoryCache memoryCache,
            IRedisClient redisClient,
            TimeSpan? defaultExpiration = null)
        {
            _memoryCache = memoryCache;
            _redisClient = redisClient;
            _defaultExpiration = defaultExpiration ?? TimeSpan.FromDays(7);
        }

        public async Task<T> GetOrCreateAsync<T>(
            string key,
            Func<Task<T>> factory,
            TimeSpan? expiration = null,
            HybridCacheMode mode = HybridCacheMode.Both)
        {
            var value = await GetAsync<T>(key, mode);
            if (value != null)
            {
                return value;
            }

            value = await factory();
            await SetAsync(key, value, expiration, mode);
            return value;
        }

        public async Task<T?> GetAsync<T>(string key, HybridCacheMode mode = HybridCacheMode.Both)
        {
            // 先尝试从内存缓存获取
            if (mode == HybridCacheMode.MemoryOnly || mode == HybridCacheMode.Both)
            {
                if (_memoryCache.TryGetValue(key, out T? memoryValue))
                {
                    return memoryValue;
                }
            }

            // 如果内存缓存没有，尝试从Redis获取
            if (mode == HybridCacheMode.RedisOnly || mode == HybridCacheMode.Both)
            {
                var redisValue = await _redisClient.GetAsync(key);
                if (redisValue != null)
                {
                    var value = JsonSerializer.Deserialize<T>(redisValue);

                    // 如果模式是Both，将Redis的值写入内存缓存
                    if (mode == HybridCacheMode.Both)
                    {
                        var expiration = _defaultExpiration;
                        _memoryCache.Set(key, value, new MemoryCacheEntryOptions
                        {
                            AbsoluteExpirationRelativeToNow = expiration
                        });
                    }

                    return value;
                }
            }

            return default;
        }

        public async Task SetAsync<T>(string key, T value, TimeSpan? expiration = null, HybridCacheMode mode = HybridCacheMode.Both)
        {
            var actualExpiration = expiration ?? _defaultExpiration;

            // 存储顺序：先Redis，再内存
            if (mode == HybridCacheMode.RedisOnly || mode == HybridCacheMode.Both)
            {
                var redisValue = JsonSerializer.Serialize(value);
                await _redisClient.SetExAsync(key, (int)actualExpiration.TotalSeconds, redisValue);
            }

            if (mode == HybridCacheMode.MemoryOnly || mode == HybridCacheMode.Both)
            {
                _memoryCache.Set(key, value, new MemoryCacheEntryOptions
                {
                    AbsoluteExpirationRelativeToNow = actualExpiration
                });
            }

            _cacheKeys.TryAdd(key, 0);
        }

        public async Task RemoveAsync(string key, HybridCacheMode mode = HybridCacheMode.Both)
        {
            // 移除顺序：先内存，再Redis
            if (mode == HybridCacheMode.MemoryOnly || mode == HybridCacheMode.Both)
            {
                _memoryCache.Remove(key);
            }

            if (mode == HybridCacheMode.RedisOnly || mode == HybridCacheMode.Both)
            {
                await _redisClient.DelAsync(key);
            }

            _cacheKeys.Remove(key, out var _);
        }

        public async Task RemoveByPatternAsync(string pattern, HybridCacheMode mode = HybridCacheMode.Both)
        {
            var regex = new Regex(pattern, RegexOptions.Singleline | RegexOptions.Compiled | RegexOptions.IgnoreCase);
            var matches = _cacheKeys.Keys.Where(k => regex.IsMatch(k)).ToList();

            foreach (var key in matches)
            {
                await RemoveAsync(key, mode);
            }
        }

        public async Task<bool> ExistsAsync(string key, HybridCacheMode mode = HybridCacheMode.Both)
        {
            if (mode == HybridCacheMode.MemoryOnly || mode == HybridCacheMode.Both)
            {
                if (_memoryCache.TryGetValue(key, out _))
                {
                    return true;
                }
            }

            if (mode == HybridCacheMode.RedisOnly || mode == HybridCacheMode.Both)
            {
                return await _redisClient.ExistsAsync(key);
            }

            return false;
        }
    }
}