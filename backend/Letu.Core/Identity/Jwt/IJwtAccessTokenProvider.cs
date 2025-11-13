using System.Security.Claims;

namespace Letu.Core.Identity.Jwt;

public interface IJwtAccessTokenProvider
{
    /// <summary>
    /// 创建JWT访问令牌。
    /// </summary>
    /// <param name="claims">令牌中包含的数据</param>
    /// <param name="expiresSeconds">令牌过期秒数</param>
    /// <param name="audience">令牌接收方标识，不填则使用Jwt配置的值</param>
    /// <param name="issuer">令牌签发方标识，不填则使用Jwt配置的值</param>
    /// <returns></returns>
    JwtAccessToken CreateToken(IEnumerable<Claim> claims, int? expiresSeconds = null, string? audience = null, string? issuer = null);
}
