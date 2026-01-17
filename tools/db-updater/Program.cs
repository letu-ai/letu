using CommandLine;
using DbCompareTool.Config;
using DbCompareTool.Services;

namespace DbCompareTool;

public class Options
{
    [Option('s', "source", Required = false, HelpText = "源数据库连接字符串（覆盖配置文件）")]
    public string? SourceConnection { get; set; }

    [Option('t', "target", Required = false, HelpText = "目标数据库连接字符串（覆盖配置文件）")]
    public string? TargetConnection { get; set; }

    [Option('o', "output", Required = false, HelpText = "输出目录（覆盖配置文件）")]
    public string? OutputDirectory { get; set; }

    [Option("sql-only", Required = false, Default = false, HelpText = "只生成SQL，不生成报告")]
    public bool SqlOnly { get; set; }

    [Option("report-only", Required = false, Default = false, HelpText = "只生成报告，不生成SQL")]
    public bool ReportOnly { get; set; }

    [Option('v', "verbose", Required = false, Default = false, HelpText = "详细输出")]
    public bool Verbose { get; set; }
}

class Program
{
    static async Task<int> Main(string[] args)
    {
        Console.WriteLine("==============================================");
        Console.WriteLine("  PostgreSQL Schema 对比迁移工具");
        Console.WriteLine("  Version 1.0.0");
        Console.WriteLine("==============================================");
        Console.WriteLine();

        var parseResult = Parser.Default.ParseArguments<Options>(args);
        await parseResult.WithParsedAsync(async options =>
        {
            try
            {
                await RunAsync(options);
            }
            catch (Exception ex)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine($"错误: {ex.Message}");
                if (options.Verbose)
                {
                    Console.WriteLine(ex.StackTrace);
                }
                Console.ResetColor();
                Environment.Exit(1);
            }
        });

        return 0;
    }

    static async Task RunAsync(Options options)
    {
        var config = ConfigLoader.Load();

        // 命令行参数覆盖配置
        if (!string.IsNullOrEmpty(options.SourceConnection))
        {
            config.Source = ParseConnectionString(options.SourceConnection);
            Console.WriteLine($"使用命令行指定的源数据库: {config.Source.Host}:{config.Source.Port}/{config.Source.Database}");
        }

        if (!string.IsNullOrEmpty(options.TargetConnection))
        {
            config.Target = ParseConnectionString(options.TargetConnection);
            Console.WriteLine($"使用命令行指定的目标数据库: {config.Target.Host}:{config.Target.Port}/{config.Target.Database}");
        }

        if (!string.IsNullOrEmpty(options.OutputDirectory))
        {
            config.Output.BaseDirectory = options.OutputDirectory;
            Console.WriteLine($"使用命令行指定的输出目录: {options.OutputDirectory}");
        }

        // 执行对比
        var comparator = new SchemaComparator();
        var cts = new CancellationTokenSource();

        var result = await comparator.CompareAsync(config, cts.Token);

        // 生成输出
        if (!options.ReportOnly)
        {
            await comparator.GenerateOutputsAsync(result, config, cts.Token);
        }
        else if (options.ReportOnly)
        {
            // 只生成报告
            var outputDir = config.Output.BaseDirectory;
            Directory.CreateDirectory(outputDir);

            var timestamp = config.Output.IncludeTimestamp
                ? $"_{DateTime.Now:yyyyMMdd_HHmmss}"
                : "";
            var reportPath = Path.Combine(outputDir, $"diff-report{timestamp}.md");

            var reporter = new Reporters.MarkdownReporter();
            await reporter.WriteReportAsync(result, reportPath, Config.ReportFormat.Markdown, cts.Token);

            Console.WriteLine();
            Console.WriteLine($"报告已生成: {Path.GetFullPath(reportPath)}");
        }

        Console.WriteLine();
        Console.WriteLine("完成！");
    }

    static ConnectionConfig ParseConnectionString(string connectionString)
    {
        var config = new ConnectionConfig();
        var parts = connectionString.Split(';', StringSplitOptions.RemoveEmptyEntries);

        foreach (var part in parts)
        {
            var keyValue = part.Split('=', 2);
            if (keyValue.Length != 2) continue;

            var key = keyValue[0].Trim().ToLowerInvariant();
            var value = keyValue[1].Trim();

            switch (key)
            {
                case "host":
                    config.Host = value;
                    break;
                case "port":
                    if (int.TryParse(value, out var port))
                        config.Port = port;
                    break;
                case "database":
                    config.Database = value;
                    break;
                case "username":
                case "user id":
                case "userid":
                case "user":
                    config.Username = value;
                    break;
                case "password":
                    config.Password = value;
                    break;
            }
        }

        return config;
    }
}
