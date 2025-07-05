using Fancyx.Core.AutoInject;
using FreeRedis;
using Microsoft.Extensions.DependencyInjection;
using Newtonsoft.Json;
using RedLockNet.SERedis.Configuration;
using RedLockNet.SERedis;
using StackExchange.Redis;
using Fancyx.Core.Context;

namespace Fancyx.Redis
{
    public class FancyxRedisModule : ModuleBase
    {
        public override void Configure(ApplicationInitializationContext context)
        {
        }

        public override void ConfigureServices(ServiceConfigurationContext context)
        {
            //FreeRedis
            var redisClient = new RedisClient((ConnectionStringBuilder)context.Configuration["Redis:Connection"])
            {
                Serialize = obj => JsonConvert.SerializeObject(obj),
                Deserialize = (json, type) => JsonConvert.DeserializeObject(json, type)
            };
            redisClient.Interceptors.Add(() => new RedisClientInterceptor());
            context.Services.AddSingleton<IRedisClient>(sp => redisClient);

            //RedLock
            var multiplexers = new List<RedLockMultiplexer>
            {
                ConnectionMultiplexer.Connect(context.Configuration["Redis:Connection"]!)
            };
            context.Services.AddSingleton<RedLockFactory>(RedLockFactory.Create(multiplexers));
        }
    }
}