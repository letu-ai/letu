using Letu.Core.Security.Serialization;

namespace Letu.AI.Fastgpt;

public class FastgptSettings
{
    public string BaseUrl { get; set; } = "https://api.fastgpt.com/v1";

    [EncryptedString]
    public string ApiKey { get; set; } = string.Empty;

}