using DotNetCore.CAP;
using Letu.Shared.Consts;
using Letu.Basis.Admin.Loggings;

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
        public async Task WriteLoginLog(SecurityLog log)
        {
            await freeSql.Insert(log).ExecuteAffrowsAsync();
        }
    }
}