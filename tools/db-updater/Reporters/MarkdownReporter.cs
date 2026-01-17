using DbCompareTool.Config;
using DbCompareTool.Core.Diff;
using DbCompareTool.Core.Interfaces;
using DbCompareTool.Core.Models;
using System.Text;

namespace DbCompareTool.Reporters;

public class MarkdownReporter : IReportWriter
{
    public async Task WriteReportAsync(ComparisonResult result, string outputPath, ReportFormat format, CancellationToken ct = default)
    {
        var md = new StringBuilder();

        // 标题
        md.AppendLine("# PostgreSQL Schema 差异报告");
        md.AppendLine();
        md.AppendLine($"**生成时间**: {result.GeneratedAt:yyyy-MM-dd HH:mm:ss}");
        md.AppendLine($"**源数据库**: {result.SourceDatabase}");
        md.AppendLine($"**目标数据库**: {result.TargetDatabase}");
        md.AppendLine();

        // 概览
        md.AppendLine("## 📊 概览");
        md.AppendLine();
        md.AppendLine("| 类型 | 数量 |");
        md.AppendLine("|------|------|");
        md.AppendLine($"| ✅ 新增表 | {result.Summary.TablesAdded} |");
        md.AppendLine($"| ❌ 删除表 | {result.Summary.TablesRemoved} |");
        md.AppendLine($"| ➕ 新增列 | {result.Summary.ColumnsAdded} |");
        md.AppendLine($"| ➖ 删除列 | {result.Summary.ColumnsRemoved} |");
        md.AppendLine($"| 🔄 修改列 | {result.Summary.ColumnsModified} |");
        md.AppendLine($"| 🔒 新增约束 | {result.Summary.ConstraintsAdded} |");
        md.AppendLine($"| 🗑️ 删除约束 | {result.Summary.ConstraintsRemoved} |");
        md.AppendLine($"| 📇 新增索引 | {result.Summary.IndexesAdded} |");
        md.AppendLine($"| 🗂️ 删除索引 | {result.Summary.IndexesRemoved} |");
        md.AppendLine();

        // 生成统一表格格式的差异报告
        if (result.HasDifferences)
        {
            md.AppendLine(GenerateUnifiedTable(result));
        }
        else
        {
            md.AppendLine("## ✅ 无差异");
            md.AppendLine();
            md.AppendLine("源数据库和目标数据库的Schema完全一致。");
        }

        await File.WriteAllTextAsync(outputPath, md.ToString(), ct);
    }

    private string GenerateUnifiedTable(ComparisonResult result)
    {
        var md = new StringBuilder();
        md.AppendLine("## 📊 详细差异");
        md.AppendLine();

        // 将所有差异转换为表格行
        var allRows = result.Differences
            .SelectMany(diff => ConvertDiffToTableRows(diff))
            .ToList();

        // 按表名分组
        var rowsByTable = allRows
            .GroupBy(r => r.TableName)
            .OrderBy(g => g.Key);

        // 为每个表生成一个独立的表格
        foreach (var tableGroup in rowsByTable)
        {
            md.AppendLine($"### 📋 {tableGroup.Key}");
            md.AppendLine();
            md.AppendLine("| 变化类型 | 对象名 | 属性 | 原值 | 新值 |");
            md.AppendLine("|---------|--------|------|------|------|");

            // 按变化类型排序
            var sortedRows = tableGroup.OrderBy(r => r.ChangeType);
            foreach (var row in sortedRows)
            {
                md.AppendLine($"| {row.ChangeType} | {row.ObjectName} | {row.Property} | {row.OldValue} | {row.NewValue} |");
            }

            md.AppendLine();
        }

        return md.ToString();
    }

