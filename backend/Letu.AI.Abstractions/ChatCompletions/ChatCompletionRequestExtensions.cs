namespace Letu.AI.ChatCompletions;

public static class ChatCompletionRequestExtensions
{
    public static ChatCompletionRequest ApplySettings(this ChatCompletionRequest request, PromptExecutionSettings settings)
    {
        request.Stop ??= settings.Stop;
        request.TopP ??= settings.TopP;
        request.Temperature ??= settings.Temperature;
        request.ToolChoice ??= settings.ToolsChoice;
        request.UserId ??= settings.UserId;

        return request;
    }

    public static ChatCompletionRequest AddMessage(this ChatCompletionRequest request, AIMessage message)
    {
        request.Messages.Add(message);
        return request;
    }

    public static ChatCompletionRequest AddUserMessage(this ChatCompletionRequest request, string content)
    {
        request.Messages.Add(new StringAIMessage(MessageRoles.User, content));
        return request;
    }

    public static ChatCompletionRequest AddSystemMessage(this ChatCompletionRequest request, string content)
    {
        request.Messages.Add(new StringAIMessage(MessageRoles.System, content));
        return request;
    }

    public static ChatCompletionRequest AddToolMessage(this ChatCompletionRequest request, string toolCallId, string content)
    {
        request.Messages.Add(new StringAIMessage(toolCallId, content));
        return request;
    }

    /// <summary>
    /// 发给大模型之前移除它输出的思考过程。
    /// </summary>
    /// <param name="request"></param>
    /// <returns></returns>
    public static ChatCompletionRequest CleanupMessageThinkSection(this ChatCompletionRequest request)
    {
        request.Messages.ForEach(message =>
        {
            if (message.Role == MessageRoles.Assistant)
            {
                message.CleanupMessageThinkSection();
            }
        });

        return request;
    }


    public static ChatCompletionRequest AddTool(this ChatCompletionRequest request, Tool tool)
    {
        request.EnsureTools();
        request.Tools!.Add(tool);
        return request;
    }

    public static bool HasTool(this ChatCompletionRequest request)
    {
        return request.Tools?.Count > 0;
    }

    private static void EnsureTools(this ChatCompletionRequest request)
    {
        request.Tools ??= [];
    }
}
