using Letu.Logging.SecurtyLogs;
using Volo.Abp.DependencyInjection;
using Volo.Abp.EventBus;

namespace Letu.Basis.Identity
{
    public class SecurityLogEventHandler : ILocalEventHandler<SecurityLog>, ITransientDependency
    {
        private readonly IFreeSql freeSql;

        public SecurityLogEventHandler(IFreeSql freeSql)
        {
            this.freeSql = freeSql;
        }

        public async Task HandleEventAsync(SecurityLog eventData)
        {
            await freeSql.Insert(eventData).ExecuteAffrowsAsync();
        }
    }
}