namespace Letu.Logging;

public interface IOperationLogScope
{
    void AddVariable(string name, object value);
    IDictionary<string, object>? GetVariables();
}
