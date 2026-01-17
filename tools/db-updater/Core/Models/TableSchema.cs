namespace DbCompareTool.Core.Models;

public class TableSchema
{
    public string SchemaName { get; set; } = "public";
    public string TableName { get; set; } = string.Empty;
    public string TableComment { get; set; } = string.Empty;
    public List<ColumnSchema> Columns { get; set; } = new();
    public List<PrimaryKeySchema> PrimaryKeys { get; set; } = new();
    public List<ForeignKeySchema> ForeignKeys { get; set; } = new();
    public List<IndexSchema> Indexes { get; set; } = new();
    public List<UniqueConstraintSchema> UniqueConstraints { get; set; } = new();
    public List<CheckConstraintSchema> CheckConstraints { get; set; } = new();

    public string FullName => $"{SchemaName}.{TableName}";

    public ColumnSchema? GetColumn(string columnName)
    {
        return Columns.FirstOrDefault(c =>
            string.Equals(c.ColumnName, columnName, StringComparison.OrdinalIgnoreCase));
    }
}
