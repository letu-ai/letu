namespace Letu.AI.ChatCompletions;

public static class ObjectAIMessageExtensions
{
    public static ObjectAIMessage CleanupMessageThinkSection(this ObjectAIMessage message)
    {
        for (int i = 0; i < message.Content.Length; i++)
        {
            if (message.Content[i] is TextContent textContent)
            {
                textContent.Text = AIMessageExtensions.CleanupMessageThinkSection(textContent.Text);
            }
        }

        return message;
    }
}

