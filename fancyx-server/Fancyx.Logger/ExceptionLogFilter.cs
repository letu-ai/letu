using DotNetCore.CAP;
using Fancyx.Logger.Message;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Fancyx.Logger.Consts;
using Fancyx.Logger.Options;
using Fancyx.Core.Utils;
using System.Diagnostics;

namespace Fancyx.Logger
{
    /// <summary>
    /// 异常日志收集（异常会继续往下传递，不标记已处理）
    /// </summary>
    public sealed class ExceptionLogFilter : IAsyncExceptionFilter
    {
        private readonly ICapPublisher _capPublisher;
        private readonly ILogger<ExceptionLogFilter> _logger;
        private readonly FancyxLoggerOption _options;

        public ExceptionLogFilter(ICapPublisher capPublisher, ILogger<ExceptionLogFilter> logger, IOptions<FancyxLoggerOption> options)
        {
            _capPublisher = capPublisher;
            _logger = logger;
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

                var msg = new ExceptionLogMessage()
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
                var currentUser = RequestUtils.ResolveUser(context.HttpContext);
                var currentTenant = RequestUtils.ResolveTenant(context.HttpContext);
                msg.UserId = currentUser?.Id;
                msg.UserName = currentUser?.UserName;
                msg.TenantId = currentTenant?.TenantId;

                await _capPublisher.PublishAsync(EventBusTopicConsts.EXCEPTION_LOG_EVENT, msg);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "异常日志收集失败");
            }
        }
    }
}