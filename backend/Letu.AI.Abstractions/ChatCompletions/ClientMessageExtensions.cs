namespace Letu.AI.ChatCompletions;

public static class ClientMessageExtensions
{
    public static string GetContent(this ClientMessage message)
    {
        if (message is StringClientMessage stringMsg)
        {
            return stringMsg.Content;
        }

        if (message is ObjectClientMessage objectMsg)
        {
            return objectMsg.Content
                .Where(c => c.Type == ContentTypes.Text)
                .Cast<TextContent>()
                .Select(c => c.Text)
                .Aggregate((current, next) => current + ", " + next);
        }

        return string.Empty;
    }
}
