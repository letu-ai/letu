using DbCompareTool.Config;
using DbCompareTool.Core.Diff;
using DbCompareTool.Core.Interfaces;
using System.Text;

namespace DbCompareTool.Reporters;

public class HtmlReporter : IReportWriter
{
    public async Task WriteReportAsync(ComparisonResult result, string outputPath, ReportFormat format, CancellationToken ct = default)
    {
        var html = new StringBuilder();

        html.AppendLine("<!DOCTYPE html>");
        html.AppendLine("<html lang='zh-CN'>");
        html.AppendLine("<head>");
        html.AppendLine("    <meta charset='UTF-8'>");
        html.AppendLine("    <meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        html.AppendLine("    <title>PostgreSQL Schema 差异报告</title>");
        html.AppendLine("    <style>");
        html.AppendLine(GetCss());
        html.AppendLine("    </style>");
        html.AppendLine("</head>");
        html.AppendLine("<body>");
        html.AppendLine("    <div class='container'>");

        // 标题
        html.AppendLine("        <h1>🔍 PostgreSQL Schema 差异报告</h1>");
        html.AppendLine($"        <p class='meta'>生成时间: {result.GeneratedAt:yyyy-MM-dd HH:mm:ss}</p>");
        html.AppendLine($"        <p class='meta'>源数据库: {result.SourceDatabase}</p>");
        html.AppendLine($"        <p class='meta'>目标数据库: {result.TargetDatabase}</p>");

        // 概览卡片
        html.AppendLine("        <div class='summary'>");
        html.AppendLine("            <h2>📊 概览</h2>");
        html.AppendLine("            <div class='cards'>");
        html.AppendLine($"                <div class='card added'><span class='number'>{result.Summary.TablesAdded}</span><span class='label'>新增表</span></div>");
        html.AppendLine($"                <div class='card removed'><span class='number'>{result.Summary.TablesRemoved}</span><span class='label'>删除表</span></div>");
        html.AppendLine($"                <div class='card added'><span class='number'>{result.Summary.ColumnsAdded}</span><span class='label'>新增列</span></div>");
        html.AppendLine($"                <div class='card removed'><span class='number'>{result.Summary.ColumnsRemoved}</span><span class='label'>删除列</span></div>");
        html.AppendLine($"                <div class='card modified'><span class='number'>{result.Summary.ColumnsModified}</span><span class='label'>修改列</span></div>");
        html.AppendLine($"                <div class='card added'><span class='number'>{result.Summary.ConstraintsAdded}</span><span class='label'>新增约束</span></div>");
        html.AppendLine($"                <div class='card removed'><span class='number'>{result.Summary.ConstraintsRemoved}</span><span class='label'>删除约束</span></div>");
        html.AppendLine($"                <div class='card added'><span class='number'>{result.Summary.IndexesAdded}</span><span class='label'>新增索引</span></div>");
        html.AppendLine($"                <div class='card removed'><span class='number'>{result.Summary.IndexesRemoved}</span><span class='label'>删除索引</span></div>");
        html.AppendLine("            </div>");
        html.AppendLine("        </div>");

        // 差异详情
        if (result.HasDifferences)
        {
            html.AppendLine("        <div class='details'>");
            html.AppendLine("            <h2>📋 详细差异</h2>");

            var diffsByTable = result.Differences
                .GroupBy(d => new { d.SchemaName, d.TableName })
                .OrderBy(g => g.Key.SchemaName).ThenBy(g => g.Key.TableName);

            foreach (var tableGroup in diffsByTable)
            {
                var tableId = string.IsNullOrEmpty(tableGroup.Key.TableName)
                    ? tableGroup.Key.SchemaName ?? "Unknown"
                    : $"{tableGroup.Key.SchemaName}.{tableGroup.Key.TableName}";

                html.AppendLine($"            <div class='table-section'>");
                html.AppendLine($"                <h3>{tableId}</h3>");

                foreach (var diff in tableGroup)
                {
                    html.AppendLine(GetDiffHtml(diff));
                }

                html.AppendLine("            </div>");
            }

            html.AppendLine("        </div>");
        }
        else
        {
            html.AppendLine("        <div class='no-diff'>");
            html.AppendLine("            <h2>✅ 无差异</h2>");
            html.AppendLine("            <p>源数据库和目标数据库的Schema完全一致。</p>");
            html.AppendLine("        </div>");
        }

        html.AppendLine("    </div>");
        html.AppendLine("</body>");
        html.AppendLine("</html>");

        await File.WriteAllTextAsync(outputPath, html.ToString(), ct);
    }

    private string GetDiffHtml(SchemaDiff diff)
    {
        var html = $"<div class='diff-item {GetDiffClass(diff.DiffType)}'>";

        html += diff switch
        {
            TableAddedDiff d => $"<span class='badge added'>新增表</span> <code>{d.SourceTable.FullName}</code>",
            TableRemovedDiff d => $"<span class='badge removed'>删除表</span> <code>{d.TargetTable.FullName}</code>",
            ColumnAddedDiff d => $"<span class='badge added'>新增列</span> <code>{d.SourceColumn.ColumnName}</code> ({d.SourceColumn.GetFullDataType()})",
            ColumnRemovedDiff d => $"<span class='badge removed'>删除列</span> <code>{d.TargetColumn.ColumnName}</code>",
            ColumnTypeChangedDiff d => $"<span class='badge modified'>修改类型</span> <code>{d.ColumnName}</code>: {d.TargetColumn.GetFullDataType()} → {d.SourceColumn.GetFullDataType()}",
            ColumnNullableChangedDiff d => $"<span class='badge modified'>可空性</span> <code>{d.ColumnName}</code>: {d.TargetNullable} → {d.SourceNullable}",
            ColumnDefaultChangedDiff d => $"<span class='badge modified'>默认值</span> <code>{d.ColumnName}</code>: {d.TargetDefault ?? "无"} → {d.SourceDefault ?? "无"}",
            PrimaryKeyAddedDiff d => $"<span class='badge added'>新增主键</span> <code>{d.PrimaryKey.ConstraintName}</code> ({string.Join(", ", d.PrimaryKey.ColumnNames)})",
            PrimaryKeyRemovedDiff d => $"<span class='badge removed'>删除主键</span> <code>{d.PrimaryKey.ConstraintName}</code>",
            ForeignKeyAddedDiff d => $"<span class='badge added'>新增外键</span> <code>{d.ForeignKey.ConstraintName}</code> → {d.ForeignKey.ReferencedTable}",
            ForeignKeyRemovedDiff d => $"<span class='badge removed'>删除外键</span> <code>{d.ForeignKey.ConstraintName}</code>",
            IndexAddedDiff d => $"<span class='badge added'>新增索引</span> <code>{d.Index.IndexName}</code> ({string.Join(", ", d.Index.Columns.Select(c => c.ColumnName))})",
            IndexRemovedDiff d => $"<span class='badge removed'>删除索引</span> <code>{d.Index.IndexName}</code>",
            UniqueAddedDiff d => $"<span class='badge added'>新增唯一</span> <code>{d.UniqueConstraint.ConstraintName}</code>",
            UniqueRemovedDiff d => $"<span class='badge removed'>删除唯一</span> <code>{d.UniqueConstraint.ConstraintName}</code>",
            CheckAddedDiff d => $"<span class='badge added'>新增检查</span> <code>{d.CheckConstraint.ConstraintName}</code>",
            CheckRemovedDiff d => $"<span class='badge removed'>删除检查</span> <code>{d.CheckConstraint.ConstraintName}</code>",
            _ => $"<span class='badge'>未知</span> {diff.DiffType}"
        };

        html += "</div>";
        return html;
    }

    private string GetDiffClass(DiffType type)
    {
        return type switch
        {
            DiffType.TableAdded or DiffType.ColumnAdded or DiffType.PrimaryKeyAdded or
            DiffType.ForeignKeyAdded or DiffType.IndexAdded or DiffType.UniqueAdded or
            DiffType.CheckAdded => "diff-added",
            DiffType.TableRemoved or DiffType.ColumnRemoved or DiffType.PrimaryKeyRemoved or
            DiffType.ForeignKeyRemoved or DiffType.IndexRemoved or DiffType.UniqueRemoved or
            DiffType.CheckRemoved => "diff-removed",
            _ => "diff-modified"
        };
    }

    private string GetCss()
    {
        return @"
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); padding: 30px; }
        h1 { color: #333; margin-bottom: 10px; }
        .meta { color: #666; margin-bottom: 20px; }
        .summary { margin: 30px 0; }
        .summary h2 { margin-bottom: 15px; color: #333; }
        .cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(120px, 1fr)); gap: 15px; }
        .card { background: #f8f9fa; border-radius: 6px; padding: 15px; text-align: center; border: 1px solid #e9ecef; }
        .card.added { border-left: 4px solid #28a745; }
        .card.removed { border-left: 4px solid #dc3545; }
        .card.modified { border-left: 4px solid #ffc107; }
        .card .number { display: block; font-size: 28px; font-weight: bold; color: #333; }
        .card .label { font-size: 12px; color: #666; text-transform: uppercase; }
        .details { margin-top: 30px; }
        .details h2 { margin-bottom: 20px; color: #333; }
        .table-section { margin-bottom: 30px; border: 1px solid #e9ecef; border-radius: 6px; overflow: hidden; }
        .table-section h3 { background: #f8f9fa; padding: 12px 15px; font-size: 16px; color: #495057; border-bottom: 1px solid #e9ecef; }
        .diff-item { padding: 10px 15px; border-bottom: 1px solid #f1f3f4; }
        .diff-item:last-child { border-bottom: none; }
        .diff-item.diff-added { background: #f6fff8; }
        .diff-item.diff-removed { background: #fff8f8; }
        .diff-item.diff-modified { background: #fffbf0; }
        .badge { display: inline-block; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: bold; text-transform: uppercase; margin-right: 8px; }
        .badge.added { background: #d4edda; color: #155724; }
        .badge.removed { background: #f8d7da; color: #721c24; }
        .badge.modified { background: #fff3cd; color: #856404; }
        code { background: #f1f3f4; padding: 2px 6px; border-radius: 3px; font-family: 'Consolas', 'Monaco', monospace; font-size: 13px; }
        .no-diff { text-align: center; padding: 60px 20px; }
        .no-diff h2 { color: #28a745; font-size: 48px; margin-bottom: 10px; }
        .no-diff p { color: #666; font-size: 18px; }
        ";
    }
}
