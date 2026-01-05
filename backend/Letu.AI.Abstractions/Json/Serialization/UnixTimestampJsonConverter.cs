using System.Text.Json;
using System.Text.Json.Serialization;

namespace Letu.AI.Json.Serialization;

public class UnixTimestampJsonConverter : JsonConverter<DateTimeOffset>
{
    public override DateTimeOffset Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        var timestamp = reader.GetInt64();
        return DateTimeOffset.FromUnixTimeSeconds(timestamp).ToLocalTime();
    }

    public override void Write(Utf8JsonWriter writer, DateTimeOffset value, JsonSerializerOptions options)
    {
        var timestamp = value.ToUnixTimeSeconds();
        writer.WriteNumberValue(timestamp);
    }
}