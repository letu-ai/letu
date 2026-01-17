using DbCompareTool.Core.Diff;
using DbCompareTool.Core.Models;

namespace DbCompareTool.Core.Interfaces;

public interface ISchemaComparer
{
    Task<ComparisonResult> CompareAsync(DatabaseSchema source, DatabaseSchema target, CancellationToken ct = default);
}
