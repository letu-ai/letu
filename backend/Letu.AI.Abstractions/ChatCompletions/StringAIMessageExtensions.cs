using System.Reflection.Metadata;

namespace Letu.AI.ChatCompletions;

public static class StringAIMessageExtensions
{
    public static StringAIMessage CleanupMessageThinkSection(this StringAIMessage message)
    {
        if (message.Content != null)
        {
            message.Content = AIMessageExtensions.CleanupMessageThinkSection(message.Content);
        }

        return message;
    }

}
