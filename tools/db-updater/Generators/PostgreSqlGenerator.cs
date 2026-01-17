using DbCompareTool.Config;
using DbCompareTool.Core.Diff;
using DbCompareTool.Core.Interfaces;
using DbCompareTool.Core.Models;
using System.Text;

namespace DbCompareTool.Generators;

public class PostgreSqlGenerator : ISqlGenerator
{
    public Task<string> GenerateMigrationSqlAsync(ComparisonResult result, ComparisonOptions options, CancellationToken ct = default)
    {
        var sql = new StringBuilder();

        // 头部注释
        sql.AppendLine("-- ================================================");
        sql.AppendLine("-- PostgreSQL Schema Migration Script");
        sql.AppendLine($"-- Generated: {result.GeneratedAt:yyyy-MM-dd HH:mm:ss}");
        sql.AppendLine($"-- Source: {result.SourceDatabase}");
        sql.AppendLine($"-- Target: {result.TargetDatabase}");
        sql.AppendLine("-- Total Differences: " + result.Summary.TotalDifferences);
        sql.AppendLine("-- ================================================");
        sql.AppendLine();
        sql.AppendLine("-- 注意: 此脚本使用事务包装，任何错误都会自动回滚");
        sql.AppendLine("-- 建议在执行前备份目标数据库");
        sql.AppendLine();

        // 分析和过滤差异，处理依赖关系
        var processedDiffs = ProcessDependencies(result.Differences);

        // 检查是否有需要执行的差异
        var hasDiffs = processedDiffs.Any(d => d.DiffType != DiffType.TableRemoved || options.DropMissingTables);
        
        if (!hasDiffs)
        {
            sql.AppendLine("-- 没有需要执行的迁移操作");
            return Task.FromResult(sql.ToString());
        }

        // 使用事务包装，PostgreSQL会在出错时自动回滚
        sql.AppendLine("BEGIN;");
        sql.AppendLine();
        sql.AppendLine("-- 设置锁超时和消息级别");
        sql.AppendLine("SET lock_timeout = '5s';");
        sql.AppendLine("SET client_min_messages = 'WARNING';");
        sql.AppendLine();

        // 分组处理差异，按类型排序
        var groupedDiffs = processedDiffs
            .OrderBy(d => GetDiffOrder(d.DiffType))
            .GroupBy(d => d.DiffType);

        foreach (var group in groupedDiffs)
        {
            ct.ThrowIfCancellationRequested();

            if (group.Key == DiffType.TableRemoved && !options.DropMissingTables)
                continue;

            sql.AppendLine($"-- {GetDiffTypeName(group.Key)}");

            foreach (var diff in group)
            {
                var statement = GenerateStatement(diff, options);
                if (!string.IsNullOrEmpty(statement))
                {
                    sql.AppendLine(statement);
                }
            }

            sql.AppendLine();
        }

        sql.AppendLine("-- 如果执行到这里，说明所有操作都成功完成");
        sql.AppendLine("COMMIT;");
        sql.AppendLine();
        sql.AppendLine("-- ================================================");
        sql.AppendLine("-- 重要提示:");
        sql.AppendLine("-- 如果上面的脚本执行过程中出现任何错误，");
        sql.AppendLine("-- PostgreSQL会自动回滚整个事务（ROLLBACK），");
        sql.AppendLine("-- 所有更改都不会生效。");
        sql.AppendLine("-- 如果需要手动回滚，可以在错误发生后执行: ROLLBACK;");
        sql.AppendLine("-- ================================================");
        sql.AppendLine();

        // 回滚脚本
        if (options.DropMissingTables)
        {
            sql.AppendLine("-- ================================================");
            sql.AppendLine("-- Rollback Script (保存此脚本以便回滚)");
            sql.AppendLine("-- ================================================");
            sql.AppendLine("-- 注意: 完整的回滚需要保存原始状态");
            sql.AppendLine("-- 建议在执行前备份目标数据库");
        }

        return Task.FromResult(sql.ToString());
    }

