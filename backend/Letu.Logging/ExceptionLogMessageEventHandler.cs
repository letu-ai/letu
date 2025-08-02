using Letu.Core.Utils;
using Letu.Logging.Entities;
using Letu.Logging.Message;
using Volo.Abp.DependencyInjection;
using Volo.Abp.EventBus;

namespace Letu.Logging;

public class ExceptionLogMessageEventHandler : ILocalEventHandler<ExceptionLogEto>, ITransientDependency
{
    private readonly IFreeSql freeSql;

    public ExceptionLogMessageEventHandler(IFreeSql freeSql)
    {
        this.freeSql = freeSql;
    }

    public async Task HandleEventAsync(ExceptionLogEto message)
    {
        var entity = new ExceptionLog
        {
            RequestPath = message.RequestPath,
            RequestMethod = message.RequestMethod,
            ExceptionType = message.ExceptionType,
            Message = message.Message,
            StackTrace = message.StackTrace,
            InnerException = message.InnerException,
            Ip = message.Ip,
            Browser = RequestUtils.ResolveBrowser(message.UserAgent),
            UserId = message.UserId,
            UserName = message.UserName,
            TraceId = message.TraceId,
            //CreatorId = message.UserId,
            TenantId = message.TenantId
        };

        await freeSql.Insert(entity).ExecuteAffrowsAsync();
    }
}