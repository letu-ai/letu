namespace Letu.AI.ChatCompletions;

/// <summary>
/// 与大模型的对话的普通文本消息。
/// </summary>
public class StringAIMessage(string role, string content) : AIMessage(role)
{
    public string? Content { get; set; } = content;
}