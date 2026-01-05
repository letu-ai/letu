namespace Letu.AI.ChatCompletions;

/// <summary>
/// 大模型返回调用工具的参数
/// </summary>
public class ToolCall
{
    public string? Id { get; set; }

    public int Index { get; set; }

    public string? Type { get; set; }

    public ToolCallFunction? Function { get; set; }
}
