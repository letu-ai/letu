using Letu.AI.Json.Serialization;
using System.Text.Json.Serialization;

namespace Letu.AI.ChatCompletions;

public class ChatCompletionRequest
{
    // 构造函数
    public ChatCompletionRequest(string modelName)
    {
        Model = modelName;
        RequestId = Guid.NewGuid().ToString();
    }

    // 模型名称
    public string Model { get; set; }

    // 消息列表，包含角色和内容
    public List<AIMessage> Messages { get; set; } = [];

    public string RequestId { get; set; }

    public bool? DoSample { get; set; }

    /// <summary>
    /// 是否使用流式传输
    /// </summary>
    public bool? Stream { get; set; }

    [JsonConverter(typeof(DoublePrecisionConverter))]
    public double? Temperature { get; set; }

    [JsonConverter(typeof(DoublePrecisionConverter))]
    public double? TopP { get; set; }

    public int? MaxTokens { get; set; }

    public List<string>? Stop { get; set; }

    // 工具列表，如果有的话
    public List<Tool>? Tools { get; set; }

    /// <summary>
    /// 工具选择策略
    /// </summary>
    public string? ToolChoice { get; set; }

    public string? UserId { get; set; }
}
