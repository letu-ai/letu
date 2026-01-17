using DbCompareTool.Core.Diff;
using DbCompareTool.Core.Interfaces;
using DbCompareTool.Core.Models;

namespace DbCompareTool.Comparers;

public class SchemaComparer : ISchemaComparer
{
    public async Task<ComparisonResult> CompareAsync(DatabaseSchema source, DatabaseSchema target, CancellationToken ct = default)
    {
        var result = new ComparisonResult
        {
            SourceDatabase = $"{source.Host}:{source.Port}/{source.DatabaseName}",
            TargetDatabase = $"{target.Host}:{target.Port}/{target.DatabaseName}"
        };

        // 比较表
        CompareTables(source, target, result);

        // 比较每个表的列、约束、索引
        await CompareTableDetailsAsync(source, target, result, ct);

        return await Task.FromResult(result);
    }

    private void CompareTables(DatabaseSchema source, DatabaseSchema target, ComparisonResult result)
    {
        var sourceTables = source.Tables;
        var targetTables = target.Tables;

        // 查找新增的表（在源中有，目标中没有）
        foreach (var sourceTable in sourceTables)
        {
            var key = sourceTable.Key;
            if (!targetTables.ContainsKey(key))
            {
                result.AddDiff(new TableAddedDiff(
                    sourceTable.Value.SchemaName,
                    sourceTable.Value.TableName,
                    sourceTable.Value
                ));
            }
        }

        // 查找删除的表（在目标中有，源中没有）
        foreach (var targetTable in targetTables)
        {
            var key = targetTable.Key;
            if (!sourceTables.ContainsKey(key))
            {
                result.AddDiff(new TableRemovedDiff(
                    targetTable.Value.SchemaName,
                    targetTable.Value.TableName,
                    targetTable.Value
                ));
            }
        }
    }

    private async Task CompareTableDetailsAsync(DatabaseSchema source, DatabaseSchema target, ComparisonResult result, CancellationToken ct)
    {
        foreach (var sourceTable in source.Tables)
        {
            ct.ThrowIfCancellationRequested();

            var key = sourceTable.Key;
            if (!target.Tables.ContainsKey(key))
                continue;

            var targetTable = target.Tables[key];

            // 比较列
            CompareColumns(sourceTable.Value, targetTable, result);

            // 比较主键
            ComparePrimaryKeys(sourceTable.Value, targetTable, result);

            // 比较外键
            CompareForeignKeys(sourceTable.Value, targetTable, result);

            // 比较唯一约束
            CompareUniqueConstraints(sourceTable.Value, targetTable, result);

            // 比较检查约束
            CompareCheckConstraints(sourceTable.Value, targetTable, result);

            // 比较索引
            CompareIndexes(sourceTable.Value, targetTable, result);
        }

        await Task.CompletedTask;
    }

    private void CompareColumns(TableSchema sourceTable, TableSchema targetTable, ComparisonResult result)
    {
        var sourceColumns = sourceTable.Columns.ToDictionary(c => c.ColumnName, StringComparer.OrdinalIgnoreCase);
        var targetColumns = targetTable.Columns.ToDictionary(c => c.ColumnName, StringComparer.OrdinalIgnoreCase);

        // 新增列
        foreach (var sourceColumn in sourceColumns)
        {
            if (!targetColumns.ContainsKey(sourceColumn.Key))
            {
                result.AddDiff(new ColumnAddedDiff(
                    sourceTable.SchemaName,
                    sourceTable.TableName,
                    sourceColumn.Value
                ));
            }
        }

        // 删除列
        foreach (var targetColumn in targetColumns)
        {
            if (!sourceColumns.ContainsKey(targetColumn.Key))
            {
                result.AddDiff(new ColumnRemovedDiff(
                    sourceTable.SchemaName,
                    sourceTable.TableName,
                    targetColumn.Value
                ));
            }
        }

        // 修改列
        foreach (var sourceColumn in sourceColumns)
        {
            if (!targetColumns.ContainsKey(sourceColumn.Key))
                continue;

            var targetColumn = targetColumns[sourceColumn.Key];
            var sourceCol = sourceColumn.Value;

            // 检查类型变化
            if (sourceCol.GetFullDataType() != targetColumn.GetFullDataType())
            {
                result.AddDiff(new ColumnTypeChangedDiff(
                    sourceTable.SchemaName,
                    sourceTable.TableName,
                    sourceCol.ColumnName,
                    sourceCol,
                    targetColumn
                ));
            }

            // 检查可空性变化
            if (sourceCol.IsNullable != targetColumn.IsNullable)
            {
                result.AddDiff(new ColumnNullableChangedDiff(
                    sourceTable.SchemaName,
                    sourceTable.TableName,
                    sourceCol.ColumnName,
                    sourceCol.IsNullable,
                    targetColumn.IsNullable
                ));
            }

            // 检查默认值变化
            var sourceDefault = NormalizeDefault(sourceCol.DefaultValue);
            var targetDefault = NormalizeDefault(targetColumn.DefaultValue);
            if (sourceDefault != targetDefault)
            {
                result.AddDiff(new ColumnDefaultChangedDiff(
                    sourceTable.SchemaName,
                    sourceTable.TableName,
                    sourceCol.ColumnName,
                    sourceCol.DefaultValue,
                    targetColumn.DefaultValue
                ));
            }
        }
    }

