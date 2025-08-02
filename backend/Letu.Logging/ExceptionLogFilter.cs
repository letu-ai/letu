using Letu.Core.Utils;
using Letu.Logging.Message;
using Letu.Logging.Options;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.Diagnostics;
using Volo.Abp.EventBus.Local;
using Volo.Abp.MultiTenancy;
using Volo.Abp.Users;

namespace Letu.Logging
{
    /// <summary>
    /// 异常日志收集（异常会继续往下传递，不标记已处理）
    /// </summary>
    public sealed class ExceptionLogFilter : IAsyncExceptionFilter
    {
        private readonly ILogger<ExceptionLogFilter> _logger;
        private readonly ILocalEventBus localEventBus;
        private readonly LetuLoggingOption _options;

        public ExceptionLogFilter(ILogger<ExceptionLogFilter> logger, IOptions<LetuLoggingOption> options, ILocalEventBus localEventBus)
        {
            _logger = logger;
            this.localEventBus = localEventBus;
            _options = options.Value;
        }

        public async Task OnExceptionAsync(ExceptionContext context)
        {
            try
            {
                var exceptionType = context.Exception.GetType();
                if (_options.IgnoreExceptionTypes != null && _options.IgnoreExceptionTypes.Contains(exceptionType))
                {
                    // 忽略指定的异常类型
                    return;
                }

                var msg = new ExceptionLogEto()
                {
                    ExceptionType = exceptionType.FullName ?? exceptionType.Name,
                    Message = context.Exception.Message,
                    StackTrace = context.Exception.StackTrace ?? string.Empty,
                    InnerException = context.Exception.InnerException?.Message,
                    RequestPath = context.HttpContext.Request.Path,
                    RequestMethod = context.HttpContext.Request.Method,
                    TraceId = Activity.Current?.TraceId.ToString(),
                    Ip = RequestUtils.GetIp(context.HttpContext),
                    UserAgent = RequestUtils.GetUserAgent(context.HttpContext)
                };
                var currentUser = context.HttpContext.RequestServices.GetRequiredService<ICurrentUser>();
                var currentTenant = context.HttpContext.RequestServices.GetRequiredService<ICurrentTenant>();
                msg.UserId = currentUser?.Id;
                msg.UserName = currentUser?.UserName;
                msg.TenantId = currentTenant?.Id;

                await localEventBus.PublishAsync(msg);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "异常日志收集失败");
            }
        }
    }
}