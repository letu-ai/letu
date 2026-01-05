using System.Text.Json;
using System.Text.Json.Serialization;
using Letu.AI.ChatCompletions;

namespace Letu.AI.Json.Serialization;

public class FinishReasonEnumJsonConverter : JsonConverter<FinishReason>
{

    public override FinishReason Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        var enumValue = reader.GetString();
        if (enumValue?.ToLower() == "stop")
        {
            return FinishReason.Stop;
        }

        if (enumValue?.ToLower() == "tool_calls")
        {
            return FinishReason.ToolCalls;
        }

        if (enumValue?.ToLower() == "length")
        {
            return FinishReason.Length;
        }

        if (enumValue?.ToLower() == "sensitivite")
        {
            return FinishReason.Sensitivite;
        }


        if (enumValue?.ToLower() == "network_error")
        {
            return FinishReason.NetworkError;
        }

        throw new JsonException($"{enumValue}不是有效的FinishReason枚举值");
    }

    public override void Write(Utf8JsonWriter writer, FinishReason value, JsonSerializerOptions options)
    {
        var valueString = value switch
        {
            FinishReason.ToolCalls => "tool_calls",
            FinishReason.NetworkError => "network_error",
            _ => value.ToString().ToLower(),
        };

        writer.WriteStringValue(valueString);
    }
}