using System.Text.Json.Serialization;

namespace Letu.AI.ChatCompletions;

// 调用结束后返回的token使用情况
public class Usage
{
    /// <summary>
    /// 模型输出的 tokens 数量
    /// </summary>
    //[JsonPropertyName("completion_tokens")]
    public int CompletionTokens { get; set; }

    /// <summary>
    /// 用户输入的 tokens 数量
    /// </summary>
    //[JsonPropertyName("prompt_tokens")]
    public int PromptTokens { get; set; }

    /// <summary>
    /// 总tokens的数量
    /// </summary>
    //[JsonPropertyName("total_tokens")]
    public int TotalTokens { get; set; }
}