    private string GenerateStatement(SchemaDiff diff, ComparisonOptions options)
    {
        return diff switch
        {
            TableAddedDiff d => GenerateCreateTable(d.SourceTable),
            TableRemovedDiff d => GenerateDropTable(d.TargetTable, options.CascadeDrop),
            ColumnAddedDiff d => GenerateAddColumn(d.SchemaName!, d.TableName!, d.SourceColumn),
            ColumnRemovedDiff d => GenerateDropColumn(d.SchemaName!, d.TableName!, d.TargetColumn.ColumnName),
            ColumnTypeChangedDiff d => GenerateAlterColumnType(d.SchemaName!, d.TableName!, d.ColumnName, d.SourceColumn),
            ColumnNullableChangedDiff d => GenerateAlterColumnNullable(d.SchemaName!, d.TableName!, d.ColumnName, d.SourceNullable),
            ColumnDefaultChangedDiff d => GenerateAlterColumnDefault(d.SchemaName!, d.TableName!, d.ColumnName, d.SourceDefault),
            PrimaryKeyAddedDiff d => GenerateAddPrimaryKey(d.SchemaName!, d.TableName!, d.PrimaryKey),
            PrimaryKeyRemovedDiff d => GenerateDropConstraint(d.SchemaName!, d.TableName!, d.PrimaryKey.ConstraintName),
            ForeignKeyAddedDiff d => GenerateAddForeignKey(d.SchemaName!, d.TableName!, d.ForeignKey),
            ForeignKeyRemovedDiff d => GenerateDropConstraint(d.SchemaName!, d.TableName!, d.ForeignKey.ConstraintName),
            IndexAddedDiff d => GenerateCreateIndex(d.SchemaName!, d.TableName!, d.Index),
            IndexRemovedDiff d => GenerateDropIndex(d.SchemaName!, d.Index.IndexName),
            UniqueAddedDiff d => GenerateAddUniqueConstraint(d.SchemaName!, d.TableName!, d.UniqueConstraint),
            UniqueRemovedDiff d => GenerateDropConstraint(d.SchemaName!, d.TableName!, d.UniqueConstraint.ConstraintName),
            CheckAddedDiff d => GenerateAddCheckConstraint(d.SchemaName!, d.TableName!, d.CheckConstraint),
            CheckRemovedDiff d => GenerateDropConstraint(d.SchemaName!, d.TableName!, d.CheckConstraint.ConstraintName),
            _ => $"-- 未处理的差异类型: {diff.DiffType}"
        };
    }

    private string GenerateCreateTable(TableSchema table)
    {
        var sql = new StringBuilder();

        sql.Append($"CREATE TABLE {QuoteIdentifier(table.SchemaName)}.{QuoteIdentifier(table.TableName)} (");

        // 列定义
        var columns = new List<string>();
        foreach (var col in table.Columns.OrderBy(c => c.OrdinalPosition))
        {
            var colDef = GenerateColumnDefinition(col);
            columns.Add($"    {colDef}");
        }

        sql.AppendLine();
        sql.AppendLine(string.Join(",\n", columns));

        // 主键
        if (table.PrimaryKeys.Count > 0)
        {
            var pk = table.PrimaryKeys[0];
            sql.AppendLine($",    CONSTRAINT {QuoteIdentifier(pk.ConstraintName)} PRIMARY KEY ({string.Join(", ", pk.ColumnNames.Select(QuoteIdentifier))})");
        }

        sql.AppendLine(");");

        // 注释
        if (!string.IsNullOrEmpty(table.TableComment))
        {
            sql.AppendLine($"COMMENT ON TABLE {QuoteIdentifier(table.SchemaName)}.{QuoteIdentifier(table.TableName)} IS '{EscapeString(table.TableComment)}';");
        }

        return sql.ToString();
    }

    private string GenerateColumnDefinition(ColumnSchema col)
    {
        var sb = new StringBuilder();

        sb.Append(QuoteIdentifier(col.ColumnName));
        sb.Append(' ');
        sb.Append(col.GetFullDataType());

        if (col.IsIdentity)
        {
            if (col.IdentityGeneration == "ALWAYS")
                sb.Append(" GENERATED ALWAYS AS IDENTITY");
            else
                sb.Append(" GENERATED BY DEFAULT AS IDENTITY");
        }
        else if (!col.IsNullable)
        {
            sb.Append(" NOT NULL");
        }

        if (!string.IsNullOrEmpty(col.DefaultValue) && !col.IsIdentity)
        {
            sb.Append(" DEFAULT ");
            sb.Append(col.DefaultValue);
        }

        return sb.ToString();
    }

    private string GenerateDropTable(TableSchema table, bool cascade)
    {
        var cascadeStr = cascade ? " CASCADE" : "";
        return $"DROP TABLE IF EXISTS {QuoteIdentifier(table.SchemaName)}.{QuoteIdentifier(table.TableName)}{cascadeStr};";
    }

    private string GenerateAddColumn(string schemaName, string tableName, ColumnSchema column)
    {
        var colDef = GenerateColumnDefinition(column);
        return $"ALTER TABLE {QuoteIdentifier(schemaName)}.{QuoteIdentifier(tableName)} ADD COLUMN {colDef};";
    }

