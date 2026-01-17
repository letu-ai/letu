using DbCompareTool.Config;
using DbCompareTool.Core.Diff;

namespace DbCompareTool.Core.Interfaces;

public interface IReportWriter
{
    Task WriteReportAsync(ComparisonResult result, string outputPath, ReportFormat format, CancellationToken ct = default);
}
