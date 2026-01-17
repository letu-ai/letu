using DbCompareTool.Config;

namespace DbCompareTool.Core.Diff;

public class ComparisonResult
{
    public DateTime GeneratedAt { get; set; } = DateTime.Now;
    public string SourceDatabase { get; set; } = string.Empty;
    public string TargetDatabase { get; set; } = string.Empty;
    public List<SchemaDiff> Differences { get; set; } = new();
    public ComparisonSummary Summary { get; set; } = new();

    public ComparisonResult()
    {
        Differences = new List<SchemaDiff>();
    }

    public void AddDiff(SchemaDiff diff)
    {
        Differences.Add(diff);
        UpdateSummary(diff);
    }

    private void UpdateSummary(SchemaDiff diff)
    {
        Summary.TotalDifferences++;

        switch (diff.DiffType)
        {
            case DiffType.TableAdded:
                Summary.TablesAdded++;
                break;
            case DiffType.TableRemoved:
                Summary.TablesRemoved++;
                break;
            case DiffType.ColumnAdded:
                Summary.ColumnsAdded++;
                break;
            case DiffType.ColumnRemoved:
                Summary.ColumnsRemoved++;
                break;
            case DiffType.ColumnTypeChanged:
            case DiffType.ColumnNullableChanged:
            case DiffType.ColumnDefaultChanged:
                Summary.ColumnsModified++;
                break;
            case DiffType.PrimaryKeyAdded:
            case DiffType.PrimaryKeyChanged:
                Summary.ConstraintsAdded++;
                break;
            case DiffType.PrimaryKeyRemoved:
                Summary.ConstraintsRemoved++;
                break;
            case DiffType.ForeignKeyAdded:
                Summary.ConstraintsAdded++;
                break;
            case DiffType.ForeignKeyRemoved:
                Summary.ConstraintsRemoved++;
                break;
            case DiffType.UniqueAdded:
                Summary.ConstraintsAdded++;
                break;
            case DiffType.UniqueRemoved:
                Summary.ConstraintsRemoved++;
                break;
            case DiffType.CheckAdded:
                Summary.ConstraintsAdded++;
                break;
            case DiffType.CheckRemoved:
                Summary.ConstraintsRemoved++;
                break;
            case DiffType.IndexAdded:
                Summary.IndexesAdded++;
                break;
            case DiffType.IndexRemoved:
                Summary.IndexesRemoved++;
                break;
        }
    }

    public bool HasDifferences => Differences.Count > 0;
}

public class ComparisonSummary
{
    public int TotalDifferences { get; set; }
    public int TablesAdded { get; set; }
    public int TablesRemoved { get; set; }
    public int ColumnsAdded { get; set; }
    public int ColumnsRemoved { get; set; }
    public int ColumnsModified { get; set; }
    public int ConstraintsAdded { get; set; }
    public int ConstraintsRemoved { get; set; }
    public int IndexesAdded { get; set; }
    public int IndexesRemoved { get; set; }
}
