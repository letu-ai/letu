namespace Letu.Logging.BusinessLogs;

public interface IBusinessLogScope
{
    void AddVariable(string name, object value);
    IDictionary<string, object>? GetVariables();
}
