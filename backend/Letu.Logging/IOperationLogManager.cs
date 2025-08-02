namespace Letu.Logging;

public interface IOperationLogManager
{
    IOperationLogScope? Current { get; }

    IDisposable BeginScope();
}
