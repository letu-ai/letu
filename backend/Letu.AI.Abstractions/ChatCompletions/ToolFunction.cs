using System.Text.Json.Serialization;
using Letu.AI.Json.Serialization;

namespace Letu.AI.ChatCompletions;

/// <summary>
/// 告诉大模型系统具有的function和参数信息
/// </summary>
public class ToolFunction
{

    public ToolFunction()
    {
    }

    public ToolFunction(string name, string description)
    {
        Name = name;
        Description = description;
    }

    /// <summary>
    /// 函数名称，只能包含a-z，A-Z，0-9，下划线和中横线。最大长度限制为64
    /// </summary>
    public string Name { get; set; } = string.Empty;

    public string Description { get; set; } = string.Empty;

    [JsonConverter(typeof(RawJsonConverter))]
    public string Parameters { get; set; } = string.Empty;
}
