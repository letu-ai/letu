using System.Text.Json.Serialization;

namespace Letu.Core.Identity.Jwt;
public class JwtAccessToken
{

    public required string Token { get; set; }

    /// <summary>
    /// 刷新Token的Token。
    /// </summary>
    public string? RefreshToken { get; set; }

    /// <summary>
    /// Token类型，固定为“Bearer”
    /// </summary>
    public string Type { get; } = "Bearer";

    //public string? SessionId { get; set; }

    /// <summary>
    /// Token过期的UTC时间。
    /// </summary>
    public DateTimeOffset ExpiresAt { get; set; }
}
