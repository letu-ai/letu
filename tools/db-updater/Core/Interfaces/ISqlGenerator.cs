using DbCompareTool.Config;
using DbCompareTool.Core.Diff;

namespace DbCompareTool.Core.Interfaces;

public interface ISqlGenerator
{
    Task<string> GenerateMigrationSqlAsync(ComparisonResult result, ComparisonOptions options, CancellationToken ct = default);
}
