using System.Collections.ObjectModel;
using System.Text.Json.Serialization;

namespace Letu.AI.ChatCompletions;

/// <summary>
/// 请求模型的参数.
/// </summary>
public class PromptExecutionSettings
{
    public PromptExecutionSettings(string modelName, string? apiKey)
    {
        ModelName = modelName;
        ApiKey = apiKey;
    }

    /// <summary>
    /// AI模型标识.
    /// 例如 gpt-4, gpt-3.5-turbo
    /// </summary>
    public string ModelName { get; set; }

    public string? ApiKey { get; set; }

    public Uri? EndPoint { get; set; }

    public double? Temperature { get; set; }

    public double? TopP { get; set; }

    public int? MaxTokens { get; set; }

    /// <summary>Controls which function the model calls (e.g., "none" or "auto").</summary>
    public string? ToolsChoice { get; set; }

    /// <summary>Sequences where model stops generating tokens.</summary>
    public List<string>? Stop { get; set; }

    public string? UserId { get; set; }

    /// <summary>
    /// 扩展数据。
    /// </summary>
    [JsonExtensionData]
    public Dictionary<string, object> ExtensionData { get; set; } = [];

}