using Volo.Abp.DependencyInjection;
using Volo.Abp.DynamicProxy;
using Volo.Abp.Uow;

namespace Letu.Repository;

public static class UnitOfWorkInterceptorRegistrar
{
    public static void RegisterIfNeeded(IOnServiceRegistredContext context)
    {
        if (ShouldIntercept(context.ImplementationType))
        {
            context.Interceptors.TryAdd<UnitOfWorkInterceptor>();
        }
    }

    private static bool ShouldIntercept(Type type)
    {
        if (DynamicProxyIgnoreTypes.Contains(type))
        {
            return false;
        }

        if (type.GetMethods().Any(m => m.IsDefined(typeof(UnitOfWorkAttribute), true)))
        {
            return true;
        }

        return false;
    }
}
