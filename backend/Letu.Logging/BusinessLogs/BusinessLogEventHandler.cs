using Letu.Core.Utils;
using UAParser.Interfaces;
using Volo.Abp.DependencyInjection;
using Volo.Abp.EventBus;

namespace Letu.Logging.BusinessLogs;

public class BusinessLogEventHandler : ILocalEventHandler<BusinessLogEto>, ITransientDependency
{
    private readonly IFreeSql freeSql;
    private readonly IUserAgentParser uaParser;

    public BusinessLogEventHandler(IFreeSql freeSql, IUserAgentParser uaParser)
    {
        this.freeSql = freeSql;
        this.uaParser = uaParser;
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
            Browser = uaParser.ClientInfo.Browser.ToString(),
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
