using Letu.Core.Security.Serialization;
using Volo.Abp.Auditing;

namespace Letu.Basis.Amaps;

public class AmapSettings
{
    [DisableAuditing]
    [EncryptedString]
    public string? ApiKey { get; set; }

    [DisableAuditing]
    [EncryptedString]
    public string? SecurityJsCode { get; set; }
}
