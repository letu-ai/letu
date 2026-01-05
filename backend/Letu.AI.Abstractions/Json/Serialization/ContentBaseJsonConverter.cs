using Letu.AI.ChatCompletions;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace Letu.AI.Json.Serialization;

/// <summary>
/// 根据Role的不同，指定Json反序列化的类型。
/// </summary>
public class ContentBaseJsonConverter : JsonConverter<ContentBase>
{
    public override ContentBase? Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        if (reader.TokenType != JsonTokenType.StartObject)
        {
            throw new JsonException();
        }

        using var doc = JsonDocument.ParseValue(ref reader);
        var root = doc.RootElement;

        var type = root.GetProperty(GetPropertyName(nameof(ContentBase.Type), options)).GetString();
        return type switch
        {
            ContentTypes.Text => JsonSerializer.Deserialize<TextContent>(root.GetRawText(), options),
            ContentTypes.ImageUrl => JsonSerializer.Deserialize<ImageUrlContent>(root.GetRawText(), options),
            ContentTypes.ImageAttachment => JsonSerializer.Deserialize<ImageAttachmentContent>(root.GetRawText(), options),
            _ => throw new JsonException($"无效的Content类型：{type}")
        };
    }

    public override void Write(Utf8JsonWriter writer, ContentBase value, JsonSerializerOptions options)
    {
        JsonSerializer.Serialize(writer, value, value.GetType(), options);
    }

    private string GetPropertyName(string propertyName, JsonSerializerOptions options)
    {
        if (options.PropertyNamingPolicy != null)
            return options.PropertyNamingPolicy.ConvertName(propertyName);
        else
            return propertyName;

    }
}