    private void ComparePrimaryKeys(TableSchema sourceTable, TableSchema targetTable, ComparisonResult result)
    {
        var sourcePk = sourceTable.PrimaryKeys.FirstOrDefault();
        var targetPk = targetTable.PrimaryKeys.FirstOrDefault();

        // 源有主键，目标没有
        if (sourcePk != null && targetPk == null)
        {
            result.AddDiff(new PrimaryKeyAddedDiff(
                sourceTable.SchemaName,
                sourceTable.TableName,
                sourcePk
            ));
        }
        // 源没有主键，目标有
        else if (sourcePk == null && targetPk != null)
        {
            result.AddDiff(new PrimaryKeyRemovedDiff(
                sourceTable.SchemaName,
                sourceTable.TableName,
                targetPk
            ));
        }
        // 都有主键，检查是否不同
        else if (sourcePk != null && targetPk != null)
        {
            var sourceCols = string.Join(",", sourcePk.ColumnNames.Order());
            var targetCols = string.Join(",", targetPk.ColumnNames.Order());

            if (sourceCols != targetCols)
            {
                // 先删除旧的，再添加新的
                result.AddDiff(new PrimaryKeyRemovedDiff(
                    sourceTable.SchemaName,
                    sourceTable.TableName,
                    targetPk
                ));
                result.AddDiff(new PrimaryKeyAddedDiff(
                    sourceTable.SchemaName,
                    sourceTable.TableName,
                    sourcePk
                ));
            }
        }
    }

    private void CompareForeignKeys(TableSchema sourceTable, TableSchema targetTable, ComparisonResult result)
    {
        var sourceFks = sourceTable.ForeignKeys
            .ToDictionary(fk => fk.ConstraintName, StringComparer.OrdinalIgnoreCase);
        var targetFks = targetTable.ForeignKeys
            .ToDictionary(fk => fk.ConstraintName, StringComparer.OrdinalIgnoreCase);

        // 新增外键
        foreach (var sourceFk in sourceFks)
        {
            if (!targetFks.ContainsKey(sourceFk.Key))
            {
                result.AddDiff(new ForeignKeyAddedDiff(
                    sourceTable.SchemaName,
                    sourceTable.TableName,
                    sourceFk.Value
                ));
            }
        }

        // 删除外键
        foreach (var targetFk in targetFks)
        {
            if (!sourceFks.ContainsKey(targetFk.Key))
            {
                result.AddDiff(new ForeignKeyRemovedDiff(
                    sourceTable.SchemaName,
                    sourceTable.TableName,
                    targetFk.Value
                ));
            }
        }
    }

    private void CompareUniqueConstraints(TableSchema sourceTable, TableSchema targetTable, ComparisonResult result)
    {
        var sourceUniques = sourceTable.UniqueConstraints
            .ToDictionary(u => u.ConstraintName, StringComparer.OrdinalIgnoreCase);
        var targetUniques = targetTable.UniqueConstraints
            .ToDictionary(u => u.ConstraintName, StringComparer.OrdinalIgnoreCase);

        // 新增唯一约束
        foreach (var sourceUnique in sourceUniques)
        {
            if (!targetUniques.ContainsKey(sourceUnique.Key))
            {
                result.AddDiff(new UniqueAddedDiff(
                    sourceTable.SchemaName,
                    sourceTable.TableName,
                    sourceUnique.Value
                ));
            }
        }

        // 删除唯一约束
        foreach (var targetUnique in targetUniques)
        {
            if (!sourceUniques.ContainsKey(targetUnique.Key))
            {
                result.AddDiff(new UniqueRemovedDiff(
                    sourceTable.SchemaName,
                    sourceTable.TableName,
                    targetUnique.Value
                ));
            }
        }
    }

