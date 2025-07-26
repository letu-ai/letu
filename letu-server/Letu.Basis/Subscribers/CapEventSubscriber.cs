using DotNetCore.CAP;
using Letu.Shared.Consts;
using Letu.Basis.Entities.System;

namespace Letu.Basis.Subscribers
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