using Letu.Core.Security.Serialization;

namespace Letu.AI.RagFlow;

public class RagflowSettings
{
    public string BaseUrl { get; set; } = "https://api.ragflow.com/v1";

    [EncryptedString]
    public string ApiKey { get; set; } = string.Empty;

}