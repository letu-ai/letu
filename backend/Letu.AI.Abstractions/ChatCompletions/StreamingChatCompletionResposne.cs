using System.Text.Json.Serialization;
using Letu.AI.Json.Serialization;

namespace Letu.AI.ChatCompletions;

public class StreamingChatCompletionResposne
{
    // 任务ID
    public string Id { get; set; } = string.Empty;

    // 请求创建时间，Unix时间戳（秒）
    [JsonConverter(typeof(UnixTimestampJsonConverter))]
    public DateTimeOffset Created { get; set; }

    // 模型名称
    public required string Model { get; set; }

    // 模型输出内容列表
    public List<StreamingChoice> Choices { get; set; } = [];

    // 调用结束后返回的token使用情况
    public Usage Usage { get; set; } = new();

    // 与网络搜索相关的返回信息（如果有）
    //[JsonPropertyName("web_search")]
    public List<WebSearch>? WebSearch { get; set; }

    /// <summary>
    /// 大模型返回消息表示需要调用工具。
    /// </summary>
    /// <returns></returns>
    public List<ToolCall>? TryGetToolCall()
    {
        if (Choices.IsNullOrEmpty())
            return null;

        if (Choices[0].Delta.ToolCalls.IsNullOrEmpty())
            return Choices[0].Delta.ToolCalls;
        else
            return null;
    }

    /// <summary>
    /// 流式消息已经结束。
    /// </summary>
    /// <returns></returns>
    public FinishReason? GetFinishReason()
    {
        return Choices.FirstOrDefault()?.FinishReason;
    }
}
