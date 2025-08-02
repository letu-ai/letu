using System.Diagnostics;
using Volo.Abp.DependencyInjection;
using Volo.Abp.Threading;

namespace Letu.Logging;

public class OperationLogManager : IOperationLogManager, ITransientDependency
{

    private const string AmbientContextKey = "Letu.Logging.IOperationLogScope";

    private readonly IAmbientScopeProvider<IOperationLogScope> ambientScopeProvider;

    public OperationLogManager(IAmbientScopeProvider<IOperationLogScope> ambientScopeProvider)
    {

        this.ambientScopeProvider = ambientScopeProvider;
    }

    public IOperationLogScope? Current => ambientScopeProvider.GetValue(AmbientContextKey);

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
