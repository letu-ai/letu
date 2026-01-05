namespace Letu.AI.ChatCompletions;

// 工具调用类
public class Tool
{
    public Tool()
    {
        Type = "function";
    }

    public string Id { get; set; } = string.Empty;

    public string Type { get; set; } = string.Empty;

    public ToolFunction? Function { get; set; }

    public Retrieval? Retrieval { get; set; }

    public WebSearchRequest? WebSearch { get; set; }
}
