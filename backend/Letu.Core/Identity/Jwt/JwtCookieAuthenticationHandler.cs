using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.Text.Encodings.Web;

namespace Letu.Core.Identity.Jwt;

/// <summary>
/// 支持从 Cookie 中读取 JWT Token 的认证处理器
/// </summary>
public class JwtCookieAuthenticationHandler : JwtBearerHandler
{
    private const string CookieName = "jwt-token";

    public JwtCookieAuthenticationHandler(IOptionsMonitor<JwtBearerOptions> options, ILoggerFactory logger, UrlEncoder encoder)
        : base(options, logger, encoder)
    {
    }

    protected override Task<AuthenticateResult> HandleAuthenticateAsync()
    {
        // 如果没有 Authorization 头，尝试从 Cookie 读取 token
        if (!Request.Headers.ContainsKey("Authorization"))
        {
            var token = GetTokenFromCookie();
            if (!string.IsNullOrEmpty(token))
            {
                // 只有当 Cookie 中有 token 时才设置 Authorization 头
                Context.Request.Headers["Authorization"] = $"Bearer {token}";
            }
        }
        
        // 无论是否找到 token，都交给基类处理
        // 基类会正确处理有 token、无 token、token 无效等各种情况
        return base.HandleAuthenticateAsync();
    }

    private string? GetTokenFromCookie()
    {
        if (Request.Cookies.TryGetValue(CookieName, out var cookieValue))
        {
            return cookieValue;
        }

        return null;
    }
}