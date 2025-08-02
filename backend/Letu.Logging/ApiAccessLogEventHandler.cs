using Letu.Core.Utils;
using Letu.Logging.Entities;
using Letu.Logging.Message;
using Volo.Abp.DependencyInjection;
using Volo.Abp.EventBus;

namespace Letu.Logging;

public class ApiAccessLogEventHandler : ILocalEventHandler<ApiAccessLogEto>, ITransientDependency
{
    private readonly IFreeSql freeSql;

    public ApiAccessLogEventHandler(IFreeSql freeSql)
    {
        this.freeSql = freeSql;
    }

    public async Task HandleEventAsync(ApiAccessLogEto message)
    {
        var entity = new ApiAccessLog
        {
            Path = message.Path,
            Method = message.Method,
            RequestTime = message.RequestTime,
            OperateType = message.OperateType,
            OperateName = message.OperateName,
            QueryString = message.QueryString,
            RequestBody = message.RequestBody,
            ResponseBody = message.ResponseBody,
            ResponseTime = message.ResponseTime,
            Duration = message.Duration,
            Ip = message.Ip,
            Browser = RequestUtils.ResolveBrowser(message.UserAgent),
            UserId = message.UserId,
            UserName = message.UserName,
            TraceId = message.TraceId,
            //CreatorId = message.UserId,
            TenantId = message.TenantId,
        };

        await freeSql.Insert(entity).ExecuteAffrowsAsync();
    }
}
