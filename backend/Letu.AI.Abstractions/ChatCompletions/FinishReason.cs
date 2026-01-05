using System.Text.Json.Serialization;
using Letu.AI.Json.Serialization;

namespace Letu.AI.ChatCompletions;

/// <summary>
/// 模型推理终止的原因。
/// </summary>
[JsonConverter(typeof(FinishReasonEnumJsonConverter))]
public enum FinishReason
{
    /// <summary>
    /// 代表推理自然结束或触发停止词。
    /// </summary>
    Stop,

    /// <summary>
    /// 代表模型命中函数。
    /// </summary>
    ToolCalls,

    /// <summary>
    /// 代表到达 tokens 长度上限。
    /// </summary>
    Length,

    /// <summary>
    /// 代表模型推理内容被安全审核接口拦截。请注意，针对此类内容，请用户自行判断并决定是否撤回已公开的内容。
    /// </summary>
    Sensitivite,

    /// <summary>
    /// 代表模型推理异常。
    /// </summary>
    NetworkError,
}
