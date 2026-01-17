using DbCompareTool.Core.Models;

namespace DbCompareTool.Config;

public class ComparisonConfig
{
    public ConnectionConfig Source { get; set; } = new();
    public ConnectionConfig Target { get; set; } = new();
    public ComparisonOptions Options { get; set; } = new();
    public OutputConfig Output { get; set; } = new();
    public FilterConfig Filter { get; set; } = new();
}

public class ConnectionConfig
{
    public string Host { get; set; } = "localhost";
    public int Port { get; set; } = 5432;
    public string Database { get; set; } = string.Empty;
    public string Username { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
    public bool UseSslMode { get; set; }
    public int CommandTimeout { get; set; } = 30;

    public string BuildConnectionString()
    {
        return $"Host={Host};Port={Port};Database={Database};User ID={Username};Password={Password}";
    }
}

public class ComparisonOptions
{
    public bool IncludeColumns { get; set; } = true;
    public bool IncludePrimaryKeys { get; set; } = true;
    public bool IncludeForeignKeys { get; set; } = true;
    public bool IncludeIndexes { get; set; } = true;
    public bool IncludeUniqueConstraints { get; set; } = true;
    public bool IncludeCheckConstraints { get; set; } = true;
    public bool IncludeComments { get; set; } = true;
    public bool DropMissingTables { get; set; } = false;
    public bool CascadeDrop { get; set; } = false;
}

public class OutputConfig
{
    public string BaseDirectory { get; set; } = "./Output";
    public string SqlFileName { get; set; } = "migration.sql";
    public string ReportFileName { get; set; } = "diff-report";
    public ReportFormat ReportFormat { get; set; } = ReportFormat.Markdown;
    public bool IncludeTimestamp { get; set; } = true;
}

public class FilterConfig
{
    public List<string> IncludeSchemas { get; set; } = new() { "public" };
    public List<string> ExcludeSchemas { get; set; } = new();
    public List<string> IncludeTables { get; set; } = new();
    public List<string> ExcludeTables { get; set; } = new();

    public bool ShouldIncludeSchema(string schemaName)
    {
        if (ExcludeSchemas.Contains(schemaName)) return false;
        if (IncludeSchemas.Count == 0) return true;
        return IncludeSchemas.Contains(schemaName);
    }

    public bool ShouldIncludeTable(string tableName)
    {
        if (ExcludeTables.Contains(tableName)) return false;
        if (IncludeTables.Count == 0) return true;
        return IncludeTables.Contains(tableName);
    }
}

public enum ReportFormat
{
    Json,
    Markdown,
    Html
}
