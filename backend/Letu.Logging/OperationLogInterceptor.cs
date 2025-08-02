using Letu.Core.Utils;
using Letu.Logging.Message;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System.Diagnostics;
using System.Reflection;
using Volo.Abp.DependencyInjection;
using Volo.Abp.DynamicProxy;
using Volo.Abp.EventBus.Local;
using Volo.Abp.MultiTenancy;
using Volo.Abp.Users;

namespace Letu.Logging;

public class OperationLogInterceptor : AbpInterceptor, ITransientDependency
{
    private readonly IServiceScopeFactory serviceScopeFactory;
    private readonly IHttpContextAccessor? httpContextAccessor;
    private readonly ILocalEventBus localEventBus;
    private readonly ICurrentTenant currentTenant;
    private ILogger<OperationLogInterceptor> logger;

    public OperationLogInterceptor(
        IServiceScopeFactory serviceScopeFactory,
        IHttpContextAccessor? httpContextAccessor,
        ILocalEventBus localEventBus,
        ICurrentTenant currentTenant,
        ILogger<OperationLogInterceptor> logger)
    {
        this.serviceScopeFactory = serviceScopeFactory;
        this.httpContextAccessor = httpContextAccessor;
        this.localEventBus = localEventBus;
        this.currentTenant = currentTenant;
        this.logger = logger;
    }

    public async override Task InterceptAsync(IAbpMethodInvocation invocation)
    {
        var operationLogAttribute = invocation.Method.GetCustomAttribute<OperationLogAttribute>();
        if (operationLogAttribute == null)
        {
            await invocation.ProceedAsync();
            return;
        }

        using var serviceScope = serviceScopeFactory.CreateScope();
        var logManager = serviceScope.ServiceProvider.GetRequiredService<IOperationLogManager>();

        if (logManager.Current != null)
        {
            await ProcessAsync(invocation, logManager, operationLogAttribute);
        }
        else
        {
            using var logScope = logManager.BeginScope();
            await ProcessAsync(invocation, logManager, operationLogAttribute);
        }
    }

    private async Task ProcessAsync(IAbpMethodInvocation invocation, IOperationLogManager logManager, OperationLogAttribute operationLogAttribute)
    {
        var stopwatch = Stopwatch.StartNew();
        try
        {
            stopwatch.Reset();
            await invocation.ProceedAsync(); // 执行实际方法
        }
        catch (Exception ex)
        {
            stopwatch.Stop();
            await AfterAsync(logManager, operationLogAttribute, stopwatch.ElapsedMilliseconds, ex);
            throw;
        }
        stopwatch.Stop();

        await AfterAsync(logManager, operationLogAttribute, stopwatch.ElapsedMilliseconds);

    }

    private async Task AfterAsync(IOperationLogManager logManager, OperationLogAttribute operationLogAttribute, long duration, Exception? exception = null)
    {
        var msg = new LogRecordEto();
        try
        {
            var map = logManager.Current?.GetVariables();
            msg.Type = TemplateUtils.Render(operationLogAttribute.Type!, map);
            msg.SubType = TemplateUtils.Render(operationLogAttribute.SubType!, map);
            msg.BizNo = TemplateUtils.Render(operationLogAttribute.BizNo!, map);
            msg.Content = TemplateUtils.Render(operationLogAttribute.Content!, map);
            msg.CreationTime = DateTime.Now;
            msg.Duration = duration;
            var httpContext = httpContextAccessor?.HttpContext;
            if (httpContext != null)
            {
                var currentUser = httpContext.RequestServices.GetRequiredService<ICurrentUser>();
                msg.UserId = currentUser.Id;
                msg.UserName = currentUser.UserName;
                msg.TenantId = currentTenant.Id;
                msg.Ip = RequestUtils.GetIp(httpContext);
                msg.UserAgent = RequestUtils.GetUserAgent(httpContext);
                msg.TraceId = Activity.Current?.TraceId.ToString();
            }
            await localEventBus.PublishAsync(msg);
        }
        catch (Exception ex)
        {
            logger?.LogError(ex, "操作日志[{type}]发布异常", msg.Type);
        }
    }
}
