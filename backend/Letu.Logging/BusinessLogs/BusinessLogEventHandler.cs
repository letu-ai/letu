using Letu.Core.Utils;
using Volo.Abp.DependencyInjection;
using Volo.Abp.EventBus;

namespace Letu.Logging.BusinessLogs;

public class BusinessLogEventHandler : ILocalEventHandler<BusinessLogEto>, ITransientDependency
{
    private readonly IFreeSql freeSql;

    public BusinessLogEventHandler(IFreeSql freeSql)
    {
        this.freeSql = freeSql;
    }

    public async Task HandleEventAsync(BusinessLogEto message)
    {
        var entity = new BusinessLog
        {
            Type = message.Type,
            SubType = message.SubType,
            BizNo = message.EntityId,
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
