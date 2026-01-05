using System.Text.Json.Serialization;

namespace Letu.AI.ChatCompletions;


public class TextContent(string text) : ContentBase(ContentTypes.Text)
{
    public TextContent()
        : this("")
    {
    }

    public string Text { get; set; } = text;
}
