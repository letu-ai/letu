using System.Collections.Concurrent;

namespace Letu.Logging.BusinessLogs;

public class BusinessLogScope : IBusinessLogScope
{
    private readonly ConcurrentDictionary<string, object> items;

    public BusinessLogScope()
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