    private string GenerateDropColumn(string schemaName, string tableName, string columnName)
    {
        return $"ALTER TABLE {QuoteIdentifier(schemaName)}.{QuoteIdentifier(tableName)} DROP COLUMN {QuoteIdentifier(columnName)};";
    }

    private string GenerateAlterColumnType(string schemaName, string tableName, string columnName, ColumnSchema sourceColumn)
    {
        var usingClause = $" USING {QuoteIdentifier(columnName)}::{sourceColumn.DataType}";
        return $"ALTER TABLE {QuoteIdentifier(schemaName)}.{QuoteIdentifier(tableName)} ALTER COLUMN {QuoteIdentifier(columnName)} TYPE {sourceColumn.GetFullDataType()} {usingClause};";
    }

    private string GenerateAlterColumnNullable(string schemaName, string tableName, string columnName, bool isNullable)
    {
        var action = isNullable ? "DROP NOT NULL" : "SET NOT NULL";
        return $"ALTER TABLE {QuoteIdentifier(schemaName)}.{QuoteIdentifier(tableName)} ALTER COLUMN {QuoteIdentifier(columnName)} {action};";
    }

    private string GenerateAlterColumnDefault(string schemaName, string tableName, string columnName, string? defaultValue)
    {
        if (string.IsNullOrEmpty(defaultValue))
            return $"ALTER TABLE {QuoteIdentifier(schemaName)}.{QuoteIdentifier(tableName)} ALTER COLUMN {QuoteIdentifier(columnName)} DROP DEFAULT;";
        else
            return $"ALTER TABLE {QuoteIdentifier(schemaName)}.{QuoteIdentifier(tableName)} ALTER COLUMN {QuoteIdentifier(columnName)} SET DEFAULT {defaultValue};";
    }

    private string GenerateAddPrimaryKey(string schemaName, string tableName, PrimaryKeySchema primaryKey)
    {
        var columns = string.Join(", ", primaryKey.ColumnNames.Select(QuoteIdentifier));
        return $"ALTER TABLE {QuoteIdentifier(schemaName)}.{QuoteIdentifier(tableName)} ADD CONSTRAINT {QuoteIdentifier(primaryKey.ConstraintName)} PRIMARY KEY ({columns});";
    }

    private string GenerateDropConstraint(string schemaName, string tableName, string constraintName)
    {
        return $"ALTER TABLE {QuoteIdentifier(schemaName)}.{QuoteIdentifier(tableName)} DROP CONSTRAINT {QuoteIdentifier(constraintName)};";
    }

    private string GenerateAddForeignKey(string schemaName, string tableName, ForeignKeySchema foreignKey)
    {
        var columns = string.Join(", ", foreignKey.ColumnNames.Select(QuoteIdentifier));
        var refColumns = string.Join(", ", foreignKey.ReferencedColumns.Select(QuoteIdentifier));
        var onDelete = foreignKey.OnDeleteAction != "NO ACTION" ? $" ON DELETE {foreignKey.OnDeleteAction}" : "";
        var onUpdate = foreignKey.OnUpdateAction != "NO ACTION" ? $" ON UPDATE {foreignKey.OnUpdateAction}" : "";

        return $"ALTER TABLE {QuoteIdentifier(schemaName)}.{QuoteIdentifier(tableName)} ADD CONSTRAINT {QuoteIdentifier(foreignKey.ConstraintName)} " +
               $"FOREIGN KEY ({columns}) REFERENCES {QuoteIdentifier(foreignKey.ReferencedSchemaName)}.{QuoteIdentifier(foreignKey.ReferencedTable)} ({refColumns}){onDelete}{onUpdate};";
    }

    private string GenerateCreateIndex(string schemaName, string tableName, IndexSchema index)
    {
        var unique = index.IsUnique ? "UNIQUE " : "";
        var columns = string.Join(", ", index.Columns.Select(c => $"{QuoteIdentifier(c.ColumnName)} {c.Direction}"));
        var whereClause = !string.IsNullOrEmpty(index.PartialPredicate) ? $" WHERE {index.PartialPredicate}" : "";

        return $"CREATE {unique}INDEX {QuoteIdentifier(index.IndexName)} ON {QuoteIdentifier(schemaName)}.{QuoteIdentifier(tableName)} ({columns}){whereClause};";
    }

    private string GenerateDropIndex(string schemaName, string indexName)
    {
        return $"DROP INDEX IF EXISTS {QuoteIdentifier(schemaName)}.{QuoteIdentifier(indexName)};";
    }

