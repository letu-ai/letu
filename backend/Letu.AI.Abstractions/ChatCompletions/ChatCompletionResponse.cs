using System.Text.Json.Serialization;
using Letu.AI.Json.Serialization;

namespace Letu.AI.ChatCompletions;

public class ChatCompletionResponse
{
    // 任务ID
    public string Id { get; set; } = string.Empty;

    /// <summary>
    /// 请求创建时间
    /// </summary>
    [JsonConverter(typeof(UnixTimestampJsonConverter))]
    public DateTimeOffset Created { get; set; }

    // 模型名称
    public string Model { get; set; } = string.Empty;

    // 模型输出内容列表
    public List<Choice> Choices { get; set; } = [];

    // 调用结束后返回的token使用情况
    public Usage Usage { get; set; } = new();

    // 与网络搜索相关的返回信息（如果有）
    //[JsonPropertyName("web_search")]
    public List<WebSearch>? WebSearch { get; set; }
}
