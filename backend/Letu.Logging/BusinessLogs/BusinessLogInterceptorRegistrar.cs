using Volo.Abp.DependencyInjection;
using Volo.Abp.DynamicProxy;

namespace Letu.Logging.BusinessLogs;

public static class BusinessLogInterceptorRegistrar
{
    public static void RegisterIfNeeded(IOnServiceRegistredContext context)
    {
        if (ShouldIntercept(context.ImplementationType))
        {
            context.Interceptors.TryAdd<BusinessLogInterceptor>();
        }
    }

    private static bool ShouldIntercept(Type type)
    {
        if (DynamicProxyIgnoreTypes.Contains(type))
        {
            return false;
        }

        if (type.GetMethods().Any(m => m.IsDefined(typeof(BusinessLogAttribute), true)))
        {
            return true;
        }

        return false;
    }
}
