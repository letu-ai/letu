using FreeRedis;

namespace Fancyx.Redis
{
    public static class RedisExtension
    {
        public static async Task<string[]?> KeyPatternAsync(this IRedisClient database, string pattern)
        {
            return (string[])await database.EvalAsync("local res = redis.call('KEYS', @keypattern) return res");
        }

        public static async Task KeyDeleteByPatternAsync(this IRedisClient database, string pattern)
        {
            var keys = await database.KeyPatternAsync(pattern);
            if (keys != null)
            {
                foreach (var key in keys)
                {
                    await database.DelAsync(key);
                }
            }
        }
    }
}