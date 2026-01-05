using System.Text.Json;
using System.Text.Json.Serialization;

namespace Letu.AI.Json.Serialization;

/// <summary>
/// 属性是JSON字符串的转换器。
/// </summary>
public class RawJsonConverter : JsonConverter<string>
{

    public override string Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        using JsonDocument document = JsonDocument.ParseValue(ref reader);
        return JsonSerializer.Deserialize<dynamic>(document.RootElement.GetRawText(), options) ?? "{}";
    }

    public override void Write(Utf8JsonWriter writer, string value, JsonSerializerOptions options)
    {
        writer.WriteRawValue(value);
    }
}