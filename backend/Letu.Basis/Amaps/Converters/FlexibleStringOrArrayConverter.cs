using System.Text.Json;
using System.Text.Json.Serialization;

namespace Letu.Basis.Amaps.Converters;

/// <summary>
/// 处理高德API中既可能是字符串也可能是数组的字段
/// 例如：citycode 有值时为 "010"，无值时为 []
/// </summary>
public class FlexibleStringOrArrayConverter : JsonConverter<string?>
{
    public override string? Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        switch (reader.TokenType)
        {
            case JsonTokenType.String:
                // 如果是字符串，直接返回
                return reader.GetString();
            
            case JsonTokenType.StartArray:
                // 如果是数组，读取第一个元素（如果有）
                reader.Read(); // 进入数组
                
                if (reader.TokenType == JsonTokenType.EndArray)
                {
                    // 空数组，返回空字符串
                    return string.Empty;
                }
                
                if (reader.TokenType == JsonTokenType.String)
                {
                    var value = reader.GetString();
                    
                    // 跳过剩余的数组元素
                    while (reader.Read() && reader.TokenType != JsonTokenType.EndArray)
                    {
                        // 继续读取直到数组结束
                    }
                    
                    return value;
                }
                
                // 跳过非字符串元素
                while (reader.Read() && reader.TokenType != JsonTokenType.EndArray)
                {
                    // 继续读取直到数组结束
                }
                
                return string.Empty;
            
            case JsonTokenType.Null:
                return null;
            
            default:
                throw new JsonException($"Unexpected token type when parsing citycode: {reader.TokenType}");
        }
    }

    public override void Write(Utf8JsonWriter writer, string? value, JsonSerializerOptions options)
    {
        if (value == null)
        {
            writer.WriteNullValue();
        }
        else
        {
            writer.WriteStringValue(value);
        }
    }
}