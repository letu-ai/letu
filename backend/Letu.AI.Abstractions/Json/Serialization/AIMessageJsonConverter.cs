using Letu.AI.ChatCompletions;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace Letu.AI.Json.Serialization;

/// <summary>
/// 根据Role的不同，指定Json反序列化的类型。
/// </summary>
public class AIMessageJsonConverter : JsonConverter<AIMessage>
{
    public override AIMessage? Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        if (reader.TokenType != JsonTokenType.StartObject)
        {
            throw new JsonException();
        }

        using var doc = JsonDocument.ParseValue(ref reader);
        var root = doc.RootElement;


        if (root.TryGetProperty(GetPropertyName(nameof(StringAIMessage.Content), options), out var element))
        {
            return element.ValueKind switch
            {
                JsonValueKind.String => JsonSerializer.Deserialize<StringAIMessage>(root.GetRawText(), options),
                JsonValueKind.Array => JsonSerializer.Deserialize<ObjectAIMessage>(root.GetRawText(), options),
                _ => throw new JsonException($"无效的Content类型：{element.ValueKind}")
            };
        }

        var message = JsonSerializer.Deserialize<StringAIMessage>(root.GetRawText(), options) ?? throw new JsonException("反序列化AIMessage失败");
        // AI服务返回Tool call时没有content属性。
        message.Content = null;
        return message;
    }

    public override void Write(Utf8JsonWriter writer, AIMessage value, JsonSerializerOptions options)
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