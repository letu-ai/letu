namespace Letu.AI.ChatCompletions;

public class StringClientMessage(string role, string content) : ClientMessage(role)
{
    /// <summary>
    /// 对话内容。
    /// </summary>
    public string Content { get; set; } = content;
}