    private void CompareCheckConstraints(TableSchema sourceTable, TableSchema targetTable, ComparisonResult result)
    {
        var sourceChecks = sourceTable.CheckConstraints
            .ToDictionary(c => c.ConstraintName, StringComparer.OrdinalIgnoreCase);
        var targetChecks = targetTable.CheckConstraints
            .ToDictionary(c => c.ConstraintName, StringComparer.OrdinalIgnoreCase);

        // 新增检查约束
        foreach (var sourceCheck in sourceChecks)
        {
            if (!targetChecks.ContainsKey(sourceCheck.Key))
            {
                result.AddDiff(new CheckAddedDiff(
                    sourceTable.SchemaName,
                    sourceTable.TableName,
                    sourceCheck.Value
                ));
            }
        }

        // 删除检查约束
        foreach (var targetCheck in targetChecks)
        {
            if (!sourceChecks.ContainsKey(targetCheck.Key))
            {
                result.AddDiff(new CheckRemovedDiff(
                    sourceTable.SchemaName,
                    sourceTable.TableName,
                    targetCheck.Value
                ));
            }
        }
    }

    private void CompareIndexes(TableSchema sourceTable, TableSchema targetTable, ComparisonResult result)
    {
        var sourceIndexes = sourceTable.Indexes
            .Where(i => !i.IsUniqueConstraint) // 排除唯一约束创建的索引
            .ToList();
        var targetIndexes = targetTable.Indexes
            .Where(i => !i.IsUniqueConstraint)
            .ToList();

        // 使用索引签名（基于内容）而不是名称来比较
        // 如果有多个索引具有相同签名，只取第一个（因为内容相同）
        var targetIndexSignatures = targetIndexes
            .GroupBy(i => GetIndexSignature(i), StringComparer.OrdinalIgnoreCase)
            .ToDictionary(g => g.Key, g => g.First(), StringComparer.OrdinalIgnoreCase);

        // 用于跟踪已处理的源索引签名，避免重复创建相同内容的索引
        var processedSignatures = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        // 新增索引：检查源索引是否在目标中存在（按签名比较）
        foreach (var sourceIndex in sourceIndexes)
        {
            var signature = GetIndexSignature(sourceIndex);
            
            // 如果目标中不存在相同签名的索引，且该签名未被处理过
            if (!targetIndexSignatures.ContainsKey(signature) && !processedSignatures.Contains(signature))
            {
                result.AddDiff(new IndexAddedDiff(
                    sourceTable.SchemaName,
                    sourceTable.TableName,
                    sourceIndex
                ));
                processedSignatures.Add(signature);
            }
        }

        // 删除索引：检查目标索引是否在源中存在（按签名比较）
        var sourceIndexSignatures = sourceIndexes
            .GroupBy(i => GetIndexSignature(i), StringComparer.OrdinalIgnoreCase)
            .ToDictionary(g => g.Key, g => g.First(), StringComparer.OrdinalIgnoreCase);

        foreach (var targetIndex in targetIndexes)
        {
            var signature = GetIndexSignature(targetIndex);
            
            // 如果源中不存在相同签名的索引，则需要删除
            if (!sourceIndexSignatures.ContainsKey(signature))
            {
                result.AddDiff(new IndexRemovedDiff(
                    sourceTable.SchemaName,
                    sourceTable.TableName,
                    targetIndex
                ));
            }
        }
    }

    /// <summary>
    /// 生成索引的签名，用于比较索引的实际内容（列、顺序、唯一性等）
    /// </summary>
    private string GetIndexSignature(IndexSchema index)
    {
        // 构建签名：唯一性 + 列名和顺序 + 索引类型 + 部分索引谓词
        var columns = string.Join(",", index.Columns.Select(c => 
            $"{c.ColumnName.ToLowerInvariant()}:{c.Direction.ToUpperInvariant()}"));
        var unique = index.IsUnique ? "UNIQUE:" : "";
        var indexType = index.IndexType ?? "btree";
        var partialPredicate = index.PartialPredicate ?? "";
        
        return $"{unique}{indexType}:{columns}:{partialPredicate}";
    }

    private string? NormalizeDefault(string? defaultValue)
    {
        if (string.IsNullOrEmpty(defaultValue))
            return null;

        // 移除常见的默认值格式差异
        return defaultValue.Trim().Replace("::", " ").Split()[0];
    }
}
