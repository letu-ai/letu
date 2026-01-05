using System.Text.Json.Serialization;

namespace Letu.AI.ChatCompletions;

public class Retrieval
{
    //[JsonPropertyName("knowledge_id")]
    public string KnowledgeId { get; set; } = string.Empty;

    //[JsonPropertyName("prompt_template")]
    public string PromptTemplate { get; set; } = string.Empty;
}
