using System.Text.Json;
using System.Text.Json.Serialization;

namespace Letu.AI.Json.Serialization;

/// <summary>
/// 序列化时控制输出小数的精度。
/// </summary>
public class DoublePrecisionConverter : JsonConverter<double?>
{
    private readonly int precision = 2;

    public DoublePrecisionConverter()
    {
    }

    public override double? Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        if (reader.TokenType == JsonTokenType.Null)
        {
            return null;
        }

        return reader.GetDouble();
    }

    public override void Write(Utf8JsonWriter writer, double? value, JsonSerializerOptions options)
    {
        if (value.HasValue)
        {
            writer.WriteNumberValue(Math.Round(value.Value, precision));
        }
        else
        {
            writer.WriteNullValue();
        }
    }
}
