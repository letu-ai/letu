namespace Letu.AI.ChatCompletions;

public class ToolFunctionParameterProperty
{
    public ToolFunctionParameterProperty(string type, string description)
    {
        Type = type;
        Description = description;
    }

    public string Type { get; set; } = string.Empty;

    public string Description { get; set; } = string.Empty;

    /// <summary>
    /// 参数可选的枚举列表。
    /// </summary>
    public List<string>? Enum { get; set; }
}