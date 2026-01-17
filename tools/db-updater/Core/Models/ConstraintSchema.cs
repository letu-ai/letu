namespace DbCompareTool.Core.Models;

public class PrimaryKeySchema
{
    public string ConstraintName { get; set; } = string.Empty;
    public List<string> ColumnNames { get; set; } = new();
}

public class ForeignKeySchema
{
    public string ConstraintName { get; set; } = string.Empty;
    public List<string> ColumnNames { get; set; } = new();
    public string ReferencedSchemaName { get; set; } = "public";
    public string ReferencedTable { get; set; } = string.Empty;
    public List<string> ReferencedColumns { get; set; } = new();
    public string OnDeleteAction { get; set; } = "NO ACTION";
    public string OnUpdateAction { get; set; } = "NO ACTION";
}

public class UniqueConstraintSchema
{
    public string ConstraintName { get; set; } = string.Empty;
    public List<string> ColumnNames { get; set; } = new();
}

public class CheckConstraintSchema
{
    public string ConstraintName { get; set; } = string.Empty;
    public string ConstraintDefinition { get; set; } = string.Empty;
}
