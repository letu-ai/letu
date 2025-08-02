using System.Security.Claims;
using Letu.Identity.Jwt;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;

using Volo.Abp.DependencyInjection;

namespace Letu.Basis.Identity.Jwt;

public class JwtAccessTokenProvider(IOptions<JwtOptions> jwtOptions)
    : IJwtAccessTokenProvider, ITransientDependency
{
    private readonly JwtOptions jwtOptions = jwtOptions.Value;

    public JwtAccessToken CreateToken(IEnumerable<Claim> claims, int? expiresSeconds = null)
    {
        if (expiresSeconds.HasValue && expiresSeconds <= 0)
        {
            throw new ArgumentException("expiresSeconds must be greater than 0");
        }

        var expires = DateTimeOffset.UtcNow.AddSeconds(expiresSeconds ?? jwtOptions.Issuance.ExpirySeconds);

        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(claims),
            Audience = jwtOptions.Issuance.Audience,
            Issuer = jwtOptions.Issuance.Issuer,
            IssuedAt = DateTime.UtcNow,
            NotBefore = DateTime.UtcNow,
            Expires = expires.UtcDateTime,
            SigningCredentials = new SigningCredentials(jwtOptions.GetValidationSecurityKey(), SecurityAlgorithms.HmacSha256Signature)
        };

        var jwtTokenHandler = new JsonWebTokenHandler();
        var token = jwtTokenHandler.CreateToken(tokenDescriptor);

        return new JwtAccessToken
        {
            Token = token,
            ExpiresAt = expires,
        };
    }
}
