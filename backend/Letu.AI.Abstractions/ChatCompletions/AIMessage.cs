using System.Text.Json.Serialization;
using Letu.AI.Json.Serialization;

namespace Letu.AI.ChatCompletions;

/// <summary>
/// 与大模型的对话消息抽象基类。
/// </summary>
[JsonConverter(typeof(AIMessageJsonConverter))]
public abstract class AIMessage(string role)
{
    public string Role { get; set; } = role;

    public string? ToolCallId { get; set; }

    public List<ToolCall>? ToolCalls { get; set; }

}
