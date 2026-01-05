namespace Letu.AI.ChatCompletions;

/// <summary>
/// 和客户端对话消息中的工具调用信息。
/// </summary>
public class ClientMessageToolCall
{
    public ClientMessageToolCall()
    {

    }

    public string CallId { get; set; } = string.Empty;

    public string PluginDisplayName { get; set; } = string.Empty;

    public string ToolName { get; set; } = "";

    /// <summary>
    /// 是否调用成功。
    /// </summary>
    public bool Success { get; set; }

    public string InputArguments { get; set; } = string.Empty;

    public string? OutputArguments { get; set; }

    /// <summary>
    /// 工具执行耗时。
    /// </summary>
    public TimeSpan Duration { get; set; }

}
