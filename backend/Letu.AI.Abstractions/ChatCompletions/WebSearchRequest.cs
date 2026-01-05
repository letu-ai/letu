using System.Text.Json.Serialization;

namespace Letu.AI.ChatCompletions;

public class WebSearchRequest
{
    /// <summary>
    /// 是否启用搜索。
    /// 默认：false
    /// </summary>
    public bool Enable { get; set; } = false;

    /// <summary>
    /// 强制搜索自定义关键内容，此时模型会根据自定义搜索关键内容返回的结果作为背景知识来回答用户发起的对话。
    /// </summary>
    //[JsonPropertyName("search_query")]
    public string? SearchQuery { get; set; }

    /// <summary>
    /// 获取详细的网页搜索来源信息，包括来源网站的图标、标题、链接、来源名称以及引用的文本内容。
    /// 默认:false。
    /// </summary>
    //[JsonPropertyName("search_result")]
    public bool SearchResult { get; set; }
}
