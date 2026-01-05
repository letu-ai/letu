using Letu.AI.Json.Serialization;
using System.Text.Json.Serialization;

namespace Letu.AI.ChatCompletions;

/// <summary>
/// 与客户端的对话的消息
/// </summary>
[JsonConverter(typeof(ClientMessageJsonConverter))]
public abstract class ClientMessage
{
    /// <summary>
    /// 初始化 ClientMessage 类的新实例。
    /// </summary>
    /// <param name="role">对话角色。</param>
    public ClientMessage(string role)
    {
        Role = role;
        CreationTime = DateTimeOffset.Now;
    }

    /// <summary>
    /// 对话角色。
    /// </summary>
    public string Role { get; protected set; }

    public ClientMessageToolCall? ToolCall { get; set; }

    public DateTimeOffset CreationTime { get; set; }
}
