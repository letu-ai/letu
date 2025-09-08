using System.Net;
using Letu.Basis.Account;
using Letu.Basis.Account.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Volo.Abp.AspNetCore.Mvc;

namespace Letu.Basis.Controllers.Accont;

[Authorize]
[ApiController]
[Route("api/account")]
public class AccountController : AbpControllerBase
{
    private readonly IAccountAppService accountAppService;

    public AccountController(IAccountAppService accountAppService)
    {
        this.accountAppService = accountAppService;
    }

    [AllowAnonymous]
    [HttpGet("login-settings")]
    public async Task<LoginSettingsOutput> OnGetLoginSettingsAsync()
    {
        return await accountAppService.GetLoginSettingsAsync();
    }

    [AllowAnonymous]
    [HttpPost("switch-tenant")]
    public async Task<SwitchTenantOutput> SwitchTenant(string? tenantName)
    {
        var result = await accountAppService.SwitchTenantAsync(tenantName);
        if (result.Success) {
            // 设置Cookie选项
            var cookieOptions = new CookieOptions
            {
                Path = "/",
                HttpOnly = true,
                Secure = true,
                SameSite = SameSiteMode.Lax,
            };

            if (result.TenantId.HasValue)
            {
                // 如果租户ID存在，设置Cookie
                cookieOptions.MaxAge = TimeSpan.FromSeconds(31536000); // 1年
                Response.Cookies.Append(result.CookieKey, result.TenantId.ToString()!, cookieOptions);
            }
            else
            {
                // 如果租户ID为空表示登录主站，则删除Cookie
                cookieOptions.MaxAge = TimeSpan.Zero;
                Response.Cookies.Append(result.CookieKey, "", cookieOptions);
            }
            
            return result;
        }
        
        return result;
    }
}