using Letu.Admin.Entities.System;
using Letu.Core.Interfaces;
using Letu.Repository;
using Letu.Shared.Keys;
using FreeRedis;

namespace Letu.Admin.SharedService
{
    public class ConfigSharedService : IScopedDependency
    {
        private readonly IRepository<ConfigDO> _configRepository;
        private readonly IRedisClient _redisClient;

        public ConfigSharedService(IRepository<ConfigDO> configRepository, IRedisClient redisClient)
        {
            _configRepository = configRepository;
            _redisClient = redisClient;
        }

        public async Task<string?> GetAsync(string key)
        {
            if (_redisClient.HExists(SystemCacheKey.SystemConfig, key))
            {
                return _redisClient.HGet(SystemCacheKey.SystemConfig, key);
            }

            string? value = await _configRepository.Select.Where(x => x.Key.ToLower() == key.ToLower()).ToOneAsync(e => e.Value);
            if (value != null)
            {
                await _redisClient.HSetAsync(SystemCacheKey.SystemConfig, key, value);
            }
            return value;
        }

        public async Task<Dictionary<string, string>> GetGroupAsync(string group)
        {
            string key = SystemCacheKey.SystemConfigGroup(group);
            if (_redisClient.Exists(key))
            {
                return await _redisClient.HGetAllAsync<string>(key);
            }

            var groupKeys = _configRepository.Select.Where(x => !string.IsNullOrEmpty(x.GroupKey) && x.GroupKey.ToLower() == group.ToLower())
                .ToDictionary(k => k.Key, v => v.Value);
            if (groupKeys.Count > 0)
            {
                await _redisClient.HSetAsync(key, groupKeys);
                return groupKeys;
            }
            return groupKeys;
        }

        public void ClearCache(string key)
        {
            _redisClient.HDel(SystemCacheKey.SystemConfig, key);
        }

        public void ClearGroupCache(string group)
        {
            string key = SystemCacheKey.SystemConfigGroup(group);
            _redisClient.Del(key);
        }
    }
}