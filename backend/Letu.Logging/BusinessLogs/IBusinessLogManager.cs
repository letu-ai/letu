namespace Letu.Logging.BusinessLogs;

public interface IBusinessLogManager
{
    IBusinessLogScope? Current { get; }

    IDisposable BeginScope();
}
