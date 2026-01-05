using Letu.AI.ChatCompletions;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace Letu.AI.Json.Serialization;

/// <summary>
/// 根据Content类型的不同，反序列化成<see cref="StringClientMessage"/>或者<see cref="ObjectClientMessage"/>。
/// </summary>
public class ClientMessageJsonConverter : JsonConverter<ClientMessage>
{
    public override ClientMessage? Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        if (reader.TokenType != JsonTokenType.StartObject)
        {
            throw new JsonException();
        }

        using var doc = JsonDocument.ParseValue(ref reader);
        var root = doc.RootElement;

        var kind = root.GetProperty(GetPropertyName(nameof(StringAIMessage.Content), options)).ValueKind;
        return kind switch
        {
            JsonValueKind.String => JsonSerializer.Deserialize<StringClientMessage>(root.GetRawText(), options),
            JsonValueKind.Array => JsonSerializer.Deserialize<ObjectClientMessage>(root.GetRawText(), options),
            _ => throw new JsonException($"无效的Content类型：{kind}")
        };
    }

    public override void Write(Utf8JsonWriter writer, ClientMessage value, JsonSerializerOptions options)
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