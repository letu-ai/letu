using DbCompareTool.Config;
using DbCompareTool.Core.Diff;
using DbCompareTool.Core.Interfaces;
using System.Text.Json;

namespace DbCompareTool.Reporters;

public class JsonReporter : IReportWriter
{
    public async Task WriteReportAsync(ComparisonResult result, string outputPath, ReportFormat format, CancellationToken ct = default)
    {
        var json = JsonSerializer.Serialize(result, new JsonSerializerOptions
        {
            WriteIndented = true,
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase
        });

        await File.WriteAllTextAsync(outputPath, json, ct);
    }
}
