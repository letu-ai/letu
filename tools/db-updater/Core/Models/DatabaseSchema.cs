namespace DbCompareTool.Core.Models;

public class DatabaseSchema
{
    public string Host { get; set; } = string.Empty;
    public int Port { get; set; }
    public string DatabaseName { get; set; } = string.Empty;
    public Dictionary<string, TableSchema> Tables { get; set; } = new();
    public string Version { get; set; } = string.Empty;

    public DatabaseSchema()
    {
        Tables = new Dictionary<string, TableSchema>(StringComparer.OrdinalIgnoreCase);
    }

    public string GetTableKey(string schemaName, string tableName)
    {
        return $"{schemaName}.{tableName}";
    }

    public bool TryGetTable(string schemaName, string tableName, out TableSchema? table)
    {
        var key = GetTableKey(schemaName, tableName);
        return Tables.TryGetValue(key, out table);
    }

    public void AddTable(TableSchema table)
    {
        var key = GetTableKey(table.SchemaName, table.TableName);
        Tables[key] = table;
    }
}
