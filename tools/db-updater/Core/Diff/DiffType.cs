namespace DbCompareTool.Core.Diff;

public enum DiffType
{
    TableAdded,
    TableRemoved,
    ColumnAdded,
    ColumnRemoved,
    ColumnTypeChanged,
    ColumnNullableChanged,
    ColumnDefaultChanged,
    PrimaryKeyAdded,
    PrimaryKeyRemoved,
    PrimaryKeyChanged,
    ForeignKeyAdded,
    ForeignKeyRemoved,
    IndexAdded,
    IndexRemoved,
    IndexChanged,
    UniqueAdded,
    UniqueRemoved,
    CheckAdded,
    CheckRemoved
}
