using DotNetCore.CAP;
using Fancyx.Shared.Consts;
using Fancyx.Admin.Entities.System;

namespace Fancyx.Admin.Subscribers
{
    public class CapEventSubscriber : ICapSubscribe
    {
        private readonly IFreeSql freeSql;

        public CapEventSubscriber(IFreeSql freeSql)
        {
            this.freeSql = freeSql;
        }

        [CapSubscribe(AdminEventBusTopicConsts.LoginLogEvent)]
        public async Task WriteLoginLog(LoginLogDO log)
        {
            await freeSql.Insert(log).ExecuteAffrowsAsync();
        }
    }
}