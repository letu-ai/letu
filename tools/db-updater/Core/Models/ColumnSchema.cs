namespace DbCompareTool.Core.Models;

public class ColumnSchema
{
    public string ColumnName { get; set; } = string.Empty;
    public string DataType { get; set; } = string.Empty;
    public bool IsNullable { get; set; }
    public string? DefaultValue { get; set; }
    public string? ColumnComment { get; set; }
    public int? CharacterMaximumLength { get; set; }
    public int? NumericPrecision { get; set; }
    public int? NumericScale { get; set; }
    public int? DateTimePrecision { get; set; }
    public int? OrdinalPosition { get; set; }
    public bool IsIdentity { get; set; }
    public string? IdentityGeneration { get; set; }
    public bool IsGenerated { get; set; }
    public string? GenerationExpression { get; set; }

    public string GetFullDataType()
    {
        var type = DataType.ToUpperInvariant();

        if (CharacterMaximumLength.HasValue && type is "VARCHAR" or "CHAR" or "BPCHAR")
        {
            return $"{type}({CharacterMaximumLength.Value})";
        }

        // 对于 NUMERIC 和 DECIMAL，支持精度和标度
        if (NumericPrecision.HasValue && NumericScale.HasValue && type is "NUMERIC" or "DECIMAL")
        {
            return $"{type}({NumericPrecision.Value},{NumericScale.Value})";
        }

        // 对于 NUMERIC 和 DECIMAL，仅支持精度
        if (NumericPrecision.HasValue && type is "NUMERIC" or "DECIMAL")
        {
            return $"{type}({NumericPrecision.Value})";
        }

        // 时间类型：处理 TIMESTAMP WITH/WITHOUT TIME ZONE 的精度
        if (DateTimePrecision.HasValue && type.Contains("TIME"))
        {
            // 如果类型包含 "WITHOUT TIME ZONE" 或 "WITH TIME ZONE"，需要特殊处理
            if (type.Contains("WITHOUT TIME ZONE"))
            {
                return $"TIMESTAMP({DateTimePrecision.Value}) WITHOUT TIME ZONE";
            }
            else if (type.Contains("WITH TIME ZONE"))
            {
                return $"TIMESTAMP({DateTimePrecision.Value}) WITH TIME ZONE";
            }
            else
            {
                return $"{type}({DateTimePrecision.Value})";
            }
        }

        return type;
    }
}
