namespace Letu.AI.ChatCompletions;

public static class AIMessageExtensions
{

    public static string GetContent(this AIMessage message)
    {
        if (message is StringAIMessage stringMsg)
        {
            return stringMsg.Content ?? "";
        }

        if (message is ObjectAIMessage objectMsg)
        {
            return objectMsg.Content
                .Where(c => c.Type == ContentTypes.Text)
                .Cast<TextContent>()
                .Select(c => c.Text)
                .Aggregate((current, next) => current + ", " + next);
        }

        return string.Empty;
    }

    /// <summary>
    /// 最佳差异内容。
    /// </summary>
    /// <param name="message"></param>
    /// <param name="delta"></param>
    /// <returns>差异的消息Content</returns>
    public static string? AppendDelta(this AIMessage message, AIMessage delta)
    {
        if (message is not StringAIMessage stringMsg || delta is not StringAIMessage stringDelta)
        {
            throw new ArgumentException($"仅支持对{typeof(StringAIMessage)}添加的增量数据", nameof(message));
        }

        string? result = null;
        if (!stringDelta.Content.IsNullOrEmpty())
        {
            stringMsg.Content += stringDelta.Content;
            result = stringDelta.Content;
        }

        if (!stringDelta.ToolCalls.IsNullOrEmpty())
        {
            var stringDeltaToolCall = stringDelta.ToolCalls![0];
            if (stringMsg.ToolCalls.IsNullOrEmpty())
            {
                stringMsg.ToolCalls = [new ToolCall()];
            }
            var toolCall = stringMsg.ToolCalls![0];
            toolCall.Id ??= stringDeltaToolCall.Id;
            toolCall.Index = stringDeltaToolCall.Index;
            toolCall.Type ??= stringDeltaToolCall.Type;

            var toolCallFunction = toolCall.Function ??= new ToolCallFunction();
            if (stringDeltaToolCall.Function != null)
            {
                if (!stringDeltaToolCall.Function.Name.IsNullOrEmpty())
                    toolCallFunction.Name = stringDeltaToolCall.Function.Name;

                if (!stringDeltaToolCall.Function.Arguments.IsNullOrEmpty())
                    toolCallFunction.Arguments += stringDeltaToolCall.Function.Arguments;
            }
        }

        return result;
    }

    /// <summary>
    /// 移除消息中从"<think>\n"开始到"</think>\n"结束的内容。
    /// </summary>
    /// <param name="request"></param>
    /// <returns></returns>
    public static AIMessage CleanupMessageThinkSection(this AIMessage message)
    {
        if (message is StringAIMessage stringMessage)
        {
            stringMessage.CleanupMessageThinkSection();
        }
        else if (message is ObjectAIMessage objectMessage)
        {
            objectMessage.CleanupMessageThinkSection();
        }

        return message;
    }


    private const string ThinkSectionStart = "<think>\n";
    private const string ThinkSectionEnd = "</think>\n";

    /// <summary>
    /// 删除文本中从"<think>\n"开始到"</think>\n"结束的内容。
    /// </summary>
    /// <param name="content"></param>
    /// <returns></returns>
    public static string CleanupMessageThinkSection(string content)
    {
        if (content.StartsWith(ThinkSectionStart))
        {
            var index = content.IndexOf(ThinkSectionEnd);
            if (index == -1)  // 没有找到</think>\n，则全部删除。
            {
                return "";
            }
            else
            {
                // 移除消息头开始删除直到</think>\n
                var endPosition = index + ThinkSectionEnd.Length;
                
                // 检查是否还有剩余内容
                if (endPosition >= content.Length)
                {
                    return ""; // 如果</think>\n正好是最后部分，返回空字符串
                }
                
                return content[endPosition..];
            }
        }

        return content;
    }
}