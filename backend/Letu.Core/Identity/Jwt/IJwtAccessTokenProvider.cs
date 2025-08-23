using System.Security.Claims;

namespace Letu.Core.Identity.Jwt;

public interface IJwtAccessTokenProvider
{
    JwtAccessToken CreateToken(IEnumerable<Claim> claims,  int? expiresSeconds = null);
}
