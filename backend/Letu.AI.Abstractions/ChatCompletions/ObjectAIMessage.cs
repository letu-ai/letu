namespace Letu.AI.ChatCompletions;

/// <summary>
/// 与大模型的对话带附件的消息。
/// </summary>
public class ObjectAIMessage(string role) : AIMessage(role)
{
    public ContentBase[] Content { get; set; } = [];
}
