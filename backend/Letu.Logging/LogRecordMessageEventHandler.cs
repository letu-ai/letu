using Letu.Core.Utils;
using Letu.Logging.Entities;
using Letu.Logging.Message;
using Volo.Abp.DependencyInjection;
using Volo.Abp.EventBus;

namespace Letu.Logging;

public class LogRecordMessageEventHandler : ILocalEventHandler<LogRecordEto>, ITransientDependency
{
    private readonly IFreeSql freeSql;

    public LogRecordMessageEventHandler(IFreeSql freeSql)
    {
        this.freeSql = freeSql;
    }

    public async Task HandleEventAsync(LogRecordEto message)
    {
        var entity = new LogRecord
        {
            Type = message.Type,
            SubType = message.SubType,
            BizNo = message.BizNo,
            Content = message.Content,
            Ip = message.Ip,
            Browser = RequestUtils.ResolveBrowser(message.UserAgent),
            UserId = message.UserId,
            UserName = message.UserName,
            TraceId = message.TraceId,
            //CreatorId = message.UserId,
            TenantId = message.TenantId,
            //CreationTime = message.CreationTime
        };

        await freeSql.Insert(entity).ExecuteAffrowsAsync();
    }
}
