using System.Collections.Concurrent;

namespace Letu.Logging;

public class OperationLogScope : IOperationLogScope
{
    private readonly ConcurrentDictionary<string, object> items;

    public OperationLogScope()
    {
        items = new ConcurrentDictionary<string, object>();
    }

    public void AddVariable(string name, object value)
    {
        items.AddOrUpdate(name, value, (_, _) => value);
    }

    public IDictionary<string, object>? GetVariables()
    {
        return items;
    }
}