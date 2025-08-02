using FreeSql;
using System.Reflection;
using Volo.Abp.DependencyInjection;
using Volo.Abp.DynamicProxy;
using UnitOfWorkAttribute = Volo.Abp.Uow.UnitOfWorkAttribute;

namespace Letu.Repository;

public class UnitOfWorkInterceptor : AbpInterceptor, ITransientDependency
{
    private readonly UnitOfWorkManager uowManager;

    public UnitOfWorkInterceptor(
        UnitOfWorkManager uowManager)
    {
        this.uowManager = uowManager;
    }

    public async override Task InterceptAsync(IAbpMethodInvocation invocation)
    {
        var uowAttribute = invocation.Method.GetCustomAttribute<UnitOfWorkAttribute>();
        if (uowAttribute == null)
        {
            await invocation.ProceedAsync();
            return;
        }

        await ProcessAsync(invocation, uowAttribute);
    }

    private async Task ProcessAsync(IAbpMethodInvocation invocation, UnitOfWorkAttribute operationLogAttribute)
    {
        using var uow = uowManager.Begin( isolationLevel: operationLogAttribute.IsolationLevel);
        try
        {
            await invocation.ProceedAsync(); // 执行实际方法
            uow.Commit(); // 提交事务
        }
        catch
        {
            uow.Rollback();
            throw;
        }
    }
}
