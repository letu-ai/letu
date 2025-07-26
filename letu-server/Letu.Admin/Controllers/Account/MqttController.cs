using Letu.Core.Helpers;
using FreeRedis;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Letu.Admin.Controllers.Account
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]/[action]")]
    public class MqttController : ControllerBase
    {
        private readonly IRedisClient redisDb;

        public MqttController(IRedisClient redisDb)
        {
            this.redisDb = redisDb;
        }

        [HttpPost]
        public async Task<AppResponse<MqttToken>> GetMqttTokenAsync(string code)
        {
            if (string.IsNullOrWhiteSpace(code)) throw new ArgumentNullException(nameof(code));

            var codeKey = $"MqttTokenCode:{code}";

            if (await redisDb.ExistsAsync(codeKey))
            {
                var ttl = await redisDb.TtlAsync(codeKey);
                if (ttl > 60)
                {
                    return Result.Data(new MqttToken { Token = redisDb.Get<string>(codeKey), Expired = TimeHelper.Instance.GetCurrentTimestamp() + ttl });
                }
            }

            var token = Guid.NewGuid().ToString();
            var expired = TimeHelper.Instance.GetCurrentTimestamp() + 3600;
            await redisDb.SetAsync($"MqttToken:{token}", expired, TimeSpan.FromHours(1));
            await redisDb.SetAsync(codeKey, token, TimeSpan.FromHours(1));
            return Result.Data(new MqttToken { Expired = expired, Token = token });
        }
    }

    public class MqttToken
    {
        public long Expired { get; set; }
        public string? Token { get; set; }
    }
}