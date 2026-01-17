using DbCompareTool.Core.Models;

namespace DbCompareTool.Core.Diff;

public abstract class SchemaDiff
{
    public DiffType DiffType { get; set; }
    public string? SchemaName { get; set; }
    public string? TableName { get; set; }

    protected SchemaDiff(DiffType diffType, string? schemaName, string? tableName)
    {
        DiffType = diffType;
        SchemaName = schemaName;
        TableName = tableName;
    }
}

public class TableAddedDiff : SchemaDiff
{
    public TableSchema SourceTable { get; set; } = new();

    public TableAddedDiff(string schemaName, string tableName, TableSchema sourceTable)
        : base(DiffType.TableAdded, schemaName, tableName)
    {
        SourceTable = sourceTable;
    }
}

public class TableRemovedDiff : SchemaDiff
{
    public TableSchema TargetTable { get; set; } = new();

    public TableRemovedDiff(string schemaName, string tableName, TableSchema targetTable)
        : base(DiffType.TableRemoved, schemaName, tableName)
    {
        TargetTable = targetTable;
    }
}

public class ColumnAddedDiff : SchemaDiff
{
    public ColumnSchema SourceColumn { get; set; } = new();

    public ColumnAddedDiff(string schemaName, string tableName, ColumnSchema sourceColumn)
        : base(DiffType.ColumnAdded, schemaName, tableName)
    {
        SourceColumn = sourceColumn;
    }
}

public class ColumnRemovedDiff : SchemaDiff
{
    public ColumnSchema TargetColumn { get; set; } = new();

    public ColumnRemovedDiff(string schemaName, string tableName, ColumnSchema targetColumn)
        : base(DiffType.ColumnRemoved, schemaName, tableName)
    {
        TargetColumn = targetColumn;
    }
}

public class ColumnTypeChangedDiff : SchemaDiff
{
    public string ColumnName { get; set; } = string.Empty;
    public ColumnSchema SourceColumn { get; set; } = new();
    public ColumnSchema TargetColumn { get; set; } = new();

    public ColumnTypeChangedDiff(string schemaName, string tableName, string columnName,
        ColumnSchema sourceColumn, ColumnSchema targetColumn)
        : base(DiffType.ColumnTypeChanged, schemaName, tableName)
    {
        ColumnName = columnName;
        SourceColumn = sourceColumn;
        TargetColumn = targetColumn;
    }
}

public class ColumnNullableChangedDiff : SchemaDiff
{
    public string ColumnName { get; set; } = string.Empty;
    public bool SourceNullable { get; set; }
    public bool TargetNullable { get; set; }

    public ColumnNullableChangedDiff(string schemaName, string tableName, string columnName,
        bool sourceNullable, bool targetNullable)
        : base(DiffType.ColumnNullableChanged, schemaName, tableName)
    {
        ColumnName = columnName;
        SourceNullable = sourceNullable;
        TargetNullable = targetNullable;
    }
}

public class ColumnDefaultChangedDiff : SchemaDiff
{
    public string ColumnName { get; set; } = string.Empty;
    public string? SourceDefault { get; set; }
    public string? TargetDefault { get; set; }

    public ColumnDefaultChangedDiff(string schemaName, string tableName, string columnName,
        string? sourceDefault, string? targetDefault)
        : base(DiffType.ColumnDefaultChanged, schemaName, tableName)
    {
        ColumnName = columnName;
        SourceDefault = sourceDefault;
        TargetDefault = targetDefault;
    }
}

public class PrimaryKeyAddedDiff : SchemaDiff
{
    public PrimaryKeySchema PrimaryKey { get; set; } = new();

    public PrimaryKeyAddedDiff(string schemaName, string tableName, PrimaryKeySchema primaryKey)
        : base(DiffType.PrimaryKeyAdded, schemaName, tableName)
    {
        PrimaryKey = primaryKey;
    }
}

public class PrimaryKeyRemovedDiff : SchemaDiff
{
    public PrimaryKeySchema PrimaryKey { get; set; } = new();

    public PrimaryKeyRemovedDiff(string schemaName, string tableName, PrimaryKeySchema primaryKey)
        : base(DiffType.PrimaryKeyRemoved, schemaName, tableName)
    {
        PrimaryKey = primaryKey;
    }
}

public class ForeignKeyAddedDiff : SchemaDiff
{
    public ForeignKeySchema ForeignKey { get; set; } = new();

    public ForeignKeyAddedDiff(string schemaName, string tableName, ForeignKeySchema foreignKey)
        : base(DiffType.ForeignKeyAdded, schemaName, tableName)
    {
        ForeignKey = foreignKey;
    }
}

public class ForeignKeyRemovedDiff : SchemaDiff
{
    public ForeignKeySchema ForeignKey { get; set; } = new();

    public ForeignKeyRemovedDiff(string schemaName, string tableName, ForeignKeySchema foreignKey)
        : base(DiffType.ForeignKeyRemoved, schemaName, tableName)
    {
        ForeignKey = foreignKey;
    }
}

public class IndexAddedDiff : SchemaDiff
{
    public IndexSchema Index { get; set; } = new();

    public IndexAddedDiff(string schemaName, string tableName, IndexSchema index)
        : base(DiffType.IndexAdded, schemaName, tableName)
    {
        Index = index;
    }
}

public class IndexRemovedDiff : SchemaDiff
{
    public IndexSchema Index { get; set; } = new();

    public IndexRemovedDiff(string schemaName, string tableName, IndexSchema index)
        : base(DiffType.IndexRemoved, schemaName, tableName)
    {
        Index = index;
    }
}

public class UniqueAddedDiff : SchemaDiff
{
    public UniqueConstraintSchema UniqueConstraint { get; set; } = new();

    public UniqueAddedDiff(string schemaName, string tableName, UniqueConstraintSchema uniqueConstraint)
        : base(DiffType.UniqueAdded, schemaName, tableName)
    {
        UniqueConstraint = uniqueConstraint;
    }
}

public class UniqueRemovedDiff : SchemaDiff
{
    public UniqueConstraintSchema UniqueConstraint { get; set; } = new();

    public UniqueRemovedDiff(string schemaName, string tableName, UniqueConstraintSchema uniqueConstraint)
        : base(DiffType.UniqueRemoved, schemaName, tableName)
    {
        UniqueConstraint = uniqueConstraint;
    }
}

public class CheckAddedDiff : SchemaDiff
{
    public CheckConstraintSchema CheckConstraint { get; set; } = new();

    public CheckAddedDiff(string schemaName, string tableName, CheckConstraintSchema checkConstraint)
        : base(DiffType.CheckAdded, schemaName, tableName)
    {
        CheckConstraint = checkConstraint;
    }
}

public class CheckRemovedDiff : SchemaDiff
{
    public CheckConstraintSchema CheckConstraint { get; set; } = new();

    public CheckRemovedDiff(string schemaName, string tableName, CheckConstraintSchema checkConstraint)
        : base(DiffType.CheckRemoved, schemaName, tableName)
    {
        CheckConstraint = checkConstraint;
    }
}
