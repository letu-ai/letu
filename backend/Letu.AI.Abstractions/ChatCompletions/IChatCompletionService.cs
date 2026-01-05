namespace Letu.AI.ChatCompletions;
public interface IChateCompletionService
{
    void Init(PromptExecutionSettings settings);

    IAsyncEnumerable<StreamingChatCompletionResposne> GetStreamingChatMessageContentsAsync(ChatCompletionRequest request, CancellationToken cancellationToken);
}