namespace Letu.AI.ChatCompletions;

public static class ToolExtensions
{
    public static ToolFunction AddFunction(this Tool tool, string name, string description)
    {
        tool.Function = new(name, description);
        return tool.Function;
    }
}
