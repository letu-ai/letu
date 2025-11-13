using System.Diagnostics;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Threading;

namespace Letu.Logging.BusinessLogs;

public class BusinessLogManager : IBusinessLogManager, ITransientDependency
{

    private const string AmbientContextKey = "Letu.Logging.IOperationLogScope";

    private readonly IAmbientScopeProvider<IBusinessLogScope> ambientScopeProvider;

    public BusinessLogManager(IAmbientScopeProvider<IBusinessLogScope> ambientScopeProvider)
    {

        this.ambientScopeProvider = ambientScopeProvider;
    }

    public IBusinessLogScope? Current => ambientScopeProvider.GetValue(AmbientContextKey);

    public IDisposable BeginScope()
    {
        var ambientScope = ambientScopeProvider.BeginScope(
            AmbientContextKey,
            new OperationLogScope()
        );

        Debug.Assert(Current != null, "Current != null");

        return new ScopeTerminator(ambientScope);
    }

    private class ScopeTerminator : IDisposable
    {
        private readonly IDisposable scope;

        public ScopeTerminator(IDisposable scope)
        {
            this.scope = scope;
        }

        public void Dispose()
        {
            scope.Dispose();
        }
    }
}
