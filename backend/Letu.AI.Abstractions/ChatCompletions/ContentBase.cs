using Letu.AI.Json.Serialization;
using System.Text.Json.Serialization;

namespace Letu.AI.ChatCompletions;

[JsonConverter(typeof(ContentBaseJsonConverter))]
public abstract class ContentBase(string type)
{
    public string Type { get; set; } = type;
}
