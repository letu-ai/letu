namespace DbCompareTool.Core.Models;

public class IndexSchema
{
    public string IndexName { get; set; } = string.Empty;
    public bool IsUnique { get; set; }
    public string? IndexType { get; set; }  // btree, hash, gist, gin
    public List<IndexColumn> Columns { get; set; } = new();
    public bool IsPrimary { get; set; }
    public bool IsUniqueConstraint { get; set; }
    public string? IndexComment { get; set; }
    public bool IsPartial { get; set; }
    public string? PartialPredicate { get; set; }
}

public class IndexColumn
{
    public string ColumnName { get; set; } = string.Empty;
    public string Direction { get; set; } = "ASC";  // ASC or DESC
}
