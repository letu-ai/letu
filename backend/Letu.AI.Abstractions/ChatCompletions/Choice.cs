namespace Letu.AI.ChatCompletions;

// 选择项
public class Choice
{
    // 索引
    public int Index { get; set; }

    /// <summary>
    /// 模型推理终止的原因。
    /// </summary>
    //[JsonPropertyName("finish_reason")]
    public FinishReason FinishReason { get; set; }

    /// <summary>
    /// 消息内容
    /// </summary>
    public required AIMessage Message { get; set; }
}
