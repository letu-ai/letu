using DbCompareTool.Comparers;
using DbCompareTool.Config;
using DbCompareTool.Core.Diff;
using DbCompareTool.Core.Interfaces;
using DbCompareTool.Core.Models;
using DbCompareTool.Extractors;
using DbCompareTool.Generators;
using DbCompareTool.Reporters;

namespace DbCompareTool.Services;

public class SchemaComparator
{
    private readonly ISchemaExtractor _extractor;
    private readonly ISchemaComparer _comparer;
    private readonly ISqlGenerator _sqlGenerator;

    public SchemaComparator()
    {
        _extractor = new PostgreSqlSchemaExtractor();
        _comparer = new SchemaComparer();
        _sqlGenerator = new PostgreSqlGenerator();
    }

    public async Task<ComparisonResult> CompareAsync(ComparisonConfig config, CancellationToken ct = default)
    {
        Console.WriteLine($"正在连接源数据库: {config.Source.Host}:{config.Source.Port}/{config.Source.Database}...");
        var sourceSchema = await _extractor.ExtractAsync(config.Source, config.Filter, ct);
        Console.WriteLine($"源数据库提取完成，共 {sourceSchema.Tables.Count} 张表。");

        Console.WriteLine($"正在连接目标数据库: {config.Target.Host}:{config.Target.Port}/{config.Target.Database}...");
        var targetSchema = await _extractor.ExtractAsync(config.Target, config.Filter, ct);
        Console.WriteLine($"目标数据库提取完成，共 {targetSchema.Tables.Count} 张表。");

        Console.WriteLine("正在比较Schema...");
        var result = await _comparer.CompareAsync(sourceSchema, targetSchema, ct);

        Console.WriteLine();
        Console.WriteLine("=== 比较结果 ===");
        Console.WriteLine($"总差异: {result.Summary.TotalDifferences}");
        Console.WriteLine($"  新增表: {result.Summary.TablesAdded}");
        Console.WriteLine($"  删除表: {result.Summary.TablesRemoved}");
        Console.WriteLine($"  新增列: {result.Summary.ColumnsAdded}");
        Console.WriteLine($"  删除列: {result.Summary.ColumnsRemoved}");
        Console.WriteLine($"  修改列: {result.Summary.ColumnsModified}");
        Console.WriteLine($"  新增约束: {result.Summary.ConstraintsAdded}");
        Console.WriteLine($"  删除约束: {result.Summary.ConstraintsRemoved}");
        Console.WriteLine($"  新增索引: {result.Summary.IndexesAdded}");
        Console.WriteLine($"  删除索引: {result.Summary.IndexesRemoved}");

        return result;
    }

    public async Task GenerateOutputsAsync(ComparisonResult result, ComparisonConfig config, CancellationToken ct = default)
    {
        var outputDir = config.Output.BaseDirectory;
        Directory.CreateDirectory(outputDir);

        // 生成时间戳
        var timestamp = config.Output.IncludeTimestamp
            ? $"_{DateTime.Now:yyyyMMdd_HHmmss}"
            : "";

        // 生成SQL迁移脚本
        var sqlPath = Path.Combine(outputDir, $"migration{timestamp}.sql");
        Console.WriteLine();
        Console.WriteLine($"正在生成SQL迁移脚本: {sqlPath}");
        var sql = await _sqlGenerator.GenerateMigrationSqlAsync(result, config.Options, ct);
        await File.WriteAllTextAsync(sqlPath, sql, ct);
        Console.WriteLine("SQL迁移脚本生成完成。");

        // 生成差异报告
        var reportFileName = $"{config.Output.ReportFileName}{timestamp}";
        var reportExtension = config.Output.ReportFormat switch
        {
            ReportFormat.Json => ".json",
            ReportFormat.Markdown => ".md",
            ReportFormat.Html => ".html",
            _ => ".md"
        };
        var reportPath = Path.Combine(outputDir, reportFileName + reportExtension);

        Console.WriteLine($"正在生成差异报告: {reportPath}");

        IReportWriter reporter = config.Output.ReportFormat switch
        {
            ReportFormat.Json => new JsonReporter(),
            ReportFormat.Markdown => new MarkdownReporter(),
            ReportFormat.Html => new HtmlReporter(),
            _ => new MarkdownReporter()
        };

        await reporter.WriteReportAsync(result, reportPath, config.Output.ReportFormat, ct);
        Console.WriteLine("差异报告生成完成。");

        Console.WriteLine();
        Console.WriteLine("=== 输出文件 ===");
        Console.WriteLine($"SQL: {Path.GetFullPath(sqlPath)}");
        Console.WriteLine($"报告: {Path.GetFullPath(reportPath)}");
    }
}
