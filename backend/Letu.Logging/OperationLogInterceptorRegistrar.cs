using Volo.Abp.DependencyInjection;
using Volo.Abp.DynamicProxy;

namespace Letu.Logging;

public static class OperationLogInterceptorRegistrar
{
    public static void RegisterIfNeeded(IOnServiceRegistredContext context)
    {
        if (ShouldIntercept(context.ImplementationType))
        {
            context.Interceptors.TryAdd<OperationLogInterceptor>();
        }
    }

    private static bool ShouldIntercept(Type type)
    {
        if (DynamicProxyIgnoreTypes.Contains(type))
        {
            return false;
        }

        if (type.GetMethods().Any(m => m.IsDefined(typeof(OperationLogAttribute), true)))
        {
            return true;
        }

        return false;
    }
}
