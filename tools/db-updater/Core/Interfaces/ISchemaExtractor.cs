using DbCompareTool.Config;
using DbCompareTool.Core.Models;

namespace DbCompareTool.Core.Interfaces;

public interface ISchemaExtractor
{
    Task<DatabaseSchema> ExtractAsync(ConnectionConfig connection, FilterConfig filter, CancellationToken ct = default);
}