    private string GenerateAddUniqueConstraint(string schemaName, string tableName, UniqueConstraintSchema uniqueConstraint)
    {
        var columns = string.Join(", ", uniqueConstraint.ColumnNames.Select(QuoteIdentifier));
        return $"ALTER TABLE {QuoteIdentifier(schemaName)}.{QuoteIdentifier(tableName)} ADD CONSTRAINT {QuoteIdentifier(uniqueConstraint.ConstraintName)} UNIQUE ({columns});";
    }

    private string GenerateAddCheckConstraint(string schemaName, string tableName, CheckConstraintSchema checkConstraint)
    {
        return $"ALTER TABLE {QuoteIdentifier(schemaName)}.{QuoteIdentifier(tableName)} ADD CONSTRAINT {QuoteIdentifier(checkConstraint.ConstraintName)} {checkConstraint.ConstraintDefinition};";
    }

    private string QuoteIdentifier(string identifier)
    {
        // PostgreSQL标识符加双引号
        return $"\"{identifier.Replace("\"", "\"\"")}\"";
    }

    private string EscapeString(string value)
    {
        return value.Replace("'", "''");
    }

    private int GetDiffOrder(DiffType diffType)
    {
        return diffType switch
        {
            DiffType.TableRemoved => 1,
            // 约束删除必须在列删除之前执行，因为删除列可能会自动删除约束
            DiffType.PrimaryKeyRemoved => 2,
            DiffType.ForeignKeyRemoved => 2,
            DiffType.UniqueRemoved => 2,
            DiffType.CheckRemoved => 2,
            DiffType.IndexRemoved => 2,
            DiffType.ColumnRemoved => 3,
            DiffType.ColumnNullableChanged => 8,
            DiffType.ColumnDefaultChanged => 8,
            DiffType.ColumnTypeChanged => 9,
            DiffType.ColumnAdded => 10,
            DiffType.TableAdded => 11,
            DiffType.PrimaryKeyAdded => 12,
            DiffType.UniqueAdded => 13,
            DiffType.CheckAdded => 14,
            DiffType.ForeignKeyAdded => 15,
            DiffType.IndexAdded => 16,
            _ => 99
        };
    }

    private string GetDiffTypeName(DiffType diffType)
    {
        return diffType switch
        {
            DiffType.TableAdded => "========== 新增表 ==========",
            DiffType.TableRemoved => "========== 删除表 ==========",
            DiffType.ColumnAdded => "---------- 新增列 ----------",
            DiffType.ColumnRemoved => "---------- 删除列 ----------",
            DiffType.ColumnTypeChanged => "---------- 修改列类型 ----------",
            DiffType.ColumnNullableChanged => "---------- 修改列可空性 ----------",
            DiffType.ColumnDefaultChanged => "---------- 修改列默认值 ----------",
            DiffType.PrimaryKeyAdded => "---------- 新增主键 ----------",
            DiffType.PrimaryKeyRemoved => "---------- 删除主键 ----------",
            DiffType.ForeignKeyAdded => "---------- 新增外键 ----------",
            DiffType.ForeignKeyRemoved => "---------- 删除外键 ----------",
            DiffType.IndexAdded => "---------- 新增索引 ----------",
            DiffType.IndexRemoved => "---------- 删除索引 ----------",
            DiffType.UniqueAdded => "---------- 新增唯一约束 ----------",
            DiffType.UniqueRemoved => "---------- 删除唯一约束 ----------",
            DiffType.CheckAdded => "---------- 新增检查约束 ----------",
            DiffType.CheckRemoved => "---------- 删除检查约束 ----------",
            _ => "---------- 其他 ----------"
        };
    }

    /// <summary>
    /// 处理差异之间的依赖关系，过滤冗余操作并调整顺序
    /// </summary>
    private List<SchemaDiff> ProcessDependencies(List<SchemaDiff> differences)
    {
        var result = new List<SchemaDiff>(differences);
        var toRemove = new HashSet<SchemaDiff>();

        // 获取所有删除列的操作
        var columnRemovals = differences.OfType<ColumnRemovedDiff>().ToList();

        // 检查主键删除操作是否冗余
        foreach (var pkRemoval in differences.OfType<PrimaryKeyRemovedDiff>())
        {
            if (WillColumnRemovalDropPrimaryKey(pkRemoval, columnRemovals))
            {
                // 如果删除列会自动删除主键，则过滤掉主键删除操作
                toRemove.Add(pkRemoval);
            }
        }

        // 检查外键删除操作是否冗余
        foreach (var fkRemoval in differences.OfType<ForeignKeyRemovedDiff>())
        {
            if (WillColumnRemovalDropForeignKey(fkRemoval, columnRemovals))
            {
                toRemove.Add(fkRemoval);
            }
        }

        // 检查唯一约束删除操作是否冗余
        foreach (var uniqueRemoval in differences.OfType<UniqueRemovedDiff>())
        {
            if (WillColumnRemovalDropUniqueConstraint(uniqueRemoval, columnRemovals))
            {
                toRemove.Add(uniqueRemoval);
            }
        }

        // 检查索引删除操作是否冗余（如果索引的所有列都会被删除）
        foreach (var indexRemoval in differences.OfType<IndexRemovedDiff>())
        {
            if (WillColumnRemovalDropIndex(indexRemoval, columnRemovals))
            {
                toRemove.Add(indexRemoval);
            }
        }

        // 移除冗余的操作
        result.RemoveAll(d => toRemove.Contains(d));

        return result;
    }

    /// <summary>
    /// 检查删除列操作是否会自动删除主键
    /// </summary>
    private bool WillColumnRemovalDropPrimaryKey(PrimaryKeyRemovedDiff pkRemoval, List<ColumnRemovedDiff> columnRemovals)
    {
        // 查找同一表中所有会被删除的列
        var columnsToRemove = columnRemovals
            .Where(c => string.Equals(c.SchemaName, pkRemoval.SchemaName, StringComparison.OrdinalIgnoreCase) &&
                        string.Equals(c.TableName, pkRemoval.TableName, StringComparison.OrdinalIgnoreCase))
            .Select(c => c.TargetColumn.ColumnName)
            .ToHashSet(StringComparer.OrdinalIgnoreCase);

        // 如果主键的所有列都会被删除，则删除列会自动删除主键
        return pkRemoval.PrimaryKey.ColumnNames.All(col => columnsToRemove.Contains(col));
    }

    /// <summary>
    /// 检查删除列操作是否会自动删除外键
    /// </summary>
    private bool WillColumnRemovalDropForeignKey(ForeignKeyRemovedDiff fkRemoval, List<ColumnRemovedDiff> columnRemovals)
    {
        var columnsToRemove = columnRemovals
            .Where(c => string.Equals(c.SchemaName, fkRemoval.SchemaName, StringComparison.OrdinalIgnoreCase) &&
                        string.Equals(c.TableName, fkRemoval.TableName, StringComparison.OrdinalIgnoreCase))
            .Select(c => c.TargetColumn.ColumnName)
            .ToHashSet(StringComparer.OrdinalIgnoreCase);

        // 如果外键的所有列都会被删除，则删除列会自动删除外键
        return fkRemoval.ForeignKey.ColumnNames.All(col => columnsToRemove.Contains(col));
    }

    /// <summary>
    /// 检查删除列操作是否会自动删除唯一约束
    /// </summary>
    private bool WillColumnRemovalDropUniqueConstraint(UniqueRemovedDiff uniqueRemoval, List<ColumnRemovedDiff> columnRemovals)
    {
        var columnsToRemove = columnRemovals
            .Where(c => string.Equals(c.SchemaName, uniqueRemoval.SchemaName, StringComparison.OrdinalIgnoreCase) &&
                        string.Equals(c.TableName, uniqueRemoval.TableName, StringComparison.OrdinalIgnoreCase))
            .Select(c => c.TargetColumn.ColumnName)
            .ToHashSet(StringComparer.OrdinalIgnoreCase);

        // 如果唯一约束的所有列都会被删除，则删除列会自动删除唯一约束
        return uniqueRemoval.UniqueConstraint.ColumnNames.All(col => columnsToRemove.Contains(col));
    }

    /// <summary>
    /// 检查删除列操作是否会自动删除索引
    /// </summary>
    private bool WillColumnRemovalDropIndex(IndexRemovedDiff indexRemoval, List<ColumnRemovedDiff> columnRemovals)
    {
        var columnsToRemove = columnRemovals
            .Where(c => string.Equals(c.SchemaName, indexRemoval.SchemaName, StringComparison.OrdinalIgnoreCase) &&
                        string.Equals(c.TableName, indexRemoval.TableName, StringComparison.OrdinalIgnoreCase))
            .Select(c => c.TargetColumn.ColumnName)
            .ToHashSet(StringComparer.OrdinalIgnoreCase);

        // 如果索引的所有列都会被删除，则删除列会自动删除索引
        return indexRemoval.Index.Columns.All(col => columnsToRemove.Contains(col.ColumnName));
    }
}
