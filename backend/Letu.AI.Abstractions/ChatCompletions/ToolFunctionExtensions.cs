namespace Letu.AI.ChatCompletions;

public static class ToolFunctionExtensions
{
    //public static ToolFunction AddParameter(this ToolFunction toolFunction, string type, string name, string description)
    //{
    //    toolFunction.Parameters.Properties[name] = new(type, description);

    //    return toolFunction;
    //}

    //public static ToolFunction AddStringParameter(this ToolFunction toolFunction, string name, string description)
    //{
    //    toolFunction.Parameters.Properties[name] = new("string", description);

    //    return toolFunction;
    //}

    //public static ToolFunction AddNumberParameter(this ToolFunction toolFunction, string name, string description)
    //{
    //    toolFunction.Parameters.Properties[name] = new("number", description);

    //    return toolFunction;
    //}

    //public static ToolFunction AddEnumParameter(this ToolFunction toolFunction, string name, string description, List<string> enumValues)
    //{
    //    toolFunction.Parameters.Properties[name] = new("string", description)
    //    {
    //        Enum = enumValues
    //    };

    //    return toolFunction;
    //}

    //public static ToolFunction AddBooleanParameter(this ToolFunction toolFunction, string name, string description)
    //{
    //    toolFunction.Parameters.Properties[name] = new("boolean", description);

    //    return toolFunction;
    //}

    //public static ToolFunction AddRequiredParameters(this ToolFunction toolFunction, params string[] names)
    //{
    //    foreach (var name in names)
    //    {
    //        if (toolFunction.Parameters.Required.Contains(name) == false)
    //            toolFunction.Parameters.Required.Add(name);
    //    }

    //    return toolFunction;
    //}

    //public static ToolFunction SetRequiredParameters(this ToolFunction toolFunction, params string[] names)
    //{
    //    toolFunction.Parameters.Required.Clear();
    //    toolFunction.Parameters.Required.AddRange(names);

    //    return toolFunction;
    //}
}
