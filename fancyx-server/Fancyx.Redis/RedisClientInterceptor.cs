using Fancyx.Core.Authorization;
using FreeRedis;

namespace Fancyx.Redis
{
    public class RedisClientInterceptor : IInterceptor
    {
        public void After(InterceptorAfterEventArgs args)
        {
        }

        public void Before(InterceptorBeforeEventArgs args)
        {
            string keyPrefix = MultiTenancyConsts.IsEnabled && !string.IsNullOrEmpty(TenantManager.Current) ? $"TENANT_{TenantManager.Current}:" : "";
            args.Command.Prefix(keyPrefix);
        }
    }
}