    private List<TableRow> ConvertDiffToTableRows(SchemaDiff diff)
    {
        var rows = new List<TableRow>();
        var tableName = string.IsNullOrEmpty(diff.TableName)
            ? diff.SchemaName ?? "Unknown"
            : $"{diff.SchemaName}.{diff.TableName}";

        switch (diff)
        {
            case TableAddedDiff d:
                rows.Add(new TableRow
                {
                    TableName = tableName,
                    ChangeType = "✅ 新增表",
                    ObjectName = "-",
                    Property = "列数",
                    OldValue = "-",
                    NewValue = d.SourceTable.Columns.Count.ToString()
                });
                break;

            case TableRemovedDiff d:
                rows.Add(new TableRow
                {
                    TableName = tableName,
                    ChangeType = "❌ 删除表",
                    ObjectName = "-",
                    Property = "-",
                    OldValue = "-",
                    NewValue = "-"
                });
                break;

            case ColumnAddedDiff d:
                rows.Add(new TableRow
                {
                    TableName = tableName,
                    ChangeType = "➕ 新增列",
                    ObjectName = $"`{d.SourceColumn.ColumnName}`",
                    Property = "数据类型",
                    OldValue = "-",
                    NewValue = $"`{d.SourceColumn.GetFullDataType()}`"
                });
                break;

            case ColumnRemovedDiff d:
                rows.Add(new TableRow
                {
                    TableName = tableName,
                    ChangeType = "➖ 删除列",
                    ObjectName = $"`{d.TargetColumn.ColumnName}`",
                    Property = "-",
                    OldValue = "-",
                    NewValue = "-"
                });
                break;

            case ColumnTypeChangedDiff d:
                rows.Add(new TableRow
                {
                    TableName = tableName,
                    ChangeType = "🔄 修改列",
                    ObjectName = $"`{d.ColumnName}`",
                    Property = "数据类型",
                    OldValue = $"`{d.TargetColumn.GetFullDataType()}`",
                    NewValue = $"`{d.SourceColumn.GetFullDataType()}`"
                });
                break;

            case ColumnNullableChangedDiff d:
                rows.Add(new TableRow
                {
                    TableName = tableName,
                    ChangeType = "🔄 修改列",
                    ObjectName = $"`{d.ColumnName}`",
                    Property = "可空性",
                    OldValue = d.TargetNullable ? "是" : "否",
                    NewValue = d.SourceNullable ? "是" : "否"
                });
                break;

            case ColumnDefaultChangedDiff d:
                rows.Add(new TableRow
                {
                    TableName = tableName,
                    ChangeType = "🔄 修改列",
                    ObjectName = $"`{d.ColumnName}`",
                    Property = "默认值",
                    OldValue = d.TargetDefault ?? "无",
                    NewValue = d.SourceDefault ?? "无"
                });
                break;

            case PrimaryKeyAddedDiff d:
                var pkCols = string.Join(", ", d.PrimaryKey.ColumnNames);
                rows.Add(new TableRow
                {
                    TableName = tableName,
                    ChangeType = "🔒 新增主键",
                    ObjectName = $"`{d.PrimaryKey.ConstraintName}`",
                    Property = "列",
                    OldValue = "-",
                    NewValue = $"`{pkCols}`"
                });
                break;

            case PrimaryKeyRemovedDiff d:
                var pkColsRemoved = string.Join(", ", d.PrimaryKey.ColumnNames);
                rows.Add(new TableRow
                {
                    TableName = tableName,
                    ChangeType = "🗑️ 删除主键",
                    ObjectName = $"`{d.PrimaryKey.ConstraintName}`",
                    Property = "列",
                    OldValue = $"`{pkColsRemoved}`",
                    NewValue = "-"
                });
                break;

            case ForeignKeyAddedDiff d:
                var fkCols = string.Join(", ", d.ForeignKey.ColumnNames);
                var refTable = $"{d.ForeignKey.ReferencedSchemaName}.{d.ForeignKey.ReferencedTable}";
                var refCols = string.Join(", ", d.ForeignKey.ReferencedColumns);
                rows.Add(new TableRow
                {
                    TableName = tableName,
                    ChangeType = "🔗 新增外键",
                    ObjectName = $"`{d.ForeignKey.ConstraintName}`",
                    Property = "引用",
                    OldValue = "-",
                    NewValue = $"`{refTable}({refCols})`"
                });
                break;

            case ForeignKeyRemovedDiff d:
                rows.Add(new TableRow
                {
                    TableName = tableName,
                    ChangeType = "🗑️ 删除外键",
                    ObjectName = $"`{d.ForeignKey.ConstraintName}`",
                    Property = "-",
                    OldValue = "-",
                    NewValue = "-"
                });
                break;

            case IndexAddedDiff d:
                var idxCols = string.Join(", ", d.Index.Columns.Select(c => c.ColumnName));
                var idxType = d.Index.IndexType?.ToUpper() ?? "BTREE";
                var idxUnique = d.Index.IsUnique ? "唯一" : "非唯一";
                rows.Add(new TableRow
                {
                    TableName = tableName,
                    ChangeType = "📇 新增索引",
                    ObjectName = $"`{d.Index.IndexName}`",
                    Property = "类型/列",
                    OldValue = "-",
                    NewValue = $"{idxType}, `{idxCols}`, {idxUnique}"
                });
                break;

            case IndexRemovedDiff d:
                rows.Add(new TableRow
                {
                    TableName = tableName,
                    ChangeType = "🗂️ 删除索引",
                    ObjectName = $"`{d.Index.IndexName}`",
                    Property = "-",
                    OldValue = "-",
                    NewValue = "-"
                });
                break;

            case UniqueAddedDiff d:
                var uniqueCols = string.Join(", ", d.UniqueConstraint.ColumnNames);
                rows.Add(new TableRow
                {
                    TableName = tableName,
                    ChangeType = "🔒 新增唯一约束",
                    ObjectName = $"`{d.UniqueConstraint.ConstraintName}`",
                    Property = "列",
                    OldValue = "-",
                    NewValue = $"`{uniqueCols}`"
                });
                break;

            case UniqueRemovedDiff d:
                var uniqueColsRemoved = string.Join(", ", d.UniqueConstraint.ColumnNames);
                rows.Add(new TableRow
                {
                    TableName = tableName,
                    ChangeType = "🗑️ 删除唯一约束",
                    ObjectName = $"`{d.UniqueConstraint.ConstraintName}`",
                    Property = "列",
                    OldValue = $"`{uniqueColsRemoved}`",
                    NewValue = "-"
                });
                break;

            case CheckAddedDiff d:
                rows.Add(new TableRow
                {
                    TableName = tableName,
                    ChangeType = "✅ 新增检查约束",
                    ObjectName = $"`{d.CheckConstraint.ConstraintName}`",
                    Property = "定义",
                    OldValue = "-",
                    NewValue = d.CheckConstraint.ConstraintDefinition
                });
                break;

            case CheckRemovedDiff d:
                rows.Add(new TableRow
                {
                    TableName = tableName,
                    ChangeType = "🗑️ 删除检查约束",
                    ObjectName = $"`{d.CheckConstraint.ConstraintName}`",
                    Property = "-",
                    OldValue = "-",
                    NewValue = "-"
                });
                break;
        }

        return rows;
    }

    private class TableRow
    {
        public string TableName { get; set; } = string.Empty;
        public string ChangeType { get; set; } = string.Empty;
        public string ObjectName { get; set; } = string.Empty;
        public string Property { get; set; } = string.Empty;
        public string OldValue { get; set; } = string.Empty;
        public string NewValue { get; set; } = string.Empty;
    }
}
