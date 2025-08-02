using Letu.Core.Utils;
using Letu.Logging.Message;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System.Diagnostics;
using System.Text.Json;
using Volo.Abp.EventBus.Local;
using Volo.Abp.MultiTenancy;
using Volo.Abp.Users;

namespace Letu.Logging;

public sealed class ApiAccessLogAttribute : ActionFilterAttribute
{
    public ApiAccessLogAttribute(string? operateName = default, OperateType[]? operateType = default, bool requestEnable = true, bool reponseEnable = false)
    {
        OperateName = operateName;
        OperateType = operateType;
        RequestEnable = requestEnable;
        ResponseEnable = reponseEnable;
    }

    public bool RequestEnable { get; init; } = true;

    public bool ResponseEnable { get; init; } = true;

    public OperateType[]? OperateType { get; init; }

    public string? OperateName { get; init; }

    public override async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
    {
        try
        {
            var msg = new ApiAccessLogEto()
            {
                Path = context.HttpContext.Request.Path,
                Method = context.HttpContext.Request.Method,
                RequestTime = DateTime.Now,
                OperateType = OperateType,
                OperateName = OperateName,
                TraceId = Activity.Current?.TraceId.ToString(),
                Ip = RequestUtils.GetIp(context.HttpContext),
                UserAgent = RequestUtils.GetUserAgent(context.HttpContext),
            };
            if (RequestEnable)
            {
                msg.RequestBody = JsonSerializer.Serialize(context.ActionArguments);
                msg.QueryString = context.HttpContext.Request.QueryString.Value;
            }
            var currentUser = context.HttpContext.RequestServices.GetRequiredService<ICurrentUser>();
            var currentTenant = context.HttpContext.RequestServices.GetRequiredService<ICurrentTenant>();
            msg.UserId = currentUser?.Id;
            msg.UserName = currentUser?.UserName;
            msg.TenantId = currentTenant?.Id;

            if (ResponseEnable)
            {
                context.HttpContext.Items.Add("ApiAccessLogEvent", msg);
            }
            else
            {
                await PushAsync(context.HttpContext, msg);
            }
        }
        catch (Exception ex)
        {
            var logger = context.HttpContext.RequestServices.GetService<ILogger<ApiAccessLogAttribute>>();
            logger?.LogError(ex, "API访问日志收集失败");
        }
        finally
        {
            await next();
        }
    }

    public override async Task OnResultExecutionAsync(ResultExecutingContext context, ResultExecutionDelegate next)
    {
        if (ResponseEnable)
        {
            bool hasMsg = context.HttpContext.Items.TryGetValue("ApiAccessLogEvent", out var msg);
            if (hasMsg && msg is ApiAccessLogEto apiAccessLogMsg)
            {
                var now = DateTime.Now;
                apiAccessLogMsg.ResponseTime = now;
                apiAccessLogMsg.Duration = (long)Math.Round(now.Subtract(apiAccessLogMsg.RequestTime).TotalMilliseconds);
                apiAccessLogMsg.ResponseBody = StringUtils.CutOff(JsonSerializer.Serialize(context.Result), 500);
                await PushAsync(context.HttpContext, apiAccessLogMsg);
            }
        }
        await next();
    }

    private async Task PushAsync(HttpContext httpContext, ApiAccessLogEto msg)
    {
        var eventBus = httpContext.RequestServices.GetRequiredService<ILocalEventBus>();
        await eventBus.PublishAsync(msg);
    }
}