namespace Letu.AI.ChatCompletions;

public class ToolFunctionParameters
{
    public string Type => "object";

    public Dictionary<string, ToolFunctionParameterProperty> Properties { get; set; } = [];

    public List<string> Required { get; set; } = [];